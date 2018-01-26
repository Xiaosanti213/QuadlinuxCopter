clear
close all
clc


calibrated_att_init = [7;-2;1];
att_est = [3;2;5];
rotmat_till_now = calculate_rot_matrix(calibrated_att_init, att_est);
% rotmat_till_now = [0.21 -0.12 -0.97; 0.58 0.81 0.03; 0.78 -0.57 0.24];
[roll, pitch, yaw] = rotmatrix_to_euler(rotmat_till_now)


rodrigue_rotation_matrix([5 4 2],37);

normalize(calibrated_att_init)
normalize(att_est)
dp = dot_product(normalize(calibrated_att_init),normalize(att_est))
acos(dp)
