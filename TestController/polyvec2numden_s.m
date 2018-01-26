%通过多项式向量系数形式计算含变量s的多项式
function transfunc = polyvec2numden_s(num, den, signal)
% num和den是行向量

if(signal)%如果不是脉冲响应
    for k = 1:signal
        den = [den, 0];%分母多项式后面添加对应0的个数
    end
end


syms s

s_vec_num = 1;
s_vec_den = 1;

%计算[1 s^1 s^2 ...]列向量
if(length(num) ~= 1)
    for i = 1:length(num)-1
        s_vec_num = [s_vec_num; s^i];
    end
end
num_s = num*s_vec_num(end:-1:1);%做内积

if(length(den) ~= 1)
    for j = 1:length(den)-1
        s_vec_den = [s_vec_den; s^j];
    end
end
den_s = den*s_vec_den(end:-1:1);

transfunc = num_s/den_s;



