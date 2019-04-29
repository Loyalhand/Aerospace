%% Setup

%% Time
% Time step
dt =0.5;
% Time Vector
T = 0:dt:15; 
n_time = length(T);


%% Models
% Dynamics coefficient matrix (Problem 4)
% d=vi*t+1/2at^2
F = [1 dt 1/2*dt^2;0 1 dt;0 0 1];
% Measurement mapping matrix
Hk = [1 0 0];

%% Process noise PSD
Q = diag([1,0.1,0.01]); 

%% Mapping (If you're curious, these are identity 99.99% of the time)
% Process nosie
M  = eye(3); 
% Measurement noise 
Lk = eye(1); 


% Measurement noise variance
Rk = 20; %  [m^2]