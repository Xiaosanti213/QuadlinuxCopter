%Ƶ�������ܷ�������
clear 
close all
clc



%% �Կ�ԭ��P170 Nyquistͼ����������ͼ��
num = [1];
den = [0.5 1];
[re, im] = nyquist(num,den);

figure(1)
plot(re,im)
grid on

%% P169 Bodeͼ
w = logspace(-1,1,200);%��Ȼ����Ϊ��
% num = [1 3];
% den = pole2polyvec([0,-1,-2]);

G = tf(num, den);
[x,y,w] = bode(G, w);
figure(2)
margin(x,y,w);

%[Gm Pm weg wcp] = margin(num, den);








