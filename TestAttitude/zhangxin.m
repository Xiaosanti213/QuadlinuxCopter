%myfunction
%edit by zhangxin 20160227

addpath('Quaternions');
addpath('ximu_matlab_library');


% Manually frame data
samplePeriod = 1/128;%����������������ǡ������������ļ��ʱ��

 startTime = 100;
 stopTime = 130;
% ��ȡ��Ҫ�����ݣ�ʱ����Ǵ��Լ�������ʱ�俪ʼ�ĵ�����

% �ǶȻ���ת�� US->S
rad2deg = 180/pi;
us2s = 1e-6;
mss2g = 9.81;

%indexSel = find(sign(time-startTime)+1, 1) : find(sign(time-stopTime)+1, 1);
time = IMU(:,2)*us2s;

gyrX = IMU(:,3)*rad2deg;
gyrY = IMU(:,4)*rad2deg;
gyrZ = IMU(:,5)*rad2deg;


accX = IMU(:,6)/mss2g; %�����ȡ���ٶ�ֵ������
accY = IMU(:,7)/mss2g;
accZ = -IMU(:,8)/mss2g;%��������ỻһ��



% -------------------------------------------------------------------------
% Detect stationary periods ��⾲ֹ��ʱ��

% Compute accelerometer magnitude  ����ϼ��ٶ�
acc_mag = sqrt(accX.*accX + accY.*accY + accZ.*accZ);

% HP filter accelerometer data  �˲�A
filtCutOff = 0.001;
[b, a] = butter(1, (2*filtCutOff)/(1/samplePeriod), 'high');
acc_magFilt = filtfilt(b, a, acc_mag);

% Compute absolute value �����˲�֮��ĺϼ��ٶȾ���ֵ
acc_magFilt = abs(acc_magFilt);

% LP filter accelerometer data   �˲�B
filtCutOff = 5;
[b, a] = butter(1, (2*filtCutOff)/(1/samplePeriod), 'low');
acc_magFilt = filtfilt(b, a, acc_magFilt);

% Threshold detection ͨ���趨��һ����ֵ���ж��ǲ��Ǿ�̬������˵������΢�ж���
stationary = acc_magFilt < 0.05;

% -------------------------------------------------------------------------
% Plot data raw sensor data and stationary periods ���Ƶ�һ��ͼ��ԭʼ����

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
% Compute orientation ���㷽λȡ��

quat = zeros(length(time), 4);
AHRSalgorithm = AHRS('SamplePeriod', samplePeriod, 'Kp', 1, 'KpInit', 1);

% Initial convergence ��ʼ״̬���ں�
initPeriod = 2;%������ʼ����ʱ��β������ʼʱ���״̬
indexSel = 1 : find(sign(time-(time(1)+initPeriod))+1, 1);
for i = 1:2000
    AHRSalgorithm.UpdateIMU([0 0 0], [mean(accX(indexSel)) mean(accY(indexSel)) mean(accZ(indexSel))]);
end

% For all data �����е����ݽ��м��� ������Ԫ��
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
% Compute translational accelerations ƽ���ļ��ٶ�acc

% Rotate body accelerations to Earth frame
% quatҲ��һ����ά����������quaternConj(quat)Ҳ��һ����ά��������
acc = quaternRotate([accX accY accZ], quaternConj(quat));
%����������Ԫ������ת��������ά���ٶ�


% % Remove gravity from measurements
% acc = acc - [zeros(length(time), 2) ones(length(time), 1)];     % unnecessary due to velocity integral drift compensation

% Convert acceleration measurements to m/s/s
acc = acc * 9.81;%�ⲽ������Ϊ���������gΪ��λ����Ҫת����m/s2

% % Plot translational accelerations   ����ƽ�����ٶ�acc�ⲿ��  
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
% Compute translational velocities ����ƽ�����ٶ�vel

acc(:,3) = acc(:,3) - 9.81;%ȥ����������

% Integrate acceleration to yield velocity
vel = zeros(size(acc));
for t = 2:length(vel)
    vel(t,:) = vel(t-1,:) + acc(t,:) * samplePeriod;
    if(stationary(t) == 1)
        vel(t,:) = [0 0 0];     % force zero velocity when foot stationary
    end
end


% Compute integral drift during non-stationary periods �Ǿ�̬ʱ����Ư����Ҫȥ��
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


% % Plot translational velocity ����ƽ���ٶ�vel
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
% Compute translational position �����ƽ����λ��pos

% Integrate velocity to yield position
pos = zeros(size(vel));
for t = 2:length(pos)
    pos(t,:) = pos(t-1,:) + vel(t,:) * samplePeriod;    % integrate velocity to yield position ���ٶȻ��ֵõ�λ�ú���
end


% % Plot translational position ���Ƴ�ƽ����λ��pos
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
% Plot 3D foot trajectory ���ƹ켣

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
SamplePlotFreq = 4;%������ͼƵ��
Spin = 120;%����
rotMat = quatern2rotMat(quatPlot);
SixDofAnimation(posPlot, quatern2rotMat(quatPlot), ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'DotsOnly', ...
                'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
                'AxisLength', 0.1, 'ShowArrowHead', false, ...
                'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, ...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));

 % ���͸��������ĺ���  ��һ����λ�ã��ڶ�����ʹ���ˣ���Ԫ��->��ת����ת��  
 % ��ͼƵ�ʣ������ж�����4��λӦ����s-1��  Trail��ʾ�ϳ�β��
 % ��Position����һ����λ�þ���ֵ[9 39 1280 768]
 % �����ʵ���ƹ켣����ֻ��Ҫ��������λ����Ϣ��euler����
 
 
 
 
 
            
            
            
            
