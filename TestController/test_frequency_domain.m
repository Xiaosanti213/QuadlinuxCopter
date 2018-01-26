%频域内性能分析测试
clear 
close all
clc



%% 自控原理P170 Nyquist图（幅相特性图）
num = [1];
den = [0.5 1];
[re, im] = nyquist(num,den);

figure(1)
plot(re,im)
grid on

%% P169 Bode图
w = logspace(-1,1,200);%自然对数为底
% num = [1 3];
% den = pole2polyvec([0,-1,-2]);

G = tf(num, den);
[x,y,w] = bode(G, w);
figure(2)
margin(x,y,w);

%[Gm Pm weg wcp] = margin(num, den);








