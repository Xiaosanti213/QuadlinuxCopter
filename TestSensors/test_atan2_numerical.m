%测试atan数值解法
clear
close all
clc




%% 测试atan数值解法
y = -0.1:0.1:10;
x = 1;
z1 = atan2(y,x)*180/pi;
z2 = zeros(1,length(y));
for k = 1:1:length(y)
    z2(k) = atan2_numerical(y(k),x)/10;%为了避免浮点数运算，都直接转化为32bit整数
end


%% 画图
figure
plot(y,z1,'--r');
hold on
plot(y,z2,'g');
xlabel('tan');
ylabel('arctan');

legend('Reference','Test Result');






