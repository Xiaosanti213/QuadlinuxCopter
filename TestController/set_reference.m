clear
close all
clc

%% 副翼1 俯仰2 方向4通道输出信号转化为角度
rc_commands = ones(4,1)*1000;                               % 初始状态1 2 4通道归中立 空心杯电机0-2000
rc_commands(3) = 0;                                         % 3通道油门归0

deg_lim = 20;                                               % 暂且限制范围为[-20, 20] 单位：角度
deg_per_signal = 2*deg_lim/2000;                            % 每单位舵量对应的角度 
pitch_ref = (rc_commands(2)-1000) * deg_per_signal;         % 参考信号角度
roll_ref = (rc_commands(1)-1000) * deg_per_signal;
yaw_ref = (rc_commands(4)-1000) * deg_per_signal;          


%% 控制器设计思想
% 控制信号->电机->动力学->运动学->被控对象是欧拉角
% 列动力学，运动学方程
% 解耦被控对象，控制量，三个角度分别设计
% 逻辑是输入的是角度set reference 输出的是电机油门量

%% stage 1 计算error






%% stage 2 计算反馈
for k = 2:1:number_of_sample
    u_previous = u;
    
    udot = -K*[x_p_hat_dot; y-r(k)];
    u = u_previous + udot*deltaT;%计算出当前应该有的控制量
    
    %这块应该加上抗积分饱和判断
    if (u > u_max)
       udot = 0;
       u = u_max;
    elseif (u < u_min)
       udot = 0;
       u = u_min;
    end
        
    %x_p_hat_dot = x_p_hat_dot + deltaT*(Ap*x_p_hat_dot + Bp*udot - Kob*Cp*x_p_hat_dot)+Kob*(y());
    x_p_hat_dot = x_p_hat_dot + deltaT.*(Ap*x_p_hat_dot + Bp*udot - Kob*Cp*x_p_hat_dot)+Kob*(y - y_previous);
    x_p = x_p + deltaT*(Ap*x_p + Bp*u)+0.001 * disturbance(k-1);%加入扰动向量
    %x_p = x_p + deltaT*(Ap*x_p + Bp*u);

    y_previous = y;
    y = Cp * x_p;

    y_plot(k) = y;
    u_plot(k) = u;
end


%% figure
figure
subplot(3,1,1)
plot(t, roll_act,'--g');
hold on
plot(t, roll_ref,'--r');
legend('滚转角');
xlabel('Time (s)');
ylabel('Roll (deg)');
xlim([0 t_finish]);


subplot(3,1,2)
plot(t, pitch_act,'--g');
hold on
plot(t, pitch_ref,'--r');
legend('俯仰角');
xlabel('Time (s)');
ylabel('Pitch (deg)');
xlim([0 t_finish]);


subplot(3,1,3)
plot(t, yaw_act,'--g');
hold on
plot(t, yaw_ref,'--r');
legend('偏航角');
xlabel('Time (s)');
ylabel('Yaw (deg)');
xlim([0 t_finish]);
 



figure
plot(t, motor_output(1), 'r')
hold on
plot(t, motor_output(2), 'g')
plot(t, motor_output(3), 'b')
plot(t, motor_output(4), 'y')%黄色




















