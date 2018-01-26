%测试从z函数转化成差分方程
close all
clear
%clc

%%
ts=0.01;                      %采样时间 这个如果设置太短可能不收敛  
sys=tf([1],[1 0 0]);          %建立被控对象传递函数  
dsys=c2d(sys,ts,'tustin');    %zoh 
[num,den]=tfdata(dsys,'v');   %离散化后提取分子、分母    
rin=1.0;                      %输入为阶跃信号   
u_1=0.0; u_2=0.0;             %系统传函部分迭代系数初始化  
y_1=0.0; y_2=0.0;             %
error_1=0;                    %初始误差  
x=[0 0 0]';                   %存储误差比例积分微分部分  
pid = [3, 0.05, 4];           %PID第二个是微分
final_time=5;                 %仿真时间，到10s
for k=1:1:final_time/ts  
    r(k)=rin;   
    u(k)=pid(1)*x(1)+pid(2)*x(2)+pid(3)*x(3);          %这个控制量由误差决定
    %下面抗积分饱和
    if u(k)>=10  
        u(k)=10;  
    end
    if u(k)<=-10  
        u(k)=-10;  
    end
    yout(k)=-den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;    %差分方程移位定理递推 
    error(k)=r(k)-yout(k);                                   %计算更新error
    u_2=u_1;u_1=u(k);  
    y_2=y_1;y_1=yout(k);                                     %当前时刻的u和y与前一时刻的更新
    
    x(1)=error(k);   
    x(2)=(error(k)-error_1)/ts;  
    x(3)=x(3)+error(k)*ts;                                   %这个迭代也可以通过哪一种z变换得到？
    error_2=error_1;  
    error_1=error(k);  
end

%% 再用连续系统计算一下
% s = tf('s');
% sys_add_pid = sys*(pid(1)+pid(2)*s+pid(3)/s);
% close_transfunc = feedback(sys_add_pid,1);
% time_domain_transfunc = ilaplace(transfunc_tf2sym(close_transfunc/s,1));%加入阶跃信号
t = 0:ts:final_time-ts;
% y_c = subs(time_domain_transfunc);

%%
reference = ones(1,final_time/ts);
figure 
plot(t,reference,'--r')
xlabel('Time: (s)')
ylabel('Signal')
ylim([0,1.2])
hold on

%plot(t,y_c,'b')
plot(t,yout,'g.')
%legend('Reference','Continuous','Discrete')
legend('Reference','Discrete')
