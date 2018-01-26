%cascade PID control
clear
close all
clc


%% 控制器设计
transfunc_inner = tf(5,[1 10]);
transfunc_outer = tf(0.005,[1 0.05]);


damping_coeff = 0.707; %内外环阻尼比0.707




