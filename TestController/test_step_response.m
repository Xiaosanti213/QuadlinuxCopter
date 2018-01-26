%测试连续和离散系统PID控制响应情况
close all
clear 
clc


%% 通过零极点构建传函
% num = 0.3;
% den = pole2polyvec(-1);
% %transfunc = tf(num, den);                                    %构建传函tf类型
% transfunc = polyvec2numden_s(num, den, 0);                    %得到传函多项式
% close_transfunc = get_close_loop_transfunc(transfunc, 1);     %单位负反馈

% z = [0 1 2]';
% p = [-1 -2 -3]';
% K = 1.2;
% tfunc = zpk(z,p,K);                                           %得到数据zpk类型

%% 如果直接给出多项式构建传函
%syms s 
s = tf('s');
Kp = 10;           %比例控制器系数
tauD = 0.1;       %微分系数，对稳态误差无作用
tauD1 = 0.3;
tauD2 = 0.5;
tauI = 0.3;       %积分,积分项系数Kp/tauI当tauI减小，响应速度变快。分母加s提高系统型别稳态误差减0
tauI1 = 0.4;
tauI2 = 0.1;

transfunc = 0.3/(s+1);                                                   %构建系统传函
close_transfunc = add_p2transfunc(transfunc, Kp, tauD, tauI);        %加入传统PID控制器
close_transfunc1 = add_p2transfunc(transfunc, Kp, tauD1, tauI1);     
close_transfunc2 = add_p2transfunc(transfunc, Kp, tauD2, tauI2);     
%steady_state_error = get_stady_state_error(close_transfunc);        %加入信号之后计算稳态误差

%% s域转到z域范围内
final_time = 10;                                                     %结束时间10s
T = 0.02; T1 = 0.05; T2 = 0.1;                                       %仿真步长
k = final_time/T; k1 = final_time/T1; k2 = final_time/T2;            %迭代次数
t = 0:T:final_time-T;
% t1 = 0:T1:final_time-T1;
% t2 = 0:T2:final_time-T2;
y_d = con_tf2dis_recur_rslt(close_transfunc2,k,T);
% y_d1 = con_tf2dis_recur_rslt(close_transfunc,k1,T1);
% y_d2 = con_tf2dis_recur_rslt(close_transfunc,k2,T2);


%% 连续系统拉氏反变换转化到时域范围内
close_transfunc = close_transfunc/s;
close_transfunc1 = close_transfunc1/s;
close_transfunc2 = close_transfunc2/s;


time_domain_res_func  = ilaplace(transfunc_tf2sym(close_transfunc,1));                              %先转换成sym类型
time_domain_res_func1 = ilaplace(transfunc_tf2sym(close_transfunc1,1));
time_domain_res_func2 = ilaplace(transfunc_tf2sym(close_transfunc2,1));

%用t替换
response = double(subs(time_domain_res_func));                                                      %subs函数使用t数值函数中的变量
response1 = double(subs(time_domain_res_func1));              
response2 = double(subs(time_domain_res_func2));              


% k = t/T;                                                                                            %采样点序列
% response_discrete = abs(double(subs(time_res_discrete_func)));                                      %得到的数还有虚数？？？

%% 画图
figure
plot(t,ones(1,length(t)),'--r')
hold on
plot(t,response,'b')
plot(t,response1,'g')
plot(t,response2,'m')

plot(t,y_d,'b.')
% plot(t1,y_d1,'g.')
% plot(t2,y_d2,'m.')

xlabel('Time: s')
ylabel('Signal')
legend('Reference', 'Continuous1','Continuous2', 'Continuous3',...
        'Discrete1')%, 'Discrete2','Discrete3');
%sse = strcat('Steady-state Error: ', num2str(double(steady_state_error)));%先转成double类型，再转成str
%text(7,1,sse);%文字说明标注
xlim([0 t(end)]);
ylim([0 1.2])

