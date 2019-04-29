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
        title('State Estimate Errors and Error Intervals')
    elseif k == 2
        ylabel('Velocity [m/s]')
    else
        ylabel('Acceleration [m/s^2]')
    end
end
xlabel('Time [s]')

figure
for k = 1:3
    subplot(3,1,k)
    plot(Tk,mk(k,:),'k','LineWidth',1.5)
    hold on
    plot(Tk,mk(k,:)+3*sqrt(Pk(k,:)),'Color',c2)
    plot(Tk,mk(k,:)-3*sqrt(Pk(k,:)),'Color',c2)
    if k == 1
        ylabel('Position [m]')
        title('mean position/velocity/acceleration vs time')
    elseif k == 2
        ylabel('Velocity [m/s]')
    else
        ylabel('Acceleration [m/s^2]')
    end
end
xlabel('Time [s]')

for j= 2:61
    c(j)=mk(2,j)-3*sqrt(Pk(2,j));
    if c(j)<c(j-1)
        vmax = c(j)
    end
end
% for k=1:61
%     varx=sum((mk(1,k)-rk(1,k))^2/61);
% end
% 
% for k=1:61
%     varv=sum((mk(2,k)-rk(2,k))^2/61);
% end
% 
% for k=1:61
%     vara=sum((mk(3,k)-rk(3,k))^2/61);
% end
% 
% stdx = sqrt(varx);
% stdv = sqrt(varv);
% stda = sqrt(vara);
% 
% std = [stdx;stdv;stda];
% 
% for k = 1:3
% norm1 = normpdf(Tk,mk(k,:),std(k));
% figure
% plot(Tk,norm1)
% end
