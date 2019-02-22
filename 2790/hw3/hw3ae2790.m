% question 4
x = linspace(-10,10)
x = [-10:.1:10];
norm1 = normpdf (x,0,1);
norm2 = normpdf (x,0,2);
norm3 = normpdf (x,5,1);
norm4 = normpdf (x,0,.5);

plot(x,norm1);
hold on
plot(x,norm2);
plot(x,norm3);
plot(x,norm4);
hold off

xlabel('x value'), ylabel('p_n(x)'), title('normal distribution')
legend('norm 1','norm 2','norm 3','norm 4', 'Location', 'NorthEast') 

