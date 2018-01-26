% 系统高阶，首选绘制根轨迹
% 确定主要极点，除去偶极子
% 二阶系统通过ksi wn ts确定增益，保证性能
clear 
close all
clc


% %% 自动控制原理 孟庆明 P124例题 非单位反馈 
% syms K s
% n = K*[1 1];
% d = [1 2 0];
% transfunc = polyvec2numden_s(n,d,0);
% g = get_close_loop_transfunc(transfunc,1/(s+3));%P125上方验证正确


%% 系统传函
% num = [1];
% den = conv([1 1],[0.01 0.08 1]);
% G = tf(num, den);                      %使用rlocus参数是闭环传函，保证开环传函确定即可
% 将待求增益写成标准型1+K*P(s)/Q(s)，其中PQ为零极点多项式

%系统闭环传函给出，待定某系数，首先确定标准型，分母多项式写成1+K*P(s)/Q(s)
G_open = zpk([-1],[0,-2,-3],1);         % 根据广义根轨迹理论，系统开环传函和根轨迹一一对应
G = feedback(G_open,-1);               % 但由于反馈H~=1可能导致多个闭环传函对应一个开环传函，单位负反馈用-1

% R = rlocus(G);                      % 调用方式A: 数组形式给出R的位置，但是没有在图形上显示
rlocus(G);                            % 调用方式B: 根轨迹只在图形上绘出，在图上点击可以看到点的特点
% [R,K] = rlocus(G);                  % 调用方式C: 亦给出开环根轨迹增益K*需要和上面的连用



% point = ginput(2);                    % 手动确定临界点位置等
[K,P] = rlocfind(G);                  % 定位极点位置，确定K*，此处返回的K参数是上面多项式标准型的增益
%% 测试设计的系统阶跃响应
time_finish = 10;
T = 0.02;
t = 0:T:time_finish-T;
K = 16.2879;
num = K*pole2polyvec([-1,-3]);
den_temp = pole2polyvec([0 -2 -3]);
den_temp1 = pole2polyvec([-1]);
den = [0 0 K*den_temp1]+den_temp;%叠加两部分 向量元素个数不相等
G = tf(num,den);
y = step(G,t);

%% 画图
figure(1)
plot(t,ones(1,length(t)),'--r')
hold on
plot(t,y,'b')
xlabel('Time: s')
ylabel('Signal')
legend('Reference', 'Step Response of Designed System');


[num,den] = tfdata(G);                % 重新赋值一遍是如果tf通过zpk构成比较方便
% p = pole(G);                          % 闭环极点
% z = zero(G);
p = roots(den{1,1});                     % 闭环极点
z = roots(num{1,1});                     % 闭环零点
figure(2)
plot(real(p),imag(p),'r*')
hold on
plot(real(z),imag(z),'ro')
xlabel('Real')
ylabel('Image')
title('Polars and Zeros locations of Close-loop Transfer Function');
grid on
%% 比较闭环极点零件位置关系






%% 分析
%极点在实轴上，则过阻尼
%偶极子对消 模长比距离大一个数量级
%实部最小为主导 大于5倍实部绝对值 影响可忽略

%根据二阶系统根形式特点 可画出：
%等 阻尼比线
%等 固有频率线
%等 ts调节时间线










