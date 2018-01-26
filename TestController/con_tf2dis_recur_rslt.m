function y_d = con_tf2dis_recur_rslt(transfunc,k,T)
%transfunc:闭环无输入传函 k采样点个数

g1 = c2d(transfunc,T,'zoh');                                               %得到离散系统传函之后，递推关系即确定
 

%% 下面利用递推关系初始化离散系统迭代
% 由于迭代过程用到Reference，因此并不需要在传函中加入1/s
[num, den] = tfdata(g1);
len_rec = length(den{1});                   %迭代需要用到的项数
reference = ones(1,k);                      
out_pre = zeros(1,len_rec-1);               %构成行向量，每次需要的前面几次的输出系数参与迭代
ref_pre = reference(1:len_rec);             %每次需要的前面几次的参考系数参与迭代
out_eff = den{1}(2:1:end);                  %行向量，迭代输出向量系数
ref_eff = num{1}(1:end);                    %行向量，迭代参考向量系数
y_d = zeros(1,len_rec);                     %离散系统输出


%% 迭代
for i = len_rec:k
    out_new = ref_eff*ref_pre'-out_eff*out_pre';            %用之前的参考向量和输出向量迭代当前的输出值
    out_pre = [out_new out_pre(1:end-1)];                   %更新输出系数向量
    if(i~=k)                                                %防止溢出
        ref_pre = [reference(len_rec+1) ref_pre(1:end-1)];  %更新参考系数向量
    end
    y_d(i) = out_new;
end

%% 画图
% figure 
% plot(t,y,'b')
% xlabel('Time: (s)')
% ylabel('Signal')
% ylim([0,1.2])
% hold on
% 
% plot(t,reference,'--r')
% plot(t,y_d,'go')
% legend('Continuous','Reference','Discrete')



