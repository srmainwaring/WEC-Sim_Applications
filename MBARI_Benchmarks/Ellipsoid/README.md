# Ellipsoid free body example

Simple example using the ellipsoid model from the Nonlinear_Hydro example.

- BEM data from Capytaine
- Regular waves only
- Linear model
- No PTO

## Workflow

### 0. Check out the dev version of WEC-SIM

Examples using `capytaine 1.4.1` must use the `dev` branches of WEC-Sim and
WEC-Sim_Applications because an issue reading capytaine NetCDF files:

- [readCAPYTAINE not working for current Capytaine .nc output files](https://github.com/WEC-Sim/WEC-Sim/issues/875)

which is fixed in:

- [Fix readCAPYTAINE](https://github.com/WEC-Sim/WEC-Sim/pull/884)

but has only been merged into [WEC-Sim:dev](https://github.com/WEC-Sim/WEC-Sim/tree/dev).


### 1. Generate the Capytaine outputs

Run the Python script to generate the BEM data:

```zsh
% cd WEC-SIM_Applications/Ellipsoid/hydroData
% python run_capytaine.py
```

The script creates the following output files:

- `ellipsoid.nc`
- `Hydrostatics.dat`
- `KH.dat`


Notes:

1. **Mesh orgin**: WEC-Sim requires the mesh has its origin at the CoM, however
to generate the BEM data using Capytain requires the mesh origin is located
at the mean water surface [WE-Sim, Workflow, Step 2: Generate Hydrodata File](http://wec-sim.github.io/WEC-Sim/master/user/workflow.html#step-2-generate-hydrodata-file).

    Both STL files have the body origin at the CoM

    - `geometry/ellipsoid.stl`
    - `geometry/ellipsoid_f5244.stl`

    Before calling the Capytaine BEM solver the mesh is translated so the
    waterplane is at the origin.

2. **Convergence**: the BEM solver issues a warning if the panel elements
are too large compared to the wavelength being analysed: `8 * max_mesh_radius < wavelength`. This places an upper limit on the frequencies for a given mesh resolution. The geometry may be remeshed in Blender using a combination of the
mesh refinement and mesh triangulation tools.


### 2. Generate hydrodynamics HDF5 data from Capytaine outputs

In MATLAB

```matlab
>> cd ~/WEC-Sim_Applications/Ellipsoid/hydroData
>> bemio
```

This generates the data file `ellipsoid.hd5` and displays plots.


### 3. Run the simulation

In MATLAB

```matlab
>> cd WEC-SIM_Applications/Ellipsoid
>> wecSim
```








