clear
close all
clc


%% stage 1a: ��txt�ж������ݲ�ת���� ǰ-��-�� ����ϵ����
data_length = 100; % ��Ҫ����ʵ�����ȷ��,���������洢����
acc = zeros(3, data_length);
acc_amp = acc;%������¼ģ�� 
gyro = acc;
mag = acc;
baro = zeros(1, data_length);
%������������ǰ��Euler�Ǳ�ʾ��̬,��̬��ʼֵ����0
pitch = acc;
roll = acc;
yaw = acc;

%% 
delta

%�����Ҫ���һ������atan2 �÷�����matlab�⺯������
%�ĸ����޶�����
% atan2(sqrt(3),1) * 180/(pi);   %  60
% atan2(sqrt(3),-1) * 180/(pi);  %  120
% atan2(-sqrt(3),1) * 180/(pi);  %  -60
% atan2(-sqrt(3),-1) * 180/(pi); %  -120



%% sim׼��
deltaT = 0.1;
%��ǰ���������ݿ��ܲ���0���⽫������̬����0
acc_amp(1) = sqrt(acc(1,1)^2, acc(2,1)^2, acc(3,1)^2);%�����������Ƿ�ÿ�ζ���Ҫ����,�����Ҫ����
acc(1,1) = acc(1,1)/acc_amp(1);
acc(2,1) = acc(2,1)/acc_amp(1);
acc(3,1) = acc(3,1)/acc_amp(1);
gravity = [0;0;1];
% ���������ʵ���Ͼ�����֪��������ϵ�е�ʸ��������任����
% ʹ���޵������ת��ʽ����
rot_matrix = calculate_rot_matrix(gravity, acc(:,1));



%%
for k = 2:deltaT:data_length
    pitch(k) = 
end


