clear
close all
clc

%% �⺯��������������������
% Ka = 10;
% nf = [5000];
% df = [1 1000];
% ng = [1];
% dg = [1 20 0];

% [num, den] = series(Ka*nf,df,ng,dg);%����
tf('s');
[n,d] = cloop(num, den);            %�ջ�

t = [0:0.01:2];
y = step(n,d,t);                    %�����Ծ������Ӧ


%%  ֱ�Ӽ���
syms s
sym_transfunc = transfunc_tf2sym(tf(n,d),1);
time_domain_transfunc = ilaplace(sym_transfunc/s);%��λ��Ծ���봫��
y1 = subs(time_domain_transfunc);

%% ��֤�غ�
plot(t,y,'bo'),grid
hold on
plot(t,y,'r--')




