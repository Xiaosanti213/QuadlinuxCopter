clear
close all
clc
%% ���ɾ��ȷֲ�����
len = 100;
y = normrnd(0,2,1,len);%����0������2�����ȷֲ�
t = 1:1:len;

%% ƽ���˲�
%gyroData[axis] = (gyroSmooth[axis] * (conf.Smoothing[axis]-1) )+gyroData[axis])  / conf.Smoothing[axis];
smoothing = 1.2;
ys = zeros(1,len);
for i = 2:1:len
    ys(i) = (ys(i-1) * (smoothing-1) +y(i))  / smoothing;
end

figure
plot(t,y,'r');
hold on
plot(t,ys,'b');








