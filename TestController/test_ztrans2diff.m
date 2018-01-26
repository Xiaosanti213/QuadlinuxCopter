%测试PID控制转化为差分方程
clear 
close all
%clc


%% s域PI控制器
s = tf('s');
g = 0.3/(s+1);                                                               %连续系统传函
g = g*(2+20/.3/s);                                                           %加入P=8 tauI=0.3
g = feedback(g,1);                                                           %闭环了
T = 0.02;
syms s z                                                                     %这个是计算阶跃输入信号用
%error = get_stady_state_error(transfunc_tf2sym(g,1)/s);
g1 = c2d(g,T,'foh')                                                          %得到离散系统传函之后，递推关系即由移位定理确定
g1 = simplify(subs(transfunc_tf2sym(g,1),s,2*(1-z^(-1))/(1+z^(-1))/T));    %双线性变换，拟合结果还是比较不错的
g1 = transfunc_sym2tf(g1,0)


%% 提取离散传函多项式分子分母
% 由于迭代过程用到Reference，因此并不需要在传函中加入1/s
[num, den] = tfdata(g1);                    %传函为tf类型提取多项式系数



%% 递推关系初始化离散系统迭代
finish_time = 10;                           %结束时间10s     
len_rec = length(den{1});                   %迭代需要用到的项数
reference = ones(1,finish_time/T);                      
out_pre = zeros(1,len_rec-1);               %构成行向量，每次需要的前面几次的输出系数参与迭代
ref_pre = reference(1:len_rec);             %每次需要的前面几次的参考系数参与迭代
out_eff = den{1}(2:1:end)/den{1}(1);        %行向量，迭代输出向量系数，化成首1
ref_eff = num{1}(1:end)/den{1}(1);          %行向量，迭代参考向量系数，化成首1
y_d = zeros(1,len_rec);                     %离散系统输出



%% 迭代
for i = len_rec:finish_time/T
    out_new = ref_eff*ref_pre'-out_eff*out_pre';            %用之前的参考向量和输出向量迭代当前的输出值
    out_pre = [out_new out_pre(1:end-1)];                   %更新输出系数向量
    if(i~=len_rec:finish_time/T)                            %防止溢出
        ref_pre = [reference(len_rec+1) ref_pre(1:end-1)];  %更新参考系数向量
    end
    y_d(i) = out_new;
end



%% 传函转化到时域
%计算响应需要带1/s反变换
time_domain_transfunc = ilaplace(transfunc_tf2sym(g,1)/s);  %使用连续系统，需加入阶跃信号
t = 0:T:finish_time-T;
y = subs(time_domain_transfunc);                            %连续系统时域输出



%% 画图
figure 
plot(t,reference,'--r')
xlabel('Time: (s)')
ylabel('Signal')
ylim([0,1.2])
hold on

plot(t,y,'b')
plot(t,y_d,'go')
legend('Reference','Continuous','Discrete')

%ginput(2)%不错的工具！




