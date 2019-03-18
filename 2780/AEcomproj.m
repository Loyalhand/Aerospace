clc
clear all
close all

% vehimaxcle 
wt = 14;
wingspan = 110/12; %ft
wingcord = 13.8/12; %ft
liftslopeAF = .115;
liftslopeFW = .084;
CL = 1.4; 
Mr = .05;
cdo = .012;
ZLiftAoA = -4.0;
ag = 2.0;
wingHeight = 1; %ft
ar = wingspan/wingcord;
s = wingspan*wingcord


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
q=  1/2*rho
maxcl = @(a) liftslopeFW*(a-ZLiftAoA);
stall = sqrt(2*wt/(rho*s*CL))
Lift = @(V,a) 1/2*rho*V^2*wingspan*wingcord*maxcl(a);

e = (57.3*liftslopeAF)/(((liftslopeAF/liftslopeFW)-1)*pi*ar);

cd = @(a) cdo + phi*maxcl(a)^2/pi/e/(wingspan^2/wingcord);

Drag = @(V,a) D_ft(V)/2*rho*V^2*cd(a);


t0= 0;
x0= 0; 
v0= 0;
n1= 1; 
xspace(n1) = v0;
tspace(n1) = t0;
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
    tspace(n1+1) = tspace(n1)+dt;
    n1= n1+1;
end

%figures
%thrust
f1 = figure();
hold on
Tr = @(V)q*s*cdo*V^2+ wt^2/(q*s*pi*e*ar*V^2) + D_ft(V);
fplot(Tr, [stall 110],'--');
ylim ([0 15]);
fplot (T, [stall 110]);
title('Thrust vs velocity');
legend ('thrust required','thrust availble','Location', 'NorthEast');
xlabel('velocity (ft/s)','FontName','Times New Roman','FontSize',12);
ylabel('thrust (lb)','FontName','Times New Roman','FontSize',12)
hold off
saveas(f1,'Thrust vs velocity','pdf');

% power
f2 = figure();
hold on
Pr = @(V)Tr(V)*V;
fplot(Pr, [stall 150],'--');
ylim ([0 700]);
Pa = @(V) T(V)*V;
fplot (Pa, [stall 150]);
title('Power vs velocity');
legend ('power required','power availble','Location', 'NorthEast');
xlabel('velocity (ft/s)','FontName','Times New Roman','FontSize',12);
ylabel('power (ft*lb/s)','FontName','Times New Roman','FontSize',12)
hold off
saveas(f2,'power vs velocity','pdf');

% hodograph
f3 = figure();
hold on
ylim ([0 35]);
xlim ([0 100]);
rc = @(V) (Pa(V)-Pr(V))/wt;
hv = @(V) sqrt(V^2-rc(V)^2);
fplot (hv,rc, [stall 130]);
m =  0.8214;
g = @(V) m*(V);
fplot(g, [0 60]);
for i=2:130                     % forloop to find theta max
    Theta(i) = asin(rc(i)/i);
    disp(Theta(i))
    if Theta(i)>Theta(i-1)
       Theta_max = Theta(i);
    end
end
disp(Theta_max)  % in rad
title('Hodograph');
xlabel('h velocity (ft/s)','FontName','Times New Roman','FontSize',12);
ylabel('r/c (ft/s)','FontName','Times New Roman','FontSize',12)
hold off
saveas(f3,'hodograph','pdf');

% runge-kutta
f4 = figure();
hold on
ylim ([0 3]);
xlim ([0 60]);
plot (vspace, tspace,'--');
plot (xspace,tspace)
title('velovity vs time');
xlabel('time (s)','FontName','Times New Roman','FontSize',12);
ylabel('velocity/position (ft/s and ft)','FontName','Times New Roman','FontSize',12);
legend ('velocity','position','Location', 'NorthEast');
hold off
saveas(f4,'velocity vs time','pdf');  

%drag v position
f5 = figure();
hold on
ylim ([0 20]);
xlim ([0 60]);
fplot (D_ft, [0 xspace(n1)],'--');
fplot (T, [0 xspace(n1)]);
title('Drag vs position');
legend ('drag ','thrust ','Location', 'NorthEast');
xlabel('position (ft)','FontName','Times New Roman','FontSize',12);
ylabel('drag/thrust (lb)','FontName','Times New Roman','FontSize',12)
hold off
saveas(f5,'Drag vs position','pdf');

% notable values
% take off velocity: 47.9 ft/s
% take off distance: 54.9 ft/s
% theta max = 0.6886 rad