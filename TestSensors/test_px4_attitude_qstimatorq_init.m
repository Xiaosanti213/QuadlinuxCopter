%测试PX4 modules/attitude_estimator_q/init()函数中地球坐标系中矢量在机体坐标系投影结果
clear 
close all
clc

%%
%	Vector<3> k = -_accel;
%	k.normalize();
%	// i是地球x轴（指向北）的单位矢量在体轴系中的投影，和k正交
%	// 后面有个校正项目，回去验算一下
%	Vector<3> i = (_mag - k * (_mag * k));
%	i.normalize();
%
%	// i是地球x轴（指向北）的单位矢量在体轴系中的投影，和k，i均正交
%	Vector<3> j = k % i;
% accel = [1.2, -2.3, 3.8];%任意给出
% k = -_accel;


%% 任意给定一个姿态
roll = 0*ones(1,2);
pitch = -30*ones(1,2);
yaw = 0*ones(1,2);
dcm = zeros(3,3,2);
for i=1:2
    dcm(:,:,i) = euler_to_rotmatrix(yaw(i),roll(i),pitch(i));
end
animation


%% 计算机体系到NED系投影
body = dcm(:,:,2)*[0;0;1]




















