%���� ǰ-��-�� ��������ϵ�Ķ��� x-y-z 
%��ת˳��z_psi(yaw)->x_phi(roll)->y_theta(pitch)
%������ǣ�ǣ����ֱ����ϵ��ĳһʸ����ͨ��������ת�ǣ�������ڻ�������ϵ�µ�ͶӰ
function rot_matrix = euler_to_rotmatrix(yaw, roll, pitch)

%��ɽǶ���
theta = pitch*pi/180;
phi = roll*pi/180;
psi = yaw*pi/180;


rot_matrix = ...
[             cos(theta)*cos(psi)             ,            cos(theta)*sin(psi)                ,       -sin(theta);
sin(phi)*sin(theta)*cos(psi)-cos(phi)*sin(psi), sin(phi)*sin(theta)*sin(psi)-cos(phi)*cos(psi), sin(phi)*cos(theta)
cos(phi)*sin(theta)*cos(psi)-sin(phi)*sin(psi), cos(phi)*sin(theta)*sin(psi)-sin(phi)*cos(psi), cos(phi)*cos(theta)]; 


