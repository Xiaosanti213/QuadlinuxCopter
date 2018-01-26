function close_transfunc = add_p2transfunc(transfunc, Kp, tauD, tauI)

syms s
s = tf('s');
% P
transfunc = transfunc*Kp;%结构图上看，相当于直接在开环传函上添加了比例项

% D
transfunc = transfunc*(1+tauD*s);%开环传函上添加微分项

% I
transfunc = transfunc*(1+1/tauI/s);%开环传函上添加积分项


close_transfunc = feedback(transfunc,1);%库函数tf类型使用

%close_transfunc = get_close_loop_transfunc(transfunc, 1);%闭环

%close_transfunc = close_transfunc/s;%单位阶跃信号

