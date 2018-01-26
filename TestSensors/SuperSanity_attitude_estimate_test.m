clear
close all
clc

% 原则上来讲，应该是用acc和mag补偿gyro的计算值
% 这个文档中计算方法是用的gyro和acc彼此权衡
% 理论上来讲，我觉得这个给得有些麻烦，可以直接通过小角度计算出dcm直接变换
% 可以把第一组数据认为就是在水平面上放置，这样不用通过矢量计算小角度euler

%% 从txt中读入数据并转换到 前-右-下 坐标系当中
% 这块在C程序中需要多加一个函数atan2 用法类似matlab库函数如下
% 四个象限都能算
% atan2(sqrt(3),1) * 180/(pi);   %  60
% atan2(sqrt(3),-1) * 180/(pi);  %  120
% atan2(-sqrt(3),1) * 180/(pi);  %  -60
% atan2(-sqrt(3),-1) * 180/(pi); %  -120

[raw_data]=importdata('r1.txt','%s'); 
data_to_read = length(raw_data);
data_length = floor((data_to_read-1)/4);%往小取整

acc = zeros(3, data_length);
gyro = acc;
mag = acc;
baro = zeros(1, data_length);


gyro_index = 1;
acc_index = 1;
for i = 2:1:data_to_read %跳过第一个时间
    str_temp = cell2mat(raw_data(i)); %每个元胞中的数据变成字符串数组
    % for j = 2:1:length(str_temp) %逐个读取其中的字符,第一个都是M故从第二个开始判断
    if(str_temp(2) == 'S')% MS5611
        continue;% 进入下一次循环，后续可以添加读取本数据
    elseif(str_temp(2) == 'P')% MPU6050
        if(str_temp(9) == 'A')% acc
            if(str_temp(23) == '-' && str_temp(31)== '-')
                acc(1,acc_index) = str2double(str_temp(23:27));
                acc(2,acc_index) = str2double(str_temp(31:35));
                acc(3,acc_index) =  str2double(str_temp(39:43));%多给一个空格
                acc_index = acc_index + 1;
            elseif(str_temp(23) == '-' && str_temp(31)~= '-') 
                acc(1,acc_index) = str2double(str_temp(23:27));
                acc(2,acc_index) = str2double(str_temp(31:34));
                acc(3,acc_index) = str2double(str_temp(38:42));
                acc_index = acc_index + 1;
            elseif(str_temp(23) ~= '-' && str_temp(30)== '-') 
                acc(1,acc_index) = str2double(str_temp(23:26));
                acc(2,acc_index) = str2double(str_temp(30:34));
                acc(3,acc_index) = str2double(str_temp(38:42));
                acc_index = acc_index + 1;
            elseif(str_temp(23) ~= '-' && str_temp(30)~= '-') 
                acc(1,acc_index) = str2double(str_temp(23:26));
                acc(2,acc_index) = str2double(str_temp(30:33));
                acc(3,acc_index) = str2double(str_temp(37:41));
                acc_index = acc_index + 1;
            end
            %disp(acc(:,acc_index-1));
        elseif(str_temp(9) == 'G')% gyro
%             if(str_temp(16) == '-' && str_temp(33)== '-')
%                 gyro(1,gyro_index) = str2double(str_temp(16:20));
%                 gyro(2,gyro_index) = str2double(str_temp(33:37));
%                 gyro(3,gyro_index) = str2double(str_temp(50:55));%多给一个空格
%                 gyro_index = gyro_index + 1;
%             elseif(str_temp(16) == '-' && str_temp(33)~= '-') 
%                 gyro(1,gyro_index) = str2double(str_temp(16:20));
%                 gyro(2,gyro_index) = str2double(str_temp(33:36));
%                 gyro(3,gyro_index) = str2double(str_temp(49:53));
%                 gyro_index = gyro_index + 1;
%             elseif(str_temp(16) ~= '-' && str_temp(32)== '-') 
%                 gyro(1,gyro_index) = str2double(str_temp(16:19));
%                 gyro(2,gyro_index) = str2double(str_temp(32:36));
%                 gyro(3,gyro_index) = str2double(str_temp(49:54));
%                 gyro_index = gyro_index + 1;
%             elseif(str_temp(16) ~= '-' && str_temp(32)~= '-') 
                gyro(1,gyro_index) = str2double(str_temp(23:28));
                gyro(2,gyro_index) = str2double(str_temp(30:37));
                gyro(3,gyro_index) = str2double(str_temp(38:47));%在程序中多加点空格
                gyro_index = gyro_index + 1;
            %end
            %disp(gyro(:,gyro_index-1));
        end
    else
        continue;    
    end
