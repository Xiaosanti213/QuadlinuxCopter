clear
close all
clc

%% 库函数构建传函并绘制特征
% Ka = 10;
% nf = [5000];
% df = [1 1000];
% ng = [1];
% dg = [1 20 0];

% [num, den] = series(Ka*nf,df,ng,dg);%串联
tf('s');
[n,d] = cloop(num, den);            %闭环

t = [0:0.01:2];
y = step(n,d,t);                    %计算阶跃输入响应


%%  直接计算
syms s
sym_transfunc = transfunc_tf2sym(tf(n,d),1);
time_domain_transfunc = ilaplace(sym_transfunc/s);%单位阶跃输入传函
y1 = subs(time_domain_transfunc);

%% 验证重合
plot(t,y,'bo'),grid
hold on
plot(t,y,'r--')




