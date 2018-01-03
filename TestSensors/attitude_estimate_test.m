clear
close all
clc

%ԭ����������Ӧ������acc��mag����gyro�ļ���ֵ
%����ĵ��м��㷽�����õ�gyro��acc�˴�Ȩ��
%�������������Ҿ������������Щ�鷳������ֱ��ͨ��С�Ƕȼ����dcmֱ�ӱ任
%���԰ѵ�һ��������Ϊ������ˮƽ���Ϸ��ã���������ͨ��ʸ������С�Ƕ�euler

%% ��txt�ж������ݲ�ת���� ǰ-��-�� ����ϵ����
%�����C��������Ҫ���һ������atan2 �÷�����matlab�⺯������
%�ĸ����޶�����
% atan2(sqrt(3),1) * 180/(pi);   %  60
% atan2(sqrt(3),-1) * 180/(pi);  %  120
% atan2(-sqrt(3),1) * 180/(pi);  %  -60
% atan2(-sqrt(3),-1) * 180/(pi); %  -120

[raw_data]=importdata('r1.txt','%s'); 
data_to_read = length(raw_data);
data_length = floor((data_to_read-1)/4);%��Сȡ��

acc = zeros(3, data_length);
gyro = acc;
mag = acc;
baro = zeros(1, data_length);

%������������ǰ��Euler�Ǳ�ʾ��̬,��̬��ʼֵ����0
pitch = zeros(1, data_length);
roll = pitch;
yaw = pitch;
att_gyro = acc;
att_est = acc;
att_acc = acc;

w_gyro = 5;%����������ڼӼƵ����Ŷ�(Ȩ��ϵ����ֵ)
gyro_index = 1;
acc_index = 1;
for i = 2:1:data_to_read %������һ��ʱ��
    str_temp = cell2mat(raw_data(i)); %ÿ��Ԫ���е����ݱ���ַ�������
    % for j = 2:1:length(str_temp) %�����ȡ���е��ַ�,��һ������M�ʴӵڶ�����ʼ�ж�
    if(str_temp(2) == 'S')% MS5611
        continue;% ������һ��ѭ��������������Ӷ�ȡ������
    elseif(str_temp(2) == 'P')% MPU6050
        if(str_temp(9) == 'A')% acc
            if(str_temp(23) == '-' && str_temp(31)== '-')
                acc(1,acc_index) = str2double(str_temp(23:27));
                acc(2,acc_index) = str2double(str_temp(31:35));
                acc(3,acc_index) =  str2double(str_temp(39:43));%���һ���ո�
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
%                 gyro(3,gyro_index) = str2double(str_temp(50:55));%���һ���ո�
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
                gyro(3,gyro_index) = str2double(str_temp(38:47));%�ڳ����ж�ӵ�ո�
                gyro_index = gyro_index + 1;
            %end
            %disp(gyro(:,gyro_index-1));
        end
    else
        continue;    
    end
end

%% sim׼�� ����������Ҫ����ת�� �����Ƿ���
temp = gyro(1,:);
gyro(1,:) = gyro(2,:);
gyro(2,:) = temp;
gyro(3,:) = gyro(3,:);

temp = -acc(1,:);
acc(1,:) = -acc(2,:);
acc(2,:) = temp;

deltaT = 10/36;%���ͨ��������ò������ڣ�����10s���36������
att_est(:,1) = [0;0;1];
t = 0:deltaT:(data_length-1)*deltaT;
dcm = repmat(eye(3),1,1,data_length);%����λ����ѵ�����ά

%% simulate
for k = 2:1:data_length
    %������gyro(:,k)����euler
    pitch(k) = gyro(2,k)*deltaT;
    yaw(k) = gyro(3,k)*deltaT;
    roll(k) = gyro(1,k)*deltaT;
    %�õ��Ƕ�Ϊ��λ
    rot_matrix = euler_to_rotmatrix(yaw(k), roll(k), pitch(k));
    att_gyro(:,k) = rot_matrix * att_est(:,k-1);%ǰһʱ�̵Ĺ���ֵ��ת����ǰʱ��
    att_est(:,k-1);
    rot_matrix;
    att_acc(:,k) = normalize(acc(:,k));
    att_est(:,k) = (att_gyro(:,k)+w_gyro * att_acc(:,k))/(1+w_gyro);
    dcm(:,:,k) = rot_matrix;%for ploting
end



%% plot
subplot(3,1,1)
plot(t,pitch,'-g');
legend('������ ');
xlabel('Time (s)');
ylabel('pitch (deg)');

subplot(3,1,2);
plot(t,yaw,'-b');
legend('ƫ���� ');
xlabel('Time (s)');
ylabel('yaw (deg)');

subplot(3,1,3);
plot(t,roll,'-r');
legend('��ת�� ');
xlabel('Time (s)');
ylabel('roll (deg)');



%% ��̬��ʾ
animation;











