clear
close all
clc

%原则上来讲，应该是用acc和mag补偿gyro的计算值
%这个文档中计算方法是用的gyro和acc彼此权衡
%理论上来讲，我觉得这个给得有些麻烦，可以直接通过小角度计算出dcm直接变换
%可以把第一组数据认为就是在水平面上放置，这样不用通过矢量计算小角度euler

%% 从txt中读入数据并转换到 前-右-下 坐标系当中
%这块在C程序中需要多加一个函数atan2 用法类似matlab库函数如下
%四个象限都能算
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

%下面用来将当前的Euler角表示姿态,姿态初始值都是0
pitch = zeros(1, data_length);
roll = pitch;
yaw = pitch;
att_gyro = acc;
att_est = acc;
att_acc = acc;

w_gyro = 5;%陀螺仪相对于加计的置信度(权重系数比值)
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

%% sim准备 数据首先需要进行转换 不考虑方向
temp = gyro(1,:);
gyro(1,:) = gyro(2,:);
gyro(2,:) = temp;
gyro(3,:) = gyro(3,:);

temp = -acc(1,:);
acc(1,:) = -acc(2,:);
acc(2,:) = temp;

deltaT = 10/36;%大概通过测量获得采样周期，采样10s获得36组样本
att_est(:,1) = [0;0;1];
t = 0:deltaT:(data_length-1)*deltaT;
dcm = repmat(eye(3),1,1,data_length);%将单位矩阵堆叠成三维

%% simulate
for k = 2:1:data_length
    %下面用gyro(:,k)计算euler
    pitch(k) = gyro(2,k)*deltaT;
    yaw(k) = gyro(3,k)*deltaT;
    roll(k) = gyro(1,k)*deltaT;
    %得到角度为单位
    rot_matrix = euler_to_rotmatrix(yaw(k), roll(k), pitch(k));
    att_gyro(:,k) = rot_matrix * att_est(:,k-1);%前一时刻的估计值旋转到当前时刻
    att_est(:,k-1);
    rot_matrix;
    att_acc(:,k) = normalize(acc(:,k));
    att_est(:,k) = (att_gyro(:,k)+w_gyro * att_acc(:,k))/(1+w_gyro);
    dcm(:,:,k) = rot_matrix;%for ploting
end



%% plot
subplot(3,1,1)
plot(t,pitch,'-g');
legend('俯仰角 ');
xlabel('Time (s)');
ylabel('pitch (deg)');

subplot(3,1,2);
plot(t,yaw,'-b');
legend('偏航角 ');
xlabel('Time (s)');
ylabel('yaw (deg)');

subplot(3,1,3);
plot(t,roll,'-r');
legend('滚转角 ');
xlabel('Time (s)');
ylabel('roll (deg)');



%% 动态显示
animation;











