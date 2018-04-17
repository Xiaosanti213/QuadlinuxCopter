%% 卡尔曼预测，例程同离散最小二乘
% 核心思想：先由前次预测直接递推预测
% 再用前次观测校正本次预测
clear 
close all
clc


%% step1：给定结构参数与初始值
sim_finish = 500;                       % 仿真长度
dim = 2;                                % x的维度 
R = zeros(1,1,sim_finish+1);            % 测量噪声协方差
H = zeros(1,dim,sim_finish+1);          % 测量量与状态量关系矩阵（只有一个测量量）

P = zeros(dim,dim,sim_finish+1);        % 初始估计的协方差阵
P(:,:,1) = eye(2);

y = zeros(1,1,sim_finish+1);            % 真实值

x_hat = zeros(dim,1,sim_finish+1);      % 初始化估计变量
x_hat(:,:,1) = [8 7]';                  % 估计变量赋初值，随便取，将会稳定收敛
fai = zeros(dim,dim,sim_finish+1);      % 状态转移矩阵单位阵

for i = 1:1:sim_finish+1
    H(:,:,i) = [1, 0.99^(i-1)];
    R(:,:,i) = 1;
    y(:,:,i) = H(:,:,i)*[10,5]';        % 可以在此基础上增加测量噪声
    fai(:,:,i) = eye(dim);              % 状态转移矩阵不随时间变化
end

K = zeros(2,1,sim_finish+1);
gamma = K;                              % 状态转移误差阵，后续添加应用
Q = K;
%% step2:仿真迭代
% 实际编程过程中不需要都存储下来的

for i = 2:1:sim_finish+1
    K(:,:,i) = fai(:,:,i)*P(:,:,i-1)*H(:,:,i)'/(H(:,:,i)*P(:,:,i-1)*H(:,:,i)'+R(:,:,i));
    x_hat(:,:,i) = fai(:,:,i)*x_hat(:,:,i-1)+K(:,:,i)*(y(:,:,i) - H(:,:,i)*x_hat(:,:,i-1));
    P(:,:,i) = fai(:,:,i)*P(:,:,i-1)*fai(:,:,i)'-K(:,:,i)*H(:,:,i)*P(:,:,i-1)*fai(:,:,i);
end

%% 符号说明
% K(:,:,i) 用i时刻预测i+1时刻的补偿部分系数
% fai(:,:,i) i-1->i时刻状态转移矩阵 



%% step3:plot
temp_x1 = vector_to_mat(x_hat);
temp_p1 = vector_to_mat1(P);

figure(1)

subplot(211)
plot(1:1:sim_finish+1,temp_x1(1,:),'r-');
hold on
plot(1:1:sim_finish+1,temp_x1(2,:),'b.');
xlabel('simu_times')
ylabel('估计值')
legend('Estimated x1','Estimated x2')


subplot(212)
plot(1:1:sim_finish+1,temp_p1(1,:),'r-');
hold on 
plot(1:1:sim_finish+1,temp_p1(2,:),'b.');
xlabel('simu_times')
ylabel('估计协方差')

hold on





%% 三维矩阵转换成二维矩阵或向量
function mat = vector_to_mat(vec)
    for i = 1:1:501
        mat(1,i) = vec(1,1,i);
        mat(2,i) = vec(2,1,i);
    end
end

function mat1 = vector_to_mat1(mat)
    for i = 1:1:501
        mat1(1,i) = mat(1,1,i);
        mat1(2,i) = mat(2,2,i);
    end
end


