function [meshProp, matProp, timeProp, verification] = pillarProblem

%% MATERIAL INPUT

% E = elastic modulus; poisson = poisson's ratio; density = mass density; L = horiz. length;
% alpha = damping factor;
E = 200e9; density = 7800; L = [0 25]; alpha = .0;

%% MESH AND PARTICLE INPUT

% elemsize = element size; npart_percell = number of particles per element; tolerance = mesh margin tolerance.
elemsize = 1; npart_percell = 1; tolerance = 5; limits = [L(1)-tolerance L(2)+tolerance];

%% PROBLEM INPUT

% n = mode of vibration;  c = wave speed; beta and omega = parameters for velocity calculation.
n = 1; beta = ((2*n-1)/2)*(pi/L(end)); c = sqrt(E/density); omega = beta*c;

% v0 = initial velocity amplitude; g = gravity accel.
v0 = 0; g = -9.81;
v = @(x) v0; 

% support position:
suppos = L(end);

%% TIME INPUT

% dtc = percentage of critical time step; T = period of vibration; tsim = time of simulation.
dtc = .1; T = (2*pi)/omega; tsim = 2*T; 

% dt = critical time step * dtc. ttotal = vector with all times of simulation
dt = dtc*elemsize/c; ttotal = 0:dt:tsim;

%% ANALYTICAL:

analyticalvelocity = zeros(1,length(ttotal));
analyticaldisplacement = zeros(1,length(ttotal));

for j = 1:5
    A = 1/(2*j-1)^4;
    B = .5*(2*j-1)*pi/L(end)* c;
    C = 1 - cos(.5*(2*j-1)*pi);
    analyticalvelocity = analyticalvelocity + A * B * sin(B*ttotal) * C;
    analyticaldisplacement = analyticaldisplacement + A * cos(B*ttotal) * C;
end

analyticalvelocity = 32 * density * g * L(end)^2 / pi^4 / E * analyticalvelocity;
analyticaldisplacement = 32/pi^4 * analyticaldisplacement;
analyticaldisplacement = 1/3 - analyticaldisplacement;
analyticaldisplacement = density * g * L(end)^2 / E * analyticaldisplacement;
analyticalposition = L(end)/2 + analyticaldisplacement;

%% ASSIGNMENT:

meshProp.limits = limits;
meshProp.elemsize = elemsize;
meshProp.suppos = suppos;
meshProp.alpha = alpha;

matProp.E = E;
matProp.density = density;
matProp.v = v;
matProp.g = g;
matProp.L = L;
matProp.npart_percell = npart_percell;
matProp.id = 1;

timeProp.dt = dt;
timeProp.ttotal = ttotal;

verification.analyticalposition = analyticalposition; 
verification.analyticalvelocity = analyticalvelocity; 
verification.analyticaldisplacement = analyticaldisplacement; 

end