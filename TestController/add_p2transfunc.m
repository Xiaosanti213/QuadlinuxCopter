function close_transfunc = add_p2transfunc(transfunc, Kp, tauD, tauI)

syms s
s = tf('s');
% P
transfunc = transfunc*Kp;%�ṹͼ�Ͽ����൱��ֱ���ڿ�������������˱�����

% D
transfunc = transfunc*(1+tauD*s);%�������������΢����

% I
transfunc = transfunc*(1+1/tauI/s);%������������ӻ�����


close_transfunc = feedback(transfunc,1);%�⺯��tf����ʹ��

%close_transfunc = get_close_loop_transfunc(transfunc, 1);%�ջ�

%close_transfunc = close_transfunc/s;%��λ��Ծ�ź�

