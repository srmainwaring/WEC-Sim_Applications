%% Simulation Data
% Based on Nonlinear_Hydro/ode4/Regular/wecSimInputFile.m
simu = simulationClass();                 % Initialize simulationClass
simu.simMechanicsFile = 'Ellipsoid.slx';  % Simulink Model File
simu.mode = 'normal';                     % Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                       % Simulation Start Time [s]
simu.rampTime = 10;                   	  % Wave Ramp Time [s]
simu.endTime = 40;                        % Simulation End Time [s]
simu.solver = 'ode4';                     % simu.solver = 'ode4' for fixed step 
simu.dt = 0.1;                            % Simulation time-step [s]
simu.rho=1025;                            % Water density                                                                               

simu.adjMassFactor=2;                     % Added mass adjustment factor 0..2. Default=2


%% Wave Information 
% Regular Waves  
waves = waveClass('regular');             % Initialize Wave Class and Specify Type                                 
waves.height = 4;                         % Wave Height [m]
waves.period = 6;                         % Wave Period [s]

% No Waves  
% waves = waveClass('noWave');              % Initialize Wave Class and Specify Type                                 
% waves.period = 6;                         % Wave Period [s]


%% Wave Visualization Markers
% Example with a square mesh of visualization markers

marker = 30;
distance = 10;
[X,Y] = meshgrid(-marker:distance:marker,-marker:distance:marker);
waves.marker.location = [reshape(X,[],1),reshape(Y,[],1)]; % Marker Locations [X,Y]
clear('marker','distance','X','Y')
waves.marker.style = 1; % 1: Sphere, 2: Cube, 3: Frame.
waves.marker.size = 10; % Marker Size in Pixels

%% Body Data
% Float
body(1) = bodyClass('./hydroData/ellipsoid_f5244.h5');
body(1).geometryFile = './geometry/ellipsoid.stl';
body(1).mass =134200;                           % [kg]
body(1).inertia = [838750, 838750, 1342000];    % [kg m^2]
body(1).yaw.option=0;                           % Passive enabled (0 off, 1 on)
body(1).yaw.threshold=1;                        % Passive yaw threshold (degress)

% body(1).initial.displacement = [0 0 0];
% body(1).setInitDisp([0, 0, -2], [[1, 0, 0, 0]; [0, 1, 0, 0]; [0, 0, 1, 0.7]], [0, 0, 0]) % initial displacement, angles in rad

%% Constraint Parameters
% Floating (6DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];               % Constraint Location [m]


