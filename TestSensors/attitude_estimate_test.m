clear
close all
clc


%% stage 1a: 从txt中读入数据并转换到 前-右-下 坐标系当中
data_length = 100; % 需要根据实际情况确定,下面用来存储数据
acc = zeros(3, data_length);
acc_amp = acc;%用来记录模长 
gyro = acc;
mag = acc;
baro = zeros(1, data_length);
%下面用来将当前的Euler角表示姿态,姿态初始值都是0
pitch = acc;
roll = acc;
yaw = acc;

%% 
delta

%这块需要多加一个函数atan2 用法类似matlab库函数如下
%四个象限都能算
% atan2(sqrt(3),1) * 180/(pi);   %  60
% atan2(sqrt(3),-1) * 180/(pi);  %  120
% atan2(-sqrt(3),1) * 180/(pi);  %  -60
% atan2(-sqrt(3),-1) * 180/(pi); %  -120



%% sim准备
deltaT = 0.1;
%当前测量的数据可能不是0，这将导致姿态不是0
acc_amp(1) = sqrt(acc(1,1)^2, acc(2,1)^2, acc(3,1)^2);%正交化过程是否每次都需要进行,这个需要讨论
acc(1,1) = acc(1,1)/acc_amp(1);
acc(2,1) = acc(2,1)/acc_amp(1);
acc(3,1) = acc(3,1)/acc_amp(1);
gravity = [0;0;1];
% 下面的问题实际上就是已知两个坐标系中的矢量如何求解变换矩阵
% 使用罗德里格旋转公式计算
rot_matrix = calculate_rot_matrix(gravity, acc(:,1));



%%
for k = 2:deltaT:data_length
    pitch(k) = 
end


