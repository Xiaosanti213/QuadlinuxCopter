%myfunction
%edit by zhangxin 20160227

addpath('Quaternions');
addpath('ximu_matlab_library');


% Manually frame data
samplePeriod = 1/128;%这个物理量的意义是“连续”采样的间隔时间

 startTime = 100;
 stopTime = 130;
% 提取想要的数据，时间段是从自己给定的时间开始的到结束

% 角度弧度转换 US->S
rad2deg = 180/pi;
us2s = 1e-6;
mss2g = 9.81;

%indexSel = find(sign(time-startTime)+1, 1) : find(sign(time-stopTime)+1, 1);
time = IMU(:,2)*us2s;

gyrX = IMU(:,3)*rad2deg;
gyrY = IMU(:,4)*rad2deg;
gyrZ = IMU(:,5)*rad2deg;


accX = IMU(:,6)/mss2g; %这个获取加速度值列向量
accY = IMU(:,7)/mss2g;
accZ = -IMU(:,8)/mss2g;%这个坐标轴换一下



% -------------------------------------------------------------------------
% Detect stationary periods 检测静止的时间

% Compute accelerometer magnitude  计算合加速度
acc_mag = sqrt(accX.*accX + accY.*accY + accZ.*accZ);

% HP filter accelerometer data  滤波A
filtCutOff = 0.001;
[b, a] = butter(1, (2*filtCutOff)/(1/samplePeriod), 'high');
acc_magFilt = filtfilt(b, a, acc_mag);

% Compute absolute value 计算滤波之后的合加速度绝对值
acc_magFilt = abs(acc_magFilt);

% LP filter accelerometer data   滤波B
filtCutOff = 5;
[b, a] = butter(1, (2*filtCutOff)/(1/samplePeriod), 'low');
acc_magFilt = filtfilt(b, a, acc_magFilt);

% Threshold detection 通过设定了一个阈值来判定是不是静态，就是说可以稍微有抖动
stationary = acc_magFilt < 0.05;

% -------------------------------------------------------------------------
% Plot data raw sensor data and stationary periods 绘制第一幅图是原始数据

% figure('Position', [9 39 900 600], 'Number', 'off', 'Name', 'Sensor Data');
% ax(1) = subplot(2,1,1);
%     hold on;
%     plot(time, gyrX, 'r');
%     plot(time, gyrY, 'g');
%     plot(time, gyrZ, 'b');
%     title('Gyroscope');
%     xlabel('Time (s)');
%     ylabel('Angular velocity (^\circ/s)');
%     legend('X', 'Y', 'Z');
%     hold off;
% ax(2) = subplot(2,1,2);
%     hold on;
%     plot(time, accX, 'r');
%     plot(time, accY, 'g');
%     plot(time, accZ, 'b');
%     plot(time, acc_magFilt, ':k');
%     plot(time, stationary, 'k', 'LineWidth', 2);
%     title('Accelerometer');
%     xlabel('Time (s)');
%     ylabel('Acceleration (g)');
%     legend('X', 'Y', 'Z', 'Filtered', 'Stationary');
%     hold off;
% linkaxes(ax,'x');

% -------------------------------------------------------------------------
% Compute orientation 计算方位取向

quat = zeros(length(time), 4);
AHRSalgorithm = AHRS('SamplePeriod', samplePeriod, 'Kp', 1, 'KpInit', 1);

% Initial convergence 初始状态的融合
initPeriod = 2;%给定初始化的时间段并计算初始时候的状态
indexSel = 1 : find(sign(time-(time(1)+initPeriod))+1, 1);
for i = 1:2000
    AHRSalgorithm.UpdateIMU([0 0 0], [mean(accX(indexSel)) mean(accY(indexSel)) mean(accZ(indexSel))]);
end

% For all data 对所有的数据进行计算 计算四元数
for t = 1:length(time)
    if(stationary(t))
        AHRSalgorithm.Kp = 0.5;
    else
        AHRSalgorithm.Kp = 0;
    end
    AHRSalgorithm.UpdateIMU(deg2rad([gyrX(t) gyrY(t) gyrZ(t)]), [accX(t) accY(t) accZ(t)]);
    quat(t,:) = AHRSalgorithm.Quaternion;
end

% -------------------------------------------------------------------------
% Compute translational accelerations 平动的加速度acc

% Rotate body accelerations to Earth frame
% quat也是一个四维度行向量，quaternConj(quat)也是一个四维度行向量
acc = quaternRotate([accX accY accZ], quaternConj(quat));
%这个步骤把四元数矩阵转换成了三维加速度


% % Remove gravity from measurements
% acc = acc - [zeros(length(time), 2) ones(length(time), 1)];     % unnecessary due to velocity integral drift compensation

