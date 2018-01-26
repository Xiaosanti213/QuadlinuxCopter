%% 二阶系统阻尼比自然频率确定单位阶跃响应 做设计用到
clear
close all
clc


%% 二阶典型系统闭环传函wn^2/(s^2+2*damping_coeff*s+wn^2)
%开环传函：
wn = 1;                                                         %和系统震荡频率正比
damping_coeff = [0:.1:0.9 1-eps,1.1:0.1:1.5];                   %阻尼比不为1
t = 0:0.05:20;
y = [];

for z = damping_coeff
    wd = sqrt(z^2-1)*wn;
    y = [y; 1-wn*exp(-z*wn*t).*[cosh(wd*t)/wn+z*sinh(wd*t)/wd]];%直接带入时域响应表达
end



%% 
figure(1)
plot(t,y)
xlabel('Time: (s)');
ylabel('Signal')
title('Second-Order Step Response')

figure(2)
surf(t, damping_coeff,y), shading flat



