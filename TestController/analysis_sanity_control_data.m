% %分析Sanity响应情况
% clear
% close all
% clc
% %读取数据：
% % 1考虑数据范围
% % 2考虑最长位置和最短位置不重合
% % 数最长最短位置
% %% 读取数据
% [raw_data]=importdata('control_data.txt','%s'); 
%当前是11+15一组，因为有一轮4个摇杆舵量数据丢失
data_to_read = length(raw_data);
data_length = floor((data_to_read-1)/(11+15))*2;%往小取整

ref = zeros(3, data_length);%油门那个就不看了
out = zeros(3, data_length);
controller = zeros(4, data_length/2);
euler_angle = ref;
motor = controller;
angle_rate = ref;
kr = 1;kc = 1;ko = 1;ke = 1;km = 1;
for i = 1:1:data_to_read %如需要跳过时间就从i=2开始
    str_temp = cell2mat(raw_data(i));
    if(str_temp(2) == 'e')% Ref 参考信号
        ref(1,kr) = str2double(str_temp(23:28));
        ref(2,kr) = str2double(str_temp(31:38));
        ref(3,kr) = str2double(str_temp(39:48));
        kr = kr+1;
    elseif(str_temp(6) == 'l')% RA 遥控器控制量信号
        controller(1,kc) = str2double(str_temp(9:12));
    elseif(str_temp(6) == 'e')
        controller(2,kc) = str2double(str_temp(9:12));
    elseif(str_temp(6) == 'r')
        controller(3,kc) = str2double(str_temp(9:12));
    elseif(str_temp(6) == 'd')
        controller(4,kc) = str2double(str_temp(9:12));
        kc = kc+1;
    elseif(str_temp(1) == 'O')% Output
        out(1,ko) = str2double(str_temp(23:28));%内环实际输出
        out(2,ko) = str2double(str_temp(40:50));
        out(3,ko) = str2double(str_temp(56:71));
        ko = ko+1;
    elseif(str_temp(1) == 'E')% Euler Angle
        euler_angle(1,ke) = str2double(str_temp(23:29));
        euler_angle(2,ke) = str2double(str_temp(33:42));
        euler_angle(3,ke) = str2double(str_temp(43:55)); 
    elseif(str_temp(1) == 'A')%Angle Rate
        %一般输出角，随即输出角速度，特殊情况处理一下就好
        angle_rate(1,ke) = str2double(str_temp(23:29));
        angle_rate(2,ke) = str2double(str_temp(33:42));
        angle_rate(3,ke) = str2double(str_temp(43:end));
        ke = ke+1;
    elseif(str_temp(1) == '1')% 
        % 1考虑数据范围 [0,2000]
        % 2考虑最长位置和最短位置不重合 
        % 数最长最短位置
        % 末尾空格个数
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
%% 上面得到了原始数据下面进行处理
Reference_o(1,:) = ref(1,:);
Reference_o(2,:) = ref(2,:);
Reference_o(3,:) = ref(3,:);

u_i_antiwindup = zeros(3,data_length);    %初始化当前的内环外环控制量初始化                   
u_o_antiwindup = zeros(3,data_length);
y_i_antiwindup = u_i_antiwindup;
y_o_antiwindup = u_o_antiwindup;
%% 通过遥控器舵量计算理论参考值和理论输出值
% time_finish = 2;%仿真结束时间10s
% T = 0.02;        %时间间隔0.02s
% t = 0:T:time_finish-T;
% rc_commands = zeros(4,time_finish/T);
% rc_commands(1,:) = 1000*sin(t)+1000;%这块应该输出加上空格，否则没法写
% rc_commands(2,:) = 1000*sin(t+pi/2)+1000;
% rc_commands(3,:) = 1000*sin(t+pi)+1000;
% rc_commands(4,:) = 1000*sin(t+3*pi/2)+1000;
% 
% % 转化为角度参考
% deg_lim = 20;                                               % 暂且限制范围为[-20, 20] 单位：角度
% deg_per_signal = 2*deg_lim/2000;                            % 每单位舵量对应的角度 
% 
% Reference_o(1,:) = (rc_commands(1,:)-1000) * deg_per_signal;
% Reference_o(2,:) = (rc_commands(2,:)-1000) * deg_per_signal;        
% Reference_o(3,:) = (rc_commands(4,:)-1000) * deg_per_signal;       
  

