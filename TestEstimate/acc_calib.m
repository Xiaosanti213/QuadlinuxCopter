%% SY1705423 张鑫 第一章作业 加速度计无依托标定
clear 
close all
clc

%% 按照 前-右-下 坐标系生成若干组行向量初始测量值 
a = repmat(9.8*eye(3),[3,1])+(0.5*ones(9,3)-rand(9,3));
% 测量值上添加均值为0 方差为1 的高斯白噪声

%% 直接解析方法计算线性最小二乘解
H = zeros(size(a,1),6);%初始化
for i = 1:1:size(a,1)
    H(i,:) = [a(i,1)^2, a(i,1), a(i,2)^2, a(i,2), a(i,3)^2, a(i,3)];
end

b = -ones(size(a,1),1);

p = (H'*H)\H'*b;
%% 由p阵计算偏移量b，标定值k
A_temp = -4*diag([p(1)/p(2)^2, p(3)/p(4)^2, p(5)/p(6)^2]);
A = A_temp+ones(3);

g = 9.8;% 取g=9.8m/s2
G = ones(3,1)*g^2;

B = A\G;

%% 









