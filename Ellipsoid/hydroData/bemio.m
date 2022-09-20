% clc; clear all; close all;

%% hydro data
hydro = struct();
hydro = readCAPYTAINE(hydro,'ellipsoid_f5244.nc');
hydro = radiationIRF(hydro,15,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeBEMIOH5(hydro)

%% Plot hydro data
plotBEMIO(hydro)