% u_i_antiwindup = zeros(3,time_finish/T);    %初始化当前的内环外环控制量初始化                   
% u_o_antiwindup = zeros(3,time_finish/T);
% y_i_antiwindup = u_i_antiwindup;
% y_o_antiwindup = u_o_antiwindup;
%% 双边微分之后用的是前一次控制量迭代当前控制量，无累积作用方便anti-windup
a = 1;b = 0;%1/s
ksi = 0.707; wn = 10;%目标二阶系统
type = 2; %使用IP控制器（反馈校正）
[Kp,tauI,close_transfunc_outer] = fir_odr_sec_odr_get_PIDs(a,b,ksi,wn,type);% Kp=14.14 tauI=0.1414
K = 20;															
% Kp = 20.14;
% tauI = 0.314;
i_term = 0;




for axis = 1:2 %滚转俯仰轴
    for i = 3:data_length 
        %外环
        p_term = double(Kp*(-y_o_antiwindup(axis,i-1)+y_o_antiwindup(axis,i-2)));                %IP控制 比例部分位于反馈回路上
        i_term = Kp/tauI*(Reference_o(axis,i)-y_o_antiwindup(axis,i-1))*T;                       %无累积作用,这个用了两步骤输出y，计算结果可能和上个有一个T延迟
        u_o_antiwindup(axis,i) = p_term+i_term+u_o_antiwindup(axis,i-1);

        %内环
        Reference_i = u_o_antiwindup(axis,i);                                          %外环控制信号作为内环参考信号
        error_i = Reference_i-y_i_antiwindup(axis,i-1);                  
        u_i_antiwindup(axis,i) = K*error_i;                                            %大增益很快收敛，内环输出控制量给电机

        % 抗积分饱和
        output_limit = 10000;
        if(u_i_antiwindup(axis,i) > output_limit)
            u_i_antiwindup(axis,i) = output_limit;
        elseif(u_i_antiwindup(axis,i) < -output_limit)
            u_i_antiwindup(axis,i) = -output_limit;
        end
        %内外环输出
%          y_i_antiwindup(axis,i) = y_i_antiwindup(axis,i-1)+u_i_antiwindup(axis,i)*T;              %这是理论积分模型，实际不是这个
%          y_o_antiwindup(axis,i) = y_o_antiwindup(axis,i-1)+y_i_antiwindup(axis,i)*T;
%        y_i_antiwindup(axis,i) = 0;
%        y_o_antiwindup(axis,i) = 0; %当前正在测试理论值，测试变量为控制信号，因此设置y_o为0
         
       y_i_antiwindup(axis,i) = angle_rate(axis,i);
       y_o_antiwindup(axis,i) = euler_angle(axis,i); %测试实际值
    end
end

%偏航轴
error_i = Reference_o(3,:);%-angle_rate(4,:);
output(3,:) = K*error_i;



%% 遥控器信号
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


%% 参考角度信号与跟踪情况
%内环
plot_index = 1;%1--roll 2--pitch 3--thrust 4--yaw
figure(1)
subplot(211)
plot(t,y_i_antiwindup(plot_index,:),'c.')%抗积分饱和微分形式设计，离散系统输出
xlabel('Time:(s)')
ylabel('State Output')
title('内环系统状态输出图')

subplot(212)
plot(t,u_i_antiwindup(plot_index,:),'c.')
hold on
plot(t,out(plot_index,1:length(t)),'b');%内环控制量
xlabel('Time:(s)')
ylabel('Output')
legend('Innerloop Control Output')
title('内环控制输入图')


%外环
figure(3)
subplot(211)
plot(t,Reference_o(plot_index,1:length(t)),'--r');%参考信号
hold on
plot(t,y_o_antiwindup(plot_index,:),'c.')%系统状态
xlabel('Time:(s)')
ylabel('Signal')
legend('Reference','State Output');
title('外环系统状态输出图')

subplot(212)
plot(t,u_o_antiwindup(plot_index,:),'c.')
xlabel('Time:(s)')
ylabel('Output')
legend('Outerloop Control Output');
title('外环控制输入图')





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
title('倍率0.5的四个电机控制量输出：[0 2000]')

subplot(212)%摇杆舵量输出，这个和参考信号应该正比关系
plot(t,controller(1,1:length(t)),'r')
hold on
plot(t,-controller(2,1:length(t)),'g')%为了观察正比关系
plot(t,controller(3,1:length(t)),'b')
plot(t,controller(4,1:length(t)),'c')
xlabel('Time:(s)')
ylabel('Signal')
legend('副翼','升降','油门','方向');
title('四个摇杆舵量 [0 2000]')






