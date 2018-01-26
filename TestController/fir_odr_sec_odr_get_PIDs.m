function [Kp,tauI,close_transfunc] = fir_odr_sec_odr_get_PIDs(a,b,ksi,wn,type)
%原系统一阶
%目标二阶闭环传函 通过设计1无阻尼自然频率wn 2相对阻尼比ksi设计
%计算PID系数 系统传函为a/(s+b)

syms s
%% 传统PI控制器配置得到闭环传函增加零点
% 闭环并没有完全实现,分子多一个闭环零点taus+1
if(type == 1)
    tauI = (2*ksi*wn-b)/wn^2;
    Kp = (2*ksi*wn-b)/a;
    close_transfunc = wn^2/(s^2+2*ksi*wn*s+wn^2)*(s+1/tauI);
%% IP控制,解决传统PI控制器
% 因为负反馈Kp作用于支路G(s)上，故算是一种反馈矫正
% 仅针对本问题：积分环节仍然在原位置Kp/(tauI*s)算法一模一样
elseif(type == 2)
    tauI = (2*ksi*wn-b)/wn^2;
    Kp = (2*ksi*wn-b)/a;
    close_transfunc = wn^2/(s^2+2*ksi*wn*s+wn^2);%没有零点
elseif(type == 3)
%% 带有滤波器的PD控制器
% 上边已经可以达到控制目标 下面很少使用
elseif(type == 4)
%% 带有微分滤波器的PID控制器
else
end



%% 带有滤波器的PD控制器
% 模型: C(s)=Kp+Kd*s/(tauf+1) 
% 高阶形式上如果不能约掉，需要指定极点位置并通过多项式形式待定系数得到






%% 在时域内画出响应曲线
time_finish = 3;                              %仿真时间10s
T = 0.02;                                     %仿真步长20ms
Reference = ones(1,time_finish/T);            %阶跃参考信号
time_domain_transfunc = ilaplace(close_transfunc/s);
t = 0:T:time_finish-T;
y = subs(time_domain_transfunc);


% 画图
% figure(1)
% plot(t,Reference)
% hold on
% plot(t,y);
% xlabel('Time:(s)')
% ylabel('Signal')
% legend('Reference','Designed System');