% Convert acceleration measurements to m/s/s
acc = acc * 9.81;%这步骤是因为上面的是以g为单位，需要转化成m/s2

% % Plot translational accelerations   画出平动加速度acc这部分  
% figure('Position', [9 39 900 300], 'Number', 'off', 'Name', 'Accelerations');
% hold on;
% plot(time, acc(:,1), 'r');
% plot(time, acc(:,2), 'g');
% plot(time, acc(:,3), 'b');
% title('Acceleration');
% xlabel('Time (s)');
% ylabel('Acceleration (m/s/s)');
% legend('X', 'Y', 'Z');
% hold off;

% -------------------------------------------------------------------------
% Compute translational velocities 计算平动的速度vel

acc(:,3) = acc(:,3) - 9.81;%去掉重力部分

% Integrate acceleration to yield velocity
vel = zeros(size(acc));
for t = 2:length(vel)
    vel(t,:) = vel(t-1,:) + acc(t,:) * samplePeriod;
    if(stationary(t) == 1)
        vel(t,:) = [0 0 0];     % force zero velocity when foot stationary
    end
end


% Compute integral drift during non-stationary periods 非静态时积分漂移需要去除
velDrift = zeros(size(vel));
stationaryStart = find([0; diff(stationary)] == -1);
stationaryEnd = find([0; diff(stationary)] == 1);
for i = 1:numel(stationaryEnd)
    driftRate = vel(stationaryEnd(i)-1, :) / (stationaryEnd(i) - stationaryStart(i));
    enum = 1:(stationaryEnd(i) - stationaryStart(i));
    drift = [enum'*driftRate(1) enum'*driftRate(2) enum'*driftRate(3)];
    velDrift(stationaryStart(i):stationaryEnd(i)-1, :) = drift;
end

% Remove integral drift
vel = vel - velDrift;


% % Plot translational velocity 绘制平动速度vel
% figure('Position', [9 39 900 300], 'Number', 'off', 'Name', 'Velocity');
% hold on;
% plot(time, vel(:,1), 'r');
% plot(time, vel(:,2), 'g');
% plot(time, vel(:,3), 'b');
% title('Velocity');
% xlabel('Time (s)');
% ylabel('Velocity (m/s)');
% legend('X', 'Y', 'Z');
% hold off;

% -------------------------------------------------------------------------
% Compute translational position 计算出平动的位置pos

% Integrate velocity to yield position
pos = zeros(size(vel));
for t = 2:length(pos)
    pos(t,:) = pos(t-1,:) + vel(t,:) * samplePeriod;    % integrate velocity to yield position 对速度积分得到位置函数
end


% % Plot translational position 绘制出平动的位置pos
% figure('Position', [9 39 900 600], 'Number', 'off', 'Name', 'Position');
% hold on;
% plot(time, pos(:,1), 'r');
% plot(time, pos(:,2), 'g');
% plot(time, pos(:,3), 'b');
% title('Position');
% xlabel('Time (s)');
% ylabel('Position (m)');
% legend('X', 'Y', 'Z');
% hold off;

% -------------------------------------------------------------------------
% Plot 3D foot trajectory 绘制轨迹

% % Remove stationary periods from data to plot
% posPlot = pos(find(~stationary), :);
% quatPlot = quat(find(~stationary), :);
posPlot = pos;
quatPlot = quat;

% Extend final sample to delay end of animation

% extraTime = 20;
% onesVector = ones(extraTime*(1/samplePeriod), 1);
% posPlot = [posPlot; [posPlot(end, 1)*onesVector, posPlot(end, 2)*onesVector, posPlot(end, 3)*onesVector]];
% quatPlot = [quatPlot; [quatPlot(end, 1)*onesVector, quatPlot(end, 2)*onesVector, quatPlot(end, 3)*onesVector, quatPlot(end, 4)*onesVector]];


% Create 6 DOF animation
SamplePlotFreq = 4;%样本绘图频率
Spin = 120;%自旋
rotMat = quatern2rotMat(quatPlot);
SixDofAnimation(posPlot, quatern2rotMat(quatPlot), ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'DotsOnly', ...
                'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
                'AxisLength', 0.1, 'ShowArrowHead', false, ...
                'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, ...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));

 % 解释各个变量的含义  第一个是位置，第二个是使用了（四元数->旋转矩阵）转化  
 % 绘图频率，上面有定义是4单位应该是s-1；  Trail表示拖出尾迹
 % ‘Position’下一个是位置具体值[9 39 1280 768]
 % 最后其实绘制轨迹曲线只需要这两个：位置信息和euler矩阵
 
 
 
 
 
            
            
            
            
