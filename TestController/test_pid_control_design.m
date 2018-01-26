%PI控制器设计，离散化测试
clear 
close all
clc

%% 指定原系统
syms s
transfunc = 1/(s+1);



%% 设计控制系统，这块应该使用一个函数计算参数保证控制性能
Kp = 20;
tauI = 0.3;
tauD = 0;
controller_transfunc = Kp*[(1+tauI*s)/tauI/s]*(1+tauD*s); %PI控制器设计
transfunc_open = transfunc*controller_transfunc;


%% 开环传函计算完毕
close_transfunc = get_close_loop_transfunc(transfunc_open,1);
time_domain_continuous_tf = ilaplace(close_transfunc/s);%阶跃响应
time_finish = 10;                         %10s
T = 0.02;                                 %步长0.02s
t = 0:T:time_finish-T;     
y = subs(time_domain_continuous_tf);      %连续系统输出
r = ones(1,length(t));


%% 连续系统传函分成两段
% for k = 1:time_finish/T
%     u(k) = Kp*(r-y)+Kp/tauI*double(int(r-y, 0, k));
% end




%% 离散控制量
i_term = 0;
error = zeros(1,time_finish/T);
u_d = error;
for i = 2:time_finish/T %这种东西貌似没法直接仿真，只能依据理论的推算输出并比较。
    error(i) = r(i)-y(i-1);
    p_term = Kp*error(i);
    i_term = i_term+Kp/tauI*error(i)*T;
    u_d(i) = p_term+i_term;
end



%% 画图
figure(1)
plot(t,r,'--r')
hold on
plot(t,y,'b');
xlabel('Time:(s)');
ylabel('Signal');
ylim([0,1.2]);
legend('Reference','Continuous');%'Discrete');




figure(2)
plot(t,u_d,'ro');


