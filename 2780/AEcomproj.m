clc
clear all
close all

% vehimaxcle 
wt = 15.34268538/16;
wingspan = 59.245/12; %ft
wingcord = 9.115/12; %ft
liftslopeAF = .1;
liftslopeFW = 0.079395;
CL = .98; 
Mr = .05;
cdo = .0155;
ZLiftAoA = -6.3;
ag = 11.5;
wingHeight = 1/3; %ft
ar = wingspan/wingcord;
s = wingspan*wingcord
m =  0.4429;

%global consts
rho = .0023;
ObsHeight = 35; %ft
gravity = 32.2;

%prop
%speed in ft/s
c_0 = .5617;
c_1 = -.0054;
c_2 = -4*10^-5;
T = @(V) c_0 + c_1*V + c_2*V^2;

%fuselage
d_0 = .00016;
d_1 = .0001;
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
Tr = @(V)q*s*cdo*V^2+ wt^2/(q*s*pi*e*ar*V^2) + D_ft(V);
Pr = @(V)Tr(V)*V;
Pa = @(V) T(V)*V;
rc = @(V) (Pa(V)-Pr(V))/wt;
hv = @(V) sqrt(V^2-rc(V)^2);
g = @(V) m*(V);


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
fplot(Tr, [stall 50],'--');
ylim ([0 .6]);
fplot (T, [stall 50]);
title('Thrust vs velocity');
legend ('thrust required','thrust availble','Location', 'NorthEast');
xlabel('velocity (ft/s)','FontName','Times New Roman','FontSize',12);
ylabel('thrust (lb)','FontName','Times New Roman','FontSize',12)
hold off
saveas(f1,'Thrust vs velocity','pdf');

% power
f2 = figure();
hold on
fplot(Pr, [stall 60],'--');
ylim ([0 12]);
fplot (Pa, [stall 60]);
title('Power vs velocity');
legend ('power required','power availble','Location', 'NorthEast');
xlabel('velocity (ft/s)','FontName','Times New Roman','FontSize',12);
ylabel('power (ft*lb/s)','FontName','Times New Roman','FontSize',12)
hold off
saveas(f2,'power vs velocity','pdf');

% hodograph
f3 = figure();
hold on
ylim ([0 10]);
xlim ([0 50]);
fplot (hv,rc, [stall 130]);

fplot(g, [0 60]);
for i=2:130                     % forloop to find theta max
    Theta(i) = asin(rc(i)/i);
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
ylim ([0 16]);
xlim ([0 1]);
plot (tspace, vspace,'--');
plot (tspace,xspace)
title('velovity vs time');
xlabel('time (s)','FontName','Times New Roman','FontSize',12);
ylabel('velocity/position (ft/s and ft)','FontName','Times New Roman','FontSize',12);
legend ('velocity','position','Location', 'NorthEast');
hold off
saveas(f4,'velocity vs time','pdf');  

%drag v position
f5 = figure();
hold on
ylim ([0 .7]);
xlim ([0 5]);
fplot (D_ft, [0 xspace(n1)],'--');
fplot (T, [0 xspace(n1)]);
title('Drag vs position');
legend ('drag ','thrust ','Location', 'NorthEast');
xlabel('position (ft)','FontName','Times New Roman','FontSize',12);
ylabel('drag/thrust (lb)','FontName','Times New Roman','FontSize',12)
hold off
saveas(f5,'Drag vs position','pdf');

%outputs
disp('Deliverables: Part 1')
take_off_distance=xspace(end);
fprintf('The take off distance is %f feet.\n',take_off_distance)
fprintf('\n')
disp('Deliverables: Part 2')
distance_clear=35/tan(Theta_max)+take_off_distance;
fprintf('The clearing distance is %f feet.\n',distance_clear)
fprintf('\n')
disp(Theta_max*180/pi)  % in rad
