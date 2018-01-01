%按照 前-右-下 苏联坐标系的定义 x-y-z 
%旋转顺序：z_psi(yaw)->x_phi(roll)->y_theta(pitch)
%含义就是，牵连垂直坐标系下某一矢量，通过三个旋转角，计算出在机体坐标系下的投影
function rot_matrix = euler_to_rotmatrix(yaw, roll, pitch)

%变成角度制
theta = pitch*pi/180;
phi = roll*pi/180;
psi = yaw*pi/180;


rot_matrix = ...
[             cos(theta)*cos(psi)             ,            cos(theta)*sin(psi)                ,       -sin(theta);
sin(phi)*sin(theta)*cos(psi)-cos(phi)*sin(psi), sin(phi)*sin(theta)*sin(psi)-cos(phi)*cos(psi), sin(phi)*cos(theta)
cos(phi)*sin(theta)*cos(psi)-sin(phi)*sin(psi), cos(phi)*sin(theta)*sin(psi)-sin(phi)*cos(psi), cos(phi)*cos(theta)]; 


