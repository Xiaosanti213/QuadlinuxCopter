
%% 前面需要首先运行SuperSanity_attitude_estimate_test.m
close all
%% 平滑滤波
as = zeros(1,length(acc));
for i =1:3
    as(i,:) = smooth_filter(acc(i,:));
end


gs = zeros(1,length(gyro));
for i = 1:3
    gs(i,:) = smooth_filter(gyro(i,:));
end


%% 画图比较
t = 0:0.02:0.02*(length(acc)-1);
figure(1)
subplot(311)
plot(t,acc(1,:),'r')
hold on 
plot(t,as(1,:),'b')
xlabel('Time:(s)')
ylabel('Acc:(g)')
legend('origin', 'filtered')

subplot(312)
plot(t,acc(2,:),'r')
hold on 
plot(t,as(2,:),'b')
xlabel('Time:(s)')
ylabel('Acc:(g)')
legend('origin', 'filtered')

subplot(313)
plot(t,acc(3,:),'r')
hold on 
plot(t,as(3,:),'b')
xlabel('Time:(s)')
ylabel('Acc:(g)')
legend('origin', 'filtered')

%% 陀螺仪

figure(2)
subplot(311)
plot(t,gyro(1,:),'r')
hold on 
plot(t,gs(1,:),'b')
xlabel('Time:(s)')
ylabel('Gyro:(dps)')
legend('origin', 'filtered')

subplot(312)
plot(t,gyro(2,:),'r')
hold on 
plot(t,gs(2,:),'b')
xlabel('Time:(s)')
ylabel('Gyro:(dps)')
legend('origin', 'filtered')

subplot(313)
plot(t,gyro(3,:),'r')
hold on 
plot(t,gs(3,:),'b')
xlabel('Time:(s)')
ylabel('Gyro:(dps)')
legend('origin', 'filtered')




