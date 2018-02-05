% %����Sanity��Ӧ���
% clear
% close all
% clc
% %��ȡ���ݣ�
% % 1�������ݷ�Χ
% % 2�����λ�ú����λ�ò��غ�
% % ������λ��
% %% ��ȡ����
% [raw_data]=importdata('control_data.txt','%s'); 
%��ǰ��11+15һ�飬��Ϊ��һ��4��ҡ�˶������ݶ�ʧ
data_to_read = length(raw_data);
data_length = floor((data_to_read-1)/(11+15))*2;%��Сȡ��

ref = zeros(3, data_length);%�����Ǹ��Ͳ�����
out = zeros(3, data_length);
controller = zeros(4, data_length/2);
euler_angle = ref;
motor = controller;
angle_rate = ref;
kr = 1;kc = 1;ko = 1;ke = 1;km = 1;
for i = 1:1:data_to_read %����Ҫ����ʱ��ʹ�i=2��ʼ
    str_temp = cell2mat(raw_data(i));
    if(str_temp(2) == 'e')% Ref �ο��ź�
        ref(1,kr) = str2double(str_temp(23:28));
        ref(2,kr) = str2double(str_temp(31:38));
        ref(3,kr) = str2double(str_temp(39:48));
        kr = kr+1;
    elseif(str_temp(6) == 'l')% RA ң�����������ź�
        controller(1,kc) = str2double(str_temp(9:12));
    elseif(str_temp(6) == 'e')
        controller(2,kc) = str2double(str_temp(9:12));
    elseif(str_temp(6) == 'r')
        controller(3,kc) = str2double(str_temp(9:12));
    elseif(str_temp(6) == 'd')
        controller(4,kc) = str2double(str_temp(9:12));
        kc = kc+1;
    elseif(str_temp(1) == 'O')% Output
        out(1,ko) = str2double(str_temp(23:28));%�ڻ�ʵ�����
        out(2,ko) = str2double(str_temp(40:50));
        out(3,ko) = str2double(str_temp(56:71));
        ko = ko+1;
    elseif(str_temp(1) == 'E')% Euler Angle
        euler_angle(1,ke) = str2double(str_temp(23:29));
        euler_angle(2,ke) = str2double(str_temp(33:42));
        euler_angle(3,ke) = str2double(str_temp(43:55)); 
    elseif(str_temp(1) == 'A')%Angle Rate
        %һ������ǣ��漴������ٶȣ������������һ�¾ͺ�
        angle_rate(1,ke) = str2double(str_temp(23:29));
        angle_rate(2,ke) = str2double(str_temp(33:42));
        angle_rate(3,ke) = str2double(str_temp(43:end));
        ke = ke+1;
    elseif(str_temp(1) == '1')% 
        % 1�������ݷ�Χ [0,2000]
        % 2�����λ�ú����λ�ò��غ� 
        % ������λ��
        % ĩβ�ո����
        motor(1,km) = str2double(str_temp(7:end));
    elseif(str_temp(1) == '2')
        motor(2,km) = str2double(str_temp(7:end));
    elseif(str_temp(1) == '3')
        motor(3,km) = str2double(str_temp(7:end));
    elseif(str_temp(1) == '4')
        motor(4,km) = str2double(str_temp(7:end));
        km = km+1;
    end
end

T = 0.02;
t = 0:T:(data_length-1)*T;
%% ����õ���ԭʼ����������д���
Reference_o(1,:) = ref(1,:);
Reference_o(2,:) = ref(2,:);
Reference_o(3,:) = ref(3,:);

u_i_antiwindup = zeros(3,data_length);    %��ʼ����ǰ���ڻ��⻷��������ʼ��                   
u_o_antiwindup = zeros(3,data_length);
y_i_antiwindup = u_i_antiwindup;
y_o_antiwindup = u_o_antiwindup;
%% ͨ��ң���������������۲ο�ֵ���������ֵ
% time_finish = 2;%�������ʱ��10s
% T = 0.02;        %ʱ����0.02s
% t = 0:T:time_finish-T;
% rc_commands = zeros(4,time_finish/T);
% rc_commands(1,:) = 1000*sin(t)+1000;%���Ӧ��������Ͽո񣬷���û��д
% rc_commands(2,:) = 1000*sin(t+pi/2)+1000;
% rc_commands(3,:) = 1000*sin(t+pi)+1000;
% rc_commands(4,:) = 1000*sin(t+3*pi/2)+1000;
% 
% % ת��Ϊ�ǶȲο�
% deg_lim = 20;                                               % �������Ʒ�ΧΪ[-20, 20] ��λ���Ƕ�
% deg_per_signal = 2*deg_lim/2000;                            % ÿ��λ������Ӧ�ĽǶ� 
% 
% Reference_o(1,:) = (rc_commands(1,:)-1000) * deg_per_signal;
% Reference_o(2,:) = (rc_commands(2,:)-1000) * deg_per_signal;        
% Reference_o(3,:) = (rc_commands(4,:)-1000) * deg_per_signal;       
  

% u_i_antiwindup = zeros(3,time_finish/T);    %��ʼ����ǰ���ڻ��⻷��������ʼ��                   
% u_o_antiwindup = zeros(3,time_finish/T);
% y_i_antiwindup = u_i_antiwindup;
% y_o_antiwindup = u_o_antiwindup;
%% ˫��΢��֮���õ���ǰһ�ο�����������ǰ�����������ۻ����÷���anti-windup
a = 1;b = 0;%1/s
ksi = 0.707; wn = 10;%Ŀ�����ϵͳ
type = 2; %ʹ��IP������������У����
[Kp,tauI,close_transfunc_outer] = fir_odr_sec_odr_get_PIDs(a,b,ksi,wn,type);% Kp=14.14 tauI=0.1414
K = 20;															
% Kp = 20.14;
% tauI = 0.314;
i_term = 0;




