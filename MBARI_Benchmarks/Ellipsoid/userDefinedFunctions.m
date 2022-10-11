%Example of user input MATLAB file for post processing

%Plot waves
waves.plotElevation(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

%Plot responses for body 1
% surge
output.plotResponse(1,1);
    
% sway (negligible)
% output.plotResponse(1,2);

% heave
output.plotResponse(1,3);

% roll (negligible)
% output.plotResponse(1,4);

% pitch
output.plotResponse(1,5);

% yaw (negligible)
% output.plotResponse(1,6);

%Plot heave forces for body 1
output.plotForces(1,3);

%Save waves and response as video
% output.saveViz(simu,body,waves,...
%     'timesPerFrame',5,'axisLimits',[-150 150 -150 150 -50 20],...
%     'startEndTime',[100 125]);
