% ͨ����ת�����ת��ʹ���޵������ת��ʽ������ת����
function rot_matrix = rodrigue_rotation_matrix(rot_axis, rot_angle)

rot_axis = normalize(rot_axis);%��������ת��
rot_matrix = zeros(3,3);

%��װ
w1 = rot_axis(1);
w2 = rot_axis(2);
w3 = rot_axis(3);
cos_theta = cos(rot_angle);
sin_theta = sin(rot_angle);

%���ݹ�ʽ������ת�������Ԫ��
rot_matrix(1, 1) = w1^2*(1-cos_theta)+cos_theta;
rot_matrix(1, 2) = w1*w2*(1-cos_theta)-w3*sin_theta;
rot_matrix(1, 3) = w1*w3*(1-cos_theta)+w2*sin_theta;

rot_matrix(2, 1) = w1*w2*(1-cos_theta)+w3*sin_theta;
rot_matrix(2, 2) = w2^2*(1-cos_theta)+cos_theta;
rot_matrix(2, 3) = w2*w3*(1-cos_theta)-w1*sin_theta;

rot_matrix(3, 1) = w1*w3*(1-cos_theta)-w2*sin_theta;
rot_matrix(3, 2) = w2*w3*(1-cos_theta)+w1*sin_theta;
rot_matrix(3, 3) = w3^2*(1-cos_theta)+cos_theta;








