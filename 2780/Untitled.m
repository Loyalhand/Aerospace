clc
clear all
close all

% vehicle 
wt = 14;
wingspan = 110/12; %ft
wcord = 13.8/12; %ft
liftslopeAF = .115;
liftslopeFW = .084;
cdo = 1.4; 
Mr = .05;
WPDrag = .012;
ZLiftAoA = -4.0;
ag = 2.0;
wingHeight = 1; %ft

%global consts
rho = .0023;
ObsHeight = 35; %ft
gravity = 32.2;

%prop
%speed in ft/s
c_0 = 10.79;
c_1 = .00489;
c_2 = -.00065;
T = @(V) c_0 + c_1*V + c_2*V^2;

%fuselage
d_0 = -.0002;
d_1 = .00036;
D_ft = @(V) d_0*V + d_1*V^2; %lbf


 % functions
phi = (16*wingHeight/wingspan)^2/(1+(16*wingHeight/wingspan)^2);

cl = @(a) liftslopeFW*(a-ZLiftAoA);

Lift = @(V,a) 1/2*rho*V^2*wingspan*wcord*cl(a);

e = 57.3*liftslopeAF/(liftslopeAF/liftslopeFW)/(pi*wingspan^2/wcord);

cd = @(a) cdo + phi*cl(a)^2/pi/e/(wingspan^2/wcord);

Drag = @(V,a) D_ft(V)/2*rho*V^2*cd(a);


t0= 0;
x0= 0; 
v0= 0;
n1= 1; 
xspace(n1) = v0;
vspace(n1) = x0;
dt = .005;
maxiter = 10/dt;
while Lift(vspace(n1),ag)<wt && n1<maxiter
    k1 = gravity/wt*(T(vspace(n1)-Drag(vspace(n1),ag)-Mr*(wt-Lift(vspace(n1),ag))));
    k2 = gravity/wt*(T(vspace(n1)+.5*k1*dt)-Drag(vspace(n1)+.5*k1*dt,ag)-Mr*(wt-Lift(vspace(n1)+.5*k1*dt,ag)));
    k3 = gravity/wt*(T(vspace(n1)+.5*k2*dt)-Drag(vspace(n1)+.5*k2*dt,ag)-Mr*(wt-Lift(vspace(n1)+.5*k2*dt,ag)));
    k4 = gravity/wt*(T(vspace(n1)+k3*dt)-Drag(vspace(n1)+k3*dt,ag)-Mr*(wt-Lift(vspace(n1)+k3*dt,ag)));
    vspace(n1+1)=vspace(n1)+1/6*(k1+2*k2+2*k3+k4)*dt;
    xspace(n1+1)=xspace(n1)+vspace(n1)*dt+1/2*k1*dt*dt;
    n1= n1+1;
end
