function [meshProp, matProp, timeProp, verification] = singleParticleProblem

%% MATERIAL INPUT

% E = elastic modulus; poisson = poisson's ratio; density = mass density; L = horiz. length;
% alpha = damping factor;
E = 1000; density = 1; L = [0 1]; alpha = 0;

%% MESH AND PARTICLE INPUT

% elemsize = element size; npart_percell = number of particles per element; tolerance = mesh margin tolerance.
elemsize = L(end); npart_percell = 1; tolerance = 1; limits = [L(1)-tolerance L(2)+tolerance];

%% PROBLEM INPUT

% c = wave speed; omega = parameters for velocity calculation.
c = sqrt(E/density); omega = c/L(end);

% v0 = initial velocity amplitude; g = gravity accel.
v0 = .1; g = 0;
v = @(x) v0;

% support position:
suppos = L(1);

%% TIME INPUT

% dtc = percentage of critical time step; T = period of vibration; tsim = time of simulation.
dtc = .1/100; T = (2*pi)/omega; tsim = 1; 

% dt = critical time step * dtc. ttotal = vector with all times of simulation
dt = dtc*elemsize/c; ttotal = 0:dt:tsim;

%% ANALYTICAL:

x0 = (L(2)+L(1))/2;
analyticalposition = x0*exp(v0/L(end)/omega*sin(omega*ttotal));
analyticalvelocity = v0*cos(omega*ttotal);

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

end