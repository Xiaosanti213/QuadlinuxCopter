%cascade PID control
clear
close all
clc


%% ���������
transfunc_inner = tf(5,[1 10]);
transfunc_outer = tf(0.005,[1 0.05]);


damping_coeff = 0.707; %���⻷�����0.707




