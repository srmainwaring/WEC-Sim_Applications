"""
Use capytaine to generate the BEM coefficients for an ellipsoid.
"""

import capytaine as cpt
import numpy as np
import os
import sys
import xarray as xr

# Reworking of the script in WEC_SIM/examples/BEMIO/CAPYTAINE to generate the BEM data.
#
# The main difference is that this is single threaded.

# 1. set up input parameters --------------------------------------------------#

# file io parameters
bem_mesh_name = "ellipsoid_f5244"
bem_modpath = os.path.dirname(__file__)
bem_mesh_file = os.path.join(bem_modpath, "..", "geometry", bem_mesh_name + ".stl")
bem_nc_file = os.path.join(bem_modpath, bem_mesh_name + ".nc")
print(f"bem_modpath:      {bem_modpath}")
print(f"bem_mesh_file:    {bem_mesh_file}")
print(f"bem_nc_file:      {bem_nc_file}")

# physical parameters
bem_g = 9.81
bem_rho = 1025.0
print(f"bem_g:            {bem_g} m/s^2")
print(f"bem_rho:          {bem_rho} kg/m^3")

# body parameters - the ellipsoid from WEC-SIM_Applications/Nonlinear_Hydro
#                   is centred at the CoM.
bem_body_name = "ellipsoid"
bem_translate = np.array([0, 0, -2])
bem_com = np.array([0, 0, -2])
print(f"bem_body_name:    {bem_body_name}")
print(f"bem_translate:    {bem_translate} m")
print(f"bem_com:          {bem_com} m")

# boundary condition parameters
bem_water_depth = np.infty
print(f"bem_water_depth:  {bem_water_depth} m")

# wave parameters - angular frequencies (rad/s) and directions (rad)
# bem_wave_omega = np.linspace(0.03, 9.24, 308)
bem_wave_omega = np.linspace(0.3, 10.0, 101)
bem_wave_direction = np.linspace(0.0, 0.0, 1)


def run_bem_solver():
    """
    Define and solve the BEM problems and save results to a NetCDF file.
    """

    # 1. load mesh and set up floating body -----------------------------------#
    # load mesh
    body = cpt.FloatingBody.from_file(
        bem_mesh_file, file_format="stl", name="ellipsoid"
    )

    # translate mesh so origin aligns with geometric center
    body.translate_x(bem_translate[0])
    body.translate_y(bem_translate[1])
    body.translate_z(bem_translate[2])

    # set CoM
    body.center_of_mass = bem_com
    print(f"center_of_mass:   {body.center_of_mass} m")

    # set rotation centre
    body.rotation_center = body.center_of_mass
    print(f"rotation_center:  {body.rotation_center} m")

    # add dofs
    body.add_all_rigid_body_dofs()
    print(f"body_dofs:        {body.dofs.keys()}")

    # clip at water plane
    body.keep_immersed_part()

    # -------------------------------------------------------------------------#
    # 2. compute hydrostatics
    body.compute_hydrostatics(rho=bem_rho, g=bem_g)
    body.hydrostatic_stiffness = body.compute_hydrostatic_stiffness(
        rho=bem_rho, g=bem_g
    )
    body.inertia_matrix = body.compute_rigid_body_inertia(rho=bem_rho)

    # -------------------------------------------------------------------------#
    # 3. pose and solve the linear potential problems

    print(
        f"\nCalling Capytaine BEM solver\n"
        f"mesh:       {bem_mesh_file}\n"
        f"omega:      {bem_wave_omega[0]:.3f} - {bem_wave_omega[-1]:.3f} rad/s\n"
        f"domega:     {bem_wave_omega[1] - bem_wave_omega[1]:.3f} rad/s\n"
        f"direction:  {bem_wave_direction[0]:.3f} - {bem_wave_direction[-1]:.3f} rad\n"
        f"num omega:  {len(bem_wave_omega)}\n"
        f"num dir:    {len(bem_wave_direction)}\n"
        f"num radiation & diffraction problems: "
        f"{len(bem_wave_omega)*len(bem_wave_direction)*len(body.dofs)}\n"
    )

    # create a dataset defining the problems
    problems = xr.Dataset(
        coords={
            "body_name": [body.name],
            "g": bem_g,
            "rho": bem_rho,
            "omega": bem_wave_omega,
            "water_depth": [bem_water_depth],
            "wave_direction": bem_wave_direction,
            "radiating_dof": list(body.dofs),
        }
    )

    # set up solver
    solver = cpt.BEMSolver()

    dataset = solver.fill_dataset(
        problems,
        [body],
        hydrostatics=True,
        wavelength=True,
        wavenumber=True,
    )

    # save result to file
    cpt.io.xarray.separate_complex_values(dataset).to_netcdf(bem_nc_file)

    print(f"Capytaine calcs complete. Data saved to:\n{bem_nc_file}\n\n")


def call_capy():
    """
    load and run the WEC-SIM call_capytaine module
    """
    moduledir = os.path.join(
        bem_modpath, "..", "..", "..", "WEC-SIM", "examples", "BEMIO", "CAPYTAINE"
    )
    sys.path.append(moduledir)
    # print(f"moduledir: {moduledir}")
    import call_capytaine as cc

    # NOTE: call_capy expects meshFName, CoG, and body_name to be tuples.
    cc.call_capy(
        meshFName=(bem_mesh_file,),
        wCapy=bem_wave_omega,
        CoG=(bem_com,),
        headings=bem_wave_direction,
        ncFName=bem_nc_file,
        body_name=(bem_body_name,),
        depth=bem_water_depth,
        density=bem_rho,
        translate=(bem_com,),
    )


if __name__ == "__main__":
    # set use_wec_sim to 1 to use WEC-Sim function defined in
    # WEC_Sim/examples/BEMIO/CAPYTAIN/call_capytain.py
    use_wec_sim = 1

    if use_wec_sim:
        call_capy()
    else:
        run_bem_solver()
