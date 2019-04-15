c1 = [0, 182, 0]./255;
c2 = 160*ones(1,3)./255;

figure
subplot(2,1,1)
plot(T,xk(1,:),'k','LineWidth',1.5)
hold on
scatter(T,zk,50,c2,'filled')
plot(Tk,mk(1,:),'Color',c1,'LineWidth',1.2)
legend('True Position','Measurement','Estimated Position')
xlabel('Time [s]')
ylabel('Position [m]')
title('Position - Truth and Estimate')
hold off
subplot(2,1,2)
plot(T,xk(2,:),'k','LineWidth',1.5)
hold on
plot(Tk,mk(2,:),'Color',c1,'LineWidth',1.2)
legend('True Velocity','Estimated Velocity')
xlabel('Time [s]')
ylabel('Velocity [m/s]')
title('Velocty - Truth and Estimate')
hold off

figure
for k = 1:3
    subplot(3,1,k)
    plot(Tk,rk(k,:),'k','LineWidth',1.5)
    hold on
    plot(Tk, 3*sqrt(Pk(k,:)),'Color',c2)
    plot(Tk,-3*sqrt(Pk(k,:)),'Color',c2)
    if k == 1
        ylabel('Position [m]')
        title('State Eistimate Errors and Error Intervals')
    elseif k == 2
        ylabel('Velocity [m/s]')
    else
        ylabel('Acceleration [m/s^2]')
    end
end
xlabel('Time [s]')