for axis = 1:2 %��ת������
    for i = 3:data_length 
        %�⻷
        p_term = double(Kp*(-y_o_antiwindup(axis,i-1)+y_o_antiwindup(axis,i-2)));                %IP���� ��������λ�ڷ�����·��
        i_term = Kp/tauI*(Reference_o(axis,i)-y_o_antiwindup(axis,i-1))*T;                       %���ۻ�����,����������������y�����������ܺ��ϸ���һ��T�ӳ�
        u_o_antiwindup(axis,i) = p_term+i_term+u_o_antiwindup(axis,i-1);

        %�ڻ�
        Reference_i = u_o_antiwindup(axis,i);                                          %�⻷�����ź���Ϊ�ڻ��ο��ź�
        error_i = Reference_i-y_i_antiwindup(axis,i-1);                  
        u_i_antiwindup(axis,i) = K*error_i;                                            %������ܿ��������ڻ���������������

        % �����ֱ���
        output_limit = 10000;
        if(u_i_antiwindup(axis,i) > output_limit)
            u_i_antiwindup(axis,i) = output_limit;
        elseif(u_i_antiwindup(axis,i) < -output_limit)
            u_i_antiwindup(axis,i) = -output_limit;
        end
        %���⻷���
%          y_i_antiwindup(axis,i) = y_i_antiwindup(axis,i-1)+u_i_antiwindup(axis,i)*T;              %�������ۻ���ģ�ͣ�ʵ�ʲ������
%          y_o_antiwindup(axis,i) = y_o_antiwindup(axis,i-1)+y_i_antiwindup(axis,i)*T;
%        y_i_antiwindup(axis,i) = 0;
%        y_o_antiwindup(axis,i) = 0; %��ǰ���ڲ�������ֵ�����Ա���Ϊ�����źţ��������y_oΪ0
         
       y_i_antiwindup(axis,i) = angle_rate(axis,i);
       y_o_antiwindup(axis,i) = euler_angle(axis,i); %����ʵ��ֵ
    end
end

%ƫ����
error_i = Reference_o(3,:);%-angle_rate(4,:);
output(3,:) = K*error_i;



%% ң�����ź�
% figure(1)
% subplot(411)
% plot(t,Reference_o(1,:),'r--');
% xlabel('Time:(s)')
% ylabel('Signal')
% legend('Reference Signal ale')
% 
% subplot(412)
% plot(t,Reference_o(2,:),'r--');
% xlabel('Time:(s)')
% ylabel('Signal')
% legend('Reference Signal ele')
% 
% subplot(413)
% plot(t,Reference_o(3,:),'r');
% xlabel('Time:(s)')
% ylabel('Signal')
% legend('Reference Signal thr')
% 
% subplot(414)
% plot(t,Reference_o(4,:),'r');
% xlabel('Time:(s)')
% ylabel('Signal')
% legend('Reference Signal rud')


%% �ο��Ƕ��ź���������
%�ڻ�
plot_index = 1;%1--roll 2--pitch 3--thrust 4--yaw
figure(1)
subplot(211)
plot(t,y_i_antiwindup(plot_index,:),'c.')%�����ֱ���΢����ʽ��ƣ���ɢϵͳ���
xlabel('Time:(s)')
ylabel('State Output')
title('�ڻ�ϵͳ״̬���ͼ')

subplot(212)
plot(t,u_i_antiwindup(plot_index,:),'c.')
hold on
plot(t,out(plot_index,1:length(t)),'b');%�ڻ�������
xlabel('Time:(s)')
ylabel('Output')
legend('Innerloop Control Output')
title('�ڻ���������ͼ')


%�⻷
figure(3)
subplot(211)
plot(t,Reference_o(plot_index,1:length(t)),'--r');%�ο��ź�
hold on
plot(t,y_o_antiwindup(plot_index,:),'c.')%ϵͳ״̬
xlabel('Time:(s)')
ylabel('Signal')
legend('Reference','State Output');
title('�⻷ϵͳ״̬���ͼ')

subplot(212)
plot(t,u_o_antiwindup(plot_index,:),'c.')
xlabel('Time:(s)')
ylabel('Output')
legend('Outerloop Control Output');
title('�⻷��������ͼ')





figure(4)
subplot(211)
plot(t,motor(1,1:length(t)),'r')
hold on
plot(t,motor(2,1:length(t)),'g')
plot(t,motor(3,1:length(t)),'b')
plot(t,motor(4,1:length(t)),'c')
xlabel('Time:(s)')
ylabel('Signal')
legend('1st','2nd','3rd','4th');
title('����0.5���ĸ���������������[0 2000]')

subplot(212)%ҡ�˶������������Ͳο��ź�Ӧ�����ȹ�ϵ
plot(t,controller(1,1:length(t)),'r')
hold on
plot(t,-controller(2,1:length(t)),'g')%Ϊ�˹۲����ȹ�ϵ
plot(t,controller(3,1:length(t)),'b')
plot(t,controller(4,1:length(t)),'c')
xlabel('Time:(s)')
ylabel('Signal')
legend('����','����','����','����');
title('�ĸ�ҡ�˶��� [0 2000]')






