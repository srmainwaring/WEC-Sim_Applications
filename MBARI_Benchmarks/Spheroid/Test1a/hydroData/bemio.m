% clc; clear all; close all;

%% hydro data
hydro = struct();
hydro = readCAPYTAINE(hydro,'spheroid_f3676.nc');
hydro = radiationIRF(hydro,15,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeBEMIOH5(hydro)

%% Plot hydro data
plotBEMIO(hydro)
% plotBEMIO([1,1; 2,2; 3,3; 4,4; 5,5; 6,6;], hydro)
% plotBEMIO([1,2; 1,3; 1,4; 1,5; 1,6], hydro)
% plotBEMIO([2,3; 2,4; 2,5; 2,6], hydro)
% plotBEMIO([3,4; 3,5; 3,6; 4,5; 4,6; 5,6], hydro)

