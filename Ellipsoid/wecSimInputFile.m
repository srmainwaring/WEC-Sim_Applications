%% Simulation Data
% Based on Nonlinear_Hydro/ode4/Regular/wecSimInputFile.m
simu = simulationClass();                 % Initialize simulationClass
simu.simMechanicsFile = 'Ellipsoid.slx';  % Simulink Model File
simu.mode = 'normal';                     % Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                       % Simulation Start Time [s]
simu.rampTime = 50;                   	  % Wave Ramp Time [s]
simu.endTime = 150;                       % Simulation End Time [s]
simu.solver = 'ode4';                     % simu.solver = 'ode4' for fixed step 
simu.dt = 0.1;                            % Simulation time-step [s]
simu.rho=1025;                                                                                                           

%% Wave Information 
% Regular Waves  
waves = waveClass('regular');             % Initialize Wave Class and Specify Type                                 
waves.height = 4;                         % Wave Height [m]
waves.period = 6;                         % Wave Period [s]

%% Body Data
% Float
body(1) = bodyClass('hydroData/ellipsoid_f5244.h5');
body(1).geometryFile = 'geometry/ellipsoid.stl';
body(1).mass =134200;                           % [kg]
body(1).inertia = [838750, 838750, 1342000];    % [kg m^2]
body(1).quadDrag.cd=[1 0 1 0 1 0];
body(1).quadDrag.area=[25 0 pi*5^2 0 pi*5^5 0];


%% Constraint Parameters
% Floating (6DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];               % Constraint Location [m]


