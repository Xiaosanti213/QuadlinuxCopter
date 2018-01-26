% rotate matrix to Euler angles
function [roll, pitch, yaw] = rotmatrix_to_euler(R)

%根据euler_to_totmatrix公式推导 atan2(sin, cos)
theta = atan2(-R(1,3), sqrt(R(1,1)^2+R(1,2)^2));
psi = atan2(R(1,2), R(1,1));
phi = atan2(R(2,3), R(3,3));


roll = phi*180/pi;
pitch = theta*180/pi;
yaw = psi*180/pi;