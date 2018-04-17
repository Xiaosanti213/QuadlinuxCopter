 %% Dan Simon最优状态估计 测试3.3递推最小二乘估计
% clear 
% close all
% clc


%% step1:给定结构参数与初始值
sim_finish = 500;                       % 仿真长度
dim = 2;                                % x的维度 
R = zeros(1,1,sim_finish+1);            % 测量噪声协方差
H = zeros(1,dim,sim_finish+1);          % 测量量与状态量关系矩阵（只有一个测量量）

P = zeros(dim,dim,sim_finish+1);        % 初始估计的协方差阵
P(:,:,1) = eye(2);

y = zeros(1,1,sim_finish+1);            % 真实值

x_hat = zeros(dim,1,sim_finish+1);      % 初始化估计变量
x_hat(:,:,1) = [8 7]';                  % 估计变量赋初值
for i = 1:1:sim_finish+1
    H(:,:,i) = [1, 0.99^(i-1)];
    R(:,:,i) = 1;
    y(:,:,i) = H(:,:,i)*[10,5]';        % 测量值，可以在此基础上增加测量噪声
end

K = zeros(2,1,sim_finish+1);
%% step2:仿真迭代
for k = 2:1:sim_finish+1
    K(:,:,k) = P(:,:,k-1)*H(:,:,k)'/((H(:,:,k)*P(:,:,k-1)*H(:,:,k)'+R(:,:,k)));%计算参与迭代的K矩阵
    x_hat(:,:,k) = x_hat(:,:,k-1)+K(:,:,k)*(y(:,:,k)-H(:,:,k)*x_hat(:,:,k-1));
    P(:,:,k) = (eye(dim)-K(:,:,k)*H(:,:,k))*P(:,:,k-1)*(eye(dim)-K(:,:,k)*H(:,:,k))'+K(:,:,k)*R(:,:,k)*K(:,:,k)';
end


%% step3:plot
temp_x = vector_to_mat(x_hat);
temp_p = vector_to_mat1(P);

figure(2)

subplot(211)
plot(1:1:sim_finish+1,temp_x(1,:),'c-');
hold on
plot(1:1:sim_finish+1,temp_x(2,:),'g.');
xlabel('simu_times')
ylabel('估计值')
legend('Estimated x1','Estimated x2')


subplot(212)
plot(1:1:sim_finish+1,temp_p(1,:),'c-');
hold on 
plot(1:1:sim_finish+1,temp_p(2,:),'g.');
xlabel('simu_times')
ylabel('估计协方差')







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
