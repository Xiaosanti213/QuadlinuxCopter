%����PX4 modules/attitude_estimator_q/init()�����е�������ϵ��ʸ���ڻ�������ϵͶӰ���
clear 
close all
clc

%%
%	Vector<3> k = -_accel;
%	k.normalize();
%	// i�ǵ���x�ᣨָ�򱱣��ĵ�λʸ��������ϵ�е�ͶӰ����k����
%	// �����и�У����Ŀ����ȥ����һ��
%	Vector<3> i = (_mag - k * (_mag * k));
%	i.normalize();
%
%	// i�ǵ���x�ᣨָ�򱱣��ĵ�λʸ��������ϵ�е�ͶӰ����k��i������
%	Vector<3> j = k % i;
% accel = [1.2, -2.3, 3.8];%�������
% k = -_accel;


%% �������һ����̬
roll = 0*ones(1,2);
pitch = -30*ones(1,2);
yaw = 0*ones(1,2);
dcm = zeros(3,3,2);
for i=1:2
    dcm(:,:,i) = euler_to_rotmatrix(yaw(i),roll(i),pitch(i));
end
animation


%% �������ϵ��NEDϵͶӰ
body = dcm(:,:,2)*[0;0;1]




















