function [tr, tp, ts, sigma, N]=get_second_order_performance_index(ksi,wn)
%% 计算性能指标
if(ksi>=1)
    %过阻尼情况可以用数值方法计算
    return;
else                                        %欠阻尼
    wd = sqrt(1-ksi^2)*wn;
    beta = atan2(sqrt(1-ksi^2),-ksi);       %-pi~pi
    tr = beta/wd;                           %上升时间
    tp = pi/wd;                             %峰值时间
    ts = 3.5/ksi/wn;                        %5%误差带
    ts1 = 4.5/ksi/wn;                       %2.5%误差带
    sigma = exp(-pi*ksi/sqrt(1-ksi^2));     %超调量,比例
    N = -2.25/log(sigma);                   %振荡次数 2%误差带
    N1 = -1.75/log(sigma);                  %振荡次数 5%误差带
end


%% 时域单位阶跃响应
syms s t;
g = wn^2/(s^2+2*ksi*wn*s+wn^2);
time_domain_transfunc = ilaplace(g/s);
time_finish = 1.5;
T = 0.02;
t = 0:T:time_finish-T;
y = subs(time_domain_transfunc);
r = ones(1,time_finish/T);


%% 画图
figure(1)
plot(t,r,'--r')
hold on
plot(t,y,'b');
xlabel('Time:(s)')
ylabel('Signal')

%性能指标关键点

syms t
yr = subs(time_domain_transfunc,t,tr);%上升到达目标100%位置点
plot(tr,yr,'p');
yp = subs(time_domain_transfunc,t,tp);%上升到达峰值置点
plot(tp,yp,'p');
ys = subs(time_domain_transfunc,t,ts);%上升到达5%误差带位置点
plot(ts,ys,'p');
ys1 = subs(time_domain_transfunc,t,ts1);%上升到达2.5%误差带位置点
plot(ts1,ys1,'p');



legend('Reference','Designed Second-Order System','上升时间','峰值时间',...
    '5%误差带','2.5%误差带');
sigma_str = strcat('超调量： ',num2str(sigma*100),' %');
N_str = strcat('振荡次数(5%误差带）: ',num2str(N1));
text(tp,1+sigma+0.10,sigma_str);
text(tp-0.1,1+sigma+0.05,N_str);

