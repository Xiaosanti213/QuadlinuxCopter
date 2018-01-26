clear
close all
clc

%% ����1 ����2 ����4ͨ������ź�ת��Ϊ�Ƕ�
rc_commands = ones(4,1)*1000;                               % ��ʼ״̬1 2 4ͨ�������� ���ı����0-2000
rc_commands(3) = 0;                                         % 3ͨ�����Ź�0

deg_lim = 20;                                               % �������Ʒ�ΧΪ[-20, 20] ��λ���Ƕ�
deg_per_signal = 2*deg_lim/2000;                            % ÿ��λ������Ӧ�ĽǶ� 
pitch_ref = (rc_commands(2)-1000) * deg_per_signal;         % �ο��źŽǶ�
roll_ref = (rc_commands(1)-1000) * deg_per_signal;
yaw_ref = (rc_commands(4)-1000) * deg_per_signal;          


%% ���������˼��
% �����ź�->���->����ѧ->�˶�ѧ->���ض�����ŷ����
% �ж���ѧ���˶�ѧ����
% ����ض��󣬿������������Ƕȷֱ����
% �߼���������ǽǶ�set reference ������ǵ��������

%% stage 1 ����error






%% stage 2 ���㷴��
for k = 2:1:number_of_sample
    u_previous = u;
    
    udot = -K*[x_p_hat_dot; y-r(k)];
    u = u_previous + udot*deltaT;%�������ǰӦ���еĿ�����
    
    %���Ӧ�ü��Ͽ����ֱ����ж�
    if (u > u_max)
       udot = 0;
       u = u_max;
    elseif (u < u_min)
       udot = 0;
       u = u_min;
    end
        
    %x_p_hat_dot = x_p_hat_dot + deltaT*(Ap*x_p_hat_dot + Bp*udot - Kob*Cp*x_p_hat_dot)+Kob*(y());
    x_p_hat_dot = x_p_hat_dot + deltaT.*(Ap*x_p_hat_dot + Bp*udot - Kob*Cp*x_p_hat_dot)+Kob*(y - y_previous);
    x_p = x_p + deltaT*(Ap*x_p + Bp*u)+0.001 * disturbance(k-1);%�����Ŷ�����
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
legend('��ת��');
xlabel('Time (s)');
ylabel('Roll (deg)');
xlim([0 t_finish]);


subplot(3,1,2)
plot(t, pitch_act,'--g');
hold on
plot(t, pitch_ref,'--r');
legend('������');
xlabel('Time (s)');
ylabel('Pitch (deg)');
xlim([0 t_finish]);


subplot(3,1,3)
plot(t, yaw_act,'--g');
hold on
plot(t, yaw_ref,'--r');
legend('ƫ����');
xlabel('Time (s)');
ylabel('Yaw (deg)');
xlim([0 t_finish]);
 



figure
plot(t, motor_output(1), 'r')
hold on
plot(t, motor_output(2), 'g')
plot(t, motor_output(3), 'b')
plot(t, motor_output(4), 'y')%��ɫ




















