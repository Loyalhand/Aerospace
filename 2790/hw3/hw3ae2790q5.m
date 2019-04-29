%question 5
clear all
close all
clc
x_1 =  [.1 ,-.2 ,-.3 ,-.4 ,-.5, -.6, -.7, -.8, -.9, -1.0];
y_1 = [1.96;0.37; 3.16; 7.23; 5.53; 11.71; 3.37; 5.64; 6.50; 9.21];
V = 10:6;

figure;
scatter(x_1,y_1)
hold on 
for k = 1: 5
    for n=1:length(x_1)
        V(n,1) = 1;
        V(n,k+1) = (x_1(n))^k;
    end
    a= (inv(V'*V))*(V')*y_1;
    if k<5 
        a(k+2:6)=0;
    end
    fplot(@(x) a(1)+a(2)*x+a(3)*x.^2+a(4)*x.^3+a(5)*x.^4+a(6)*x.^5);
end

hold off 
xlim ([-1 .1]);
ylim ([-1, 12]);
title('polynomial fit');
xlabel('x');
legend ('x-y values','1st','2nd','3rd','4th','5th','Location', 'NorthEast');