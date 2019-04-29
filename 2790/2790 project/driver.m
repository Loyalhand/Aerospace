clear all
close all
clc

% Setup the problem 
kf_setup

%% Initialize
% Initial Mean
mkm1  = [0;    % Position     [m]
         0;    % Velocity     [m/s]
         7.0]; % Acceleration [m/s^2]
n_var = length(mkm1);
% Covariance
Pkm1  = diag([14^2,... % [m^2]
               5^2,... % [m^2/s^2]
               1^2]);  % [m^2/s^4]
% True initial state
xkm1 = [ 1.544;  % Position     [m]
        -3.400;  % Velocity     [m/s]
         6.158]; % Acceleration [m/s^2]

% Generate truth 
load('truth.mat','xk')        % [state x time] -> [3x31]  [m; m/s; m/s^2]

% Load measurements
load('measurements.mat','zk') % [measurement x time] -> [1x31]  [m]


%% Polynomial fit
x = T';
y = zk';

figure
ax = axes;
scatter(x,y)
hold on

for k = 1:5
    for n=1:length(x)
        V(n,1) = 1;
        V(n,k+1) = (x(n))^k;
    end
    a = (inv(V'*V))*(V')*y;
    if k<5 
        a(k+2:6)=0;
    end
    
    p = 0;
    for j = 0:5
        p = p + a(j+1)*x.^(j);
    end
    plot(x,p)
    
end

title('Position vs Time');
xlabel('Time (s)');
ylabel('Position (m)');
legend ('points','1st','2nd','3rd','4th','5th','Location', 'NorthEast');
hold off

i = T';
b = zk';
figure
scatter(i,b)
hold on

for k = 1:5
    for n=1:length(i)
        VN(n,1) = 1;
        VN(n,k+1) = (i(n))^k;
    end
    a = (inv(VN'*VN))*(VN')*b;
    if k<5 
        a(k+2:6)=0;
    end
    
    p = 0;
    for j = 0:5
        p = p + a(j+1)*i.^(j);
    end
    plot(i,p)
end

xlim([14,15]);
title('Position vs Time');
xlabel('Time (s)');
ylabel('Position (m)');
legend ('points','1st','2nd','3rd','4th','5th','Location', 'NorthEast');
hold off


%% Kalman filter
% Stoarage
% Mean
mk = nan(n_var,2*n_time-1); % [3x62] 
% State estimation error
% Truth - Estimate 
rk = nan(n_var,2*n_time-1); % [3x62]
% Diagonal of the covariance matrix 
% The diagonals are the variance of each individual state, this does not
% include correlation terms
Pk = nan(n_var,2*n_time-1); % [3x62]
% Time vector
Tk = nan(1,2*n_time-1);     % [1x62]

% First step
% Mean
mk(:,1) = mkm1;
% State estimate error
rk(:,1) = mkm1 - xkm1; 
% Vector of variances 
Pk(:,1) = diag(Pkm1);
% Time
Tk(:,1) = T(1);

% KF 
for k = 1:n_time-1
    
    
   % Propagate
   [mkm,Pkm] = kf_prop(mkm1,Pkm1,F,Q,M);
   % Update 
   [mkp,Pkp] = kf_update(mkm,Pkm,zk(k),Hk,Rk,Lk);
   % Store
   [Tk,mk,rk,Pk] = kf_storage(Tk,mk,rk,Pk,T,mkm,mkp,Pkm,Pkp,xk(:,k),k);
     
    %% Recursion
    % Mean
    mkm1 = mkp;
    % Covariance
    Pkm1 = Pkp;
    
end

kf_plotting




