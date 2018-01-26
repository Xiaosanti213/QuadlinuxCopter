%% ����ϵͳ�������ȻƵ��ȷ����λ��Ծ��Ӧ ������õ�
clear
close all
clc


%% ���׵���ϵͳ�ջ�����wn^2/(s^2+2*damping_coeff*s+wn^2)
%����������
wn = 1;                                                         %��ϵͳ��Ƶ������
damping_coeff = [0:.1:0.9 1-eps,1.1:0.1:1.5];                   %����Ȳ�Ϊ1
t = 0:0.05:20;
y = [];

for z = damping_coeff
    wd = sqrt(z^2-1)*wn;
    y = [y; 1-wn*exp(-z*wn*t).*[cosh(wd*t)/wn+z*sinh(wd*t)/wd]];%ֱ�Ӵ���ʱ����Ӧ���
end



%% 
figure(1)
plot(t,y)
xlabel('Time: (s)');
ylabel('Signal')
title('Second-Order Step Response')

figure(2)
surf(t, damping_coeff,y), shading flat



