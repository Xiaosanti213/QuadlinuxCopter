%����atan��ֵ�ⷨ
clear
close all
clc




%% ����atan��ֵ�ⷨ
y = -0.1:0.1:10;
x = 1;
z1 = atan2(y,x)*180/pi;
z2 = zeros(1,length(y));
for k = 1:1:length(y)
    z2(k) = atan2_numerical(y(k),x)/10;%Ϊ�˱��⸡�������㣬��ֱ��ת��Ϊ32bit����
end


%% ��ͼ
figure
plot(y,z1,'--r');
hold on
plot(y,z2,'g');
xlabel('tan');
ylabel('arctan');

legend('Reference','Test Result');






