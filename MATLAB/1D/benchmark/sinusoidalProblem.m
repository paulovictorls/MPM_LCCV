function [meshProp, matProp, timeProp, verification] = sinusoidalProblem

%% MATERIAL INPUT

% E = elastic modulus; poisson = poisson's ratio; density = mass density; L = horiz. length;
% alpha = damping factor;
E = 200e9; density = 7800; L = [0 25]; alpha = .01;

%% MESH AND PARTICLE INPUT

% elemsize = element size; npart_percell = number of particles per element; tolerance = mesh margin tolerance.
elemsize = 1; npart_percell = 1; tolerance = 5; limits = [L(1)-tolerance L(2)+tolerance];

%% PROBLEM INPUT

% n = mode of vibration;  c = wave speed; beta and omega = parameters for velocity calculation.
n = 1; beta = ((2*n-1)/2)*(pi/L(end)); c = sqrt(E/density); omega = beta*c;

% v0 = initial velocity amplitude; g = gravity accel.
v0 = .1; g = 0;
v = @(x) v0*sin(beta*x); 

% support position:
suppos = L(1);

%% TIME INPUT

% dtc = percentage of critical time step; T = period of vibration; tsim = time of simulation.
dtc = .1; T = (2*pi)/omega; tsim = 5*T; 

% dt = critical time step * dtc. ttotal = vector with all times of simulation
dt = dtc*elemsize/c; ttotal = 0:dt:tsim;

%% ANALYTICAL:
analyticalposition = L(end)/2 + v0/omega/beta/L(end)*sin(omega*ttotal);
analyticaldisplacement = v0/omega/beta/L(end)*sin(omega*ttotal);
analyticalvelocity = v0/beta/L(end)*cos(omega*ttotal);

%% ASSIGNMENT:

meshProp.limits = limits;
meshProp.elemsize = elemsize;
meshProp.suppos = suppos;
meshProp.alpha = alpha;

matProp.E = E;
matProp.density = density;
matProp.alpha = alpha;
matProp.v = v;
matProp.g = g;
matProp.L = L;
matProp.npart_percell = npart_percell;
matProp.id = 1;

timeProp.dt = dt;
timeProp.ttotal = ttotal;

verification.analyticalposition = analyticalposition;
verification.analyticaldisplacement = analyticaldisplacement; 
verification.analyticalvelocity = analyticalvelocity; 

end