end

% 按照取向进行反转
temp = gyro(1,:);
gyro(1,:) = gyro(2,:);
gyro(2,:) = temp;
gyro(3,:) = gyro(3,:);

temp = -acc(1,:);
acc(1,:) = -acc(2,:);
acc(2,:) = temp;

%% 解算准备 数据首先需要进行转换 不考虑方向
pitch = zeros(1, data_length); % 存储当前的Euler角表示姿态,姿态初始值都是0
roll = pitch;                  
yaw = pitch;

pitch_delta = pitch;           % 存储相对前一时刻的变化的欧拉角
roll_delta = pitch;
yaw_delta = pitch;

att_gyro = zeros(3, data_length);
att_est = att_gyro;
att_acc = att_gyro;

w_gyro = 5;%陀螺仪相对于加计的置信度(权重系数比值)

deltaT = 10/36;%大概通过测量获得采样周期，采样10s获得36组样本
att_est(:,1) = [0;0;1];
t = 0:deltaT:(data_length-1)*deltaT;
dcm = repmat(eye(3),1,1,data_length);%将单位矩阵堆叠成三维 记录dcm用来动态显示

%% 本段代码写入控制器，执行周期20ms
for k = 2:1:data_length
    pitch_delta(k) = gyro(2,k)*deltaT;                                  %计算欧拉角变化值，得到角度为单位
    yaw_delta(k) = gyro(3,k)*deltaT;
    roll_delta(k) = gyro(1,k)*deltaT;
    rot_matrix = euler_to_rotmatrix(yaw_delta(k), roll_delta(k), pitch_delta(k));
    
    att_gyro(:,k) = rot_matrix * att_est(:,k-1);                        %前一时刻的估计值旋转到当前时刻
    att_acc(:,k) = normalize(acc(:,k));                                 %向量正交化，卡马克开方
    att_est(:,k) = (att_gyro(:,k)+w_gyro * att_acc(:,k))/(1+w_gyro);    %加权估算当前姿态
    
    rotmat_till_now = calculate_rot_matrix(att_est(:,1), att_est(:,k)); %始末向量->旋转轴角->罗德里格旋转矩阵
    [roll(k), pitch(k), yaw(k)] = rotmatrix_to_euler(rotmat_till_now);  %旋转矩阵代数运算计算欧拉角
    dcm(:,:,k) = rot_matrix;                                            %动态显示用
end



%% plot
figure(1)%角度
subplot(311)
plot(t,pitch,'-g');
legend('滚转角 ');
xlabel('Time (s)');
ylabel('pitch (deg)');
subplot(312);
plot(t,yaw,'-b');
legend('俯仰角 ');
xlabel('Time (s)');
ylabel('yaw (deg)');
subplot(313);
plot(t,roll,'-r');
legend('偏航角 ');
xlabel('Time (s)');
ylabel('roll (deg)');


figure(2)%角速度
subplot(311)
plot(t,gyro(2,:),'-g');
legend('滚转角速率 ');
xlabel('Time (s)');
ylabel('pitch (deg)');
subplot(312);
plot(t,gyro(3,:),'-b');
legend('俯仰角速率 ');
xlabel('Time (s)');
ylabel('yaw (deg)');
subplot(313);
plot(t,gyro(1,:),'-r');
legend('偏航角速率 ');
xlabel('Time (s)');
ylabel('roll (deg)');

%% 动态显示姿态状况
%animation;











