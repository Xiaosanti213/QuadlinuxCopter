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
get_second_order_performance_index(ksi,wn);

[~,den] = numden(close_transfunc_outer);
coe = coeffs(den);
p_o = double(roots(coe(end:-1:1)));
figure
plot(real(p_o),imag(p_o),'r*');
hold on
plot(-K,0,'b*');
legend('外环极点','内环极点');


%% 时域
time_finish = 1.5;                                                  %仿真时间1.5s
T = 0.02;                                                           %仿真步长20ms
Reference_o = ones(1,time_finish/T);                                %阶跃参考信号
t = 0:T:time_finish-T;
time_domain_transfunc_outer = ilaplace(close_transfunc_outer/s);    %时域内环传函 单位阶跃信号
time_domain_transfunc_inner = ilaplace(close_transfunc_inner/s);
yo = double(subs(time_domain_transfunc_outer));                     %sym类型变量将导致计算变慢
yi = double(subs(time_domain_transfunc_inner));%这个 


%% 控制量离散化 该部分写入控制器
i_term = 0;
u_i = zeros(1,time_finish/T);                       
u_o = zeros(1,time_finish/T);
for i = 2:time_finish/T 
    error_o = Reference_o(i)-yo(i-1);
    %p_term = Kp*error_i(i);                        %传统PI控制 比例部分位于主回路上
    p_term = -double(Kp*yo(i-1));                   %IP控制 比例部分位于反馈回路上
    i_term = i_term+Kp/tauI*error_o*T;
    u_o(i) = p_term+i_term;
    Reference_i = u_o(i);                           %外环控制信号作为内环参考信号
    error_i = Reference_i-yi(i-1);                  
    u_i(i) = -K*error_i;                            %大增益很快收敛，内环输出控制量给电机
                                                    %这块需要考虑的：抗饱和
end



%% 画图
%内环 不准 没用
% figure(1)
% subplot(211)
% plot(t,u_o,'--r');%内环参考信号
% hold on
% plot(t,yi,'b');   %内环输出信号
% xlabel('Time:(s)')
% ylabel('Signal')
% legend('Reference','Designed System');

% subplot(212)
% plot(t,u_i,'r.');%内环控制信号
% xlabel('Time:(s)')
% ylabel('Output')
% legend('Control Output')

%外环
figure(2)
subplot(211)
plot(t,Reference_o,'--r');
hold on
plot(t,yo,'b');
xlabel('Time:(s)')
ylabel('Signal')
legend('Reference','Designed System');

subplot(212)
plot(t,u_o,'r.');
xlabel('Time:(s)')
ylabel('Output')
legend('Control Output')

%比较内环外环收敛速度
figure(3)
plot(t,Reference_o,'--r');
hold on
plot(t,yo,'b');
plot(t,yi,'g');
xlabel('Time:(s)')
ylabel('Signal')
legend('Reference','Outer Loop','Inner Loop');






