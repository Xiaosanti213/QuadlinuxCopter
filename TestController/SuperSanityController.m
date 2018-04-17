clear
close all
clc

%% 内环设计 内环改一下用P 快速收敛 带宽是10倍外环
% 带有反馈的积分环节是惯性环节，反馈增益调节闭环特征根
% K = -root(root<0)
K = 40;
syms s
close_transfunc_inner = get_close_loop_transfunc(K/s,1);

%% 内环等效，主导极点法看零极点分布
%close_trans_tf_inner = transfunc_sym2tf(close_transfunc_inner,1);
%rlocus(close_trans_tf_inner);                       %绘制根轨迹方便等效
%由于收敛很快，故直接等效为1


%% 外环设计 PI控制器
a = 1;b = 0;%1/s
ksi = 0.707; wn = 10;%目标二阶系统
type = 2; %使用IP控制器（反馈校正）
[Kp,tauI,close_transfunc_outer] = fir_odr_sec_odr_get_PIDs(a,b,ksi,wn,type);


%% 内环外环极点位置验证
%get_second_order_performance_index(ksi,wn);

[~,den] = numden(close_transfunc_outer);
coe = coeffs(den);
p_o = double(roots(coe(end:-1:1)));
% figure
% plot(real(p_o),imag(p_o),'r*');
% hold on
% plot(-K,0,'b*');
% legend('外环极点','内环极点');


%% 连续系统时域
time_finish = 2;                                                    %仿真时间1.5s
T = 0.02;                                                           %仿真步长20ms
Reference_o = ones(1,time_finish/T);                                %阶跃参考信号
t = 0:T:time_finish-T;

time_domain_transfunc_outer = ilaplace(close_transfunc_outer/s);    %时域内环传函 单位阶跃信号
time_domain_transfunc_inner = ilaplace(close_transfunc_inner/s);
yo = double(subs(time_domain_transfunc_outer));                     %sym类型变量将导致计算变慢
yi = double(subs(time_domain_transfunc_inner));

%% 控制量离散化 该部分写入控制器
i_term = 0;
u_i = zeros(1,time_finish/T);                       
u_o = zeros(1,time_finish/T);
y_i = u_i;
y_o = u_o;
for i = 2:time_finish/T 
    %计算外环控制输入：
    error_o = Reference_o(i)-y_o(i-1);
    %p_term = Kp*error_o;                            %传统PI控制 比例部分位于主回路上
    p_term = -double(Kp*y_o(i-1));                   %IP控制 比例部分位于反馈回路上
    i_term = i_term+Kp/tauI*error_o*T;               %累积作用，难以抗积分饱和
    u_o(i) = p_term+i_term;
    Reference_i = u_o(i);                            %外环控制信号作为内环参考信号
    %计算内环控制输入：
    error_i = Reference_i-y_i(i-1);                  
    u_i(i) = K*error_i;                              %大增益很快收敛，内环输出控制量给电机
    %计算内外环状态输出：
    y_i(i) = y_i(i-1)+u_i(i)*T;                      %后面实际上更多的过程就是完善这个模型
    y_o(i) = y_o(i-1)+y_i(i)*T;
end

%% 双边微分之后用的是前一次控制量迭代当前控制量，无累积作用方便anti-windup
i_term = 0;
u_i_antiwindup = zeros(1,time_finish/T);                       
u_o_antiwindup = zeros(1,time_finish/T);
y_i_antiwindup = u_i_antiwindup;
y_o_antiwindup = u_o_antiwindup;

for i = 3:time_finish/T 
    %外环
    p_term = double(Kp*(-y_o_antiwindup(i-1)+y_o_antiwindup(i-2)));           %IP控制 比例部分位于反馈回路上
    i_term = Kp/tauI*(Reference_o(i)-y_o_antiwindup(i-1))*T;                  %无累积作用,这个用了两步骤输出y，计算结果可能和上个有一个T延迟
    u_o_antiwindup(i) = p_term+i_term+u_o_antiwindup(i-1);
    
    %内环
    Reference_i = u_o_antiwindup(i);                                          %外环控制信号作为内环参考信号
    error_i = Reference_i-y_i_antiwindup(i-1);                  
    u_i_antiwindup(i) = K*error_i;                                            %大增益很快收敛，内环输出控制量给电机
    
    % 抗积分饱和
    output_limit = 50;
    if(u_i_antiwindup(i) > output_limit)
        u_i_antiwindup(i) = output_limit;
    elseif(u_i_antiwindup(i) < -output_limit)
        u_i_antiwindup(i) = -output_limit;
    end
    %内外环输出
   y_i_antiwindup(i) = y_i_antiwindup(i-1)+u_i_antiwindup(i)*T;              %后面实际上更多的过程就是完善这个模型
   y_o_antiwindup(i) = y_o_antiwindup(i-1)+y_i_antiwindup(i)*T;
%     y_i(i) = 0;
%     y_o(i) = 0;
end




%% 画图 
%内环
figure(1)
subplot(211)
plot(t,u_o,'--r');%内环参考信号
hold on
%plot(t,yi,'m');   %内环连续系统输出信号,这个实际没法确定
plot(t,y_i,'b.'); %内环离散系统输出信号
plot(t,y_i_antiwindup,'c.')%抗积分饱和微分形式设计，离散系统输出
xlabel('Time:(s)')
ylabel('Signal')
legend('Reference','Discrete System','Discrete Antiwindup System');
title('内环系统状态输出图')

subplot(212)
plot(t,u_i,'b.'); %内环离散系统控制信号
hold on 
plot(t,u_i_antiwindup,'c.')
xlabel('Time:(s)')
ylabel('Output')
legend('Control Output','Anti-Windup Control Output Design')
title('内环控制输入图')


%外环
figure(2)
subplot(211)
plot(t,Reference_o,'--r');
hold on
plot(t,yo,'m'); %外环连续系统输出信号
plot(t,y_o,'b.');%外环离散系统输出信号
plot(t,y_o_antiwindup,'c.')%抗积分饱和微分形式设计，离散系统输出
xlabel('Time:(s)')
ylabel('Signal')
legend('Reference','Designed Continuous System','Discrete System','Anti-Windup Control Output Design');
title('外环系统输出状态图')

subplot(212)
plot(t,u_o,'b.');%外环离散系统控制信号
xlabel('Time:(s)')
ylabel('Output')
hold on
plot(t,u_o_antiwindup,'c.')
legend('Control Output','Anti-windup Output');
title('外环控制输入图')



% %比较内环外环收敛速度
% figure(3)
% plot(t,Reference_o,'--r');
% hold on
% plot(t,yo,'b');
% plot(t,yi,'g');
% xlabel('Time:(s)')
% ylabel('Signal')
% legend('Reference','Outer Loop','Inner Loop');






