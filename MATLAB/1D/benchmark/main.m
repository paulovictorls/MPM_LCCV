%% MAIN FUNCTION

clear
clc
addpath ../src

%% PROGRAM OPTIONS

% Visual settings:
fullscreen = false;
showresults = false;

% Evaluation settings:
recordresults = false;
validation = 1; % (1 - position, 2 - displacement, 3 - velocity, 4 - nothing).
showenergy = false;

% Simulation settings:
gausspoints = true;
USL = false;

%% VIDEO RECORDING

if recordresults
    vidObj = VideoWriter('simulation.avi');
    open(vidObj);
end

%% DATA INPUT

[meshProp, matProp, timeProp, verification] = pillarProblem;

%% MESH GENERATION

% Bounding box mesh generation (q4):
bmesh = meshgen(meshProp);

%% PARTICLE GENERATION

matpoints = particlegen(matProp, bmesh, gausspoints);

%% TIME INTEGRATION

dt = timeProp.dt;
ttotal = timeProp.ttotal;
output.cmx = zeros(1,length(ttotal));
output.cmu = zeros(1,length(ttotal));
output.cmv = zeros(1,length(ttotal));
output.eS = zeros(1,length(ttotal));
output.eK = zeros(1,length(ttotal));

if fullscreen && showresults
    set(gcf, 'Position', get(0, 'Screensize'));
end

for i = 1:length(ttotal)
    
    fprintf('TIME: %f s\n',ttotal(i)); % This prints the time steps one by one.
    
    if validation~=4 || showenergy
        [output.cmx(i), output.cmu(i), output.cmv(i), output.eS(i), output.eK(i)] = validationcalc(matpoints); % Validation calculation.
    end

    if USL
        [matpoints, bmesh] = timeintUSL(matpoints, bmesh, dt); % Call to a time integration function.
    else
        [matpoints, bmesh] = timeintUSF(matpoints, bmesh, dt); % Call to a time integration function.
    end

    if showresults
        visualizematpoints(bmesh, matpoints); % Visualization of the updated material points at each time step.
        pause(eps); % This pauses the simulation for 'eps' seconds, where 'eps' is a constant in Matlab.
    end
    
    if recordresults
        drawnow;
        mymovie(i) = getframe;
    end
    
end

%% DATA OUTPUT

if recordresults
    writeVideo(vidObj,mymovie);
    close(vidObj);
end

%% RESULT VERIFICATION

if validation~=4 || showenergy
    dataOutput(ttotal, output, verification, validation, showenergy);
end