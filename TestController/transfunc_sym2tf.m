function tf_transfunc = transfunc_sym2tf(sym_transfunc, type)
%传函从sym类型转换到tf类型,type=1:连续系统，type=0:离散系统

[n, d] = numden(sym_transfunc);  %提取传函分子分母多项式
num = tf(double(coeffs(n,'All')));     %得到系数从低次项到高次项,这种方法不太完备
den = tf(double(coeffs(d,'All')));     
nd = length(den);               %对于常规传函来说是分子分母长度相同       
nn = length(num);

s = tf('s'); 
z = tf('z');
num_poly = 0*s;                   %初始化
den_poly = 0*s;
if(type)%type=1连续系统
    for i=1:nn    
       num_poly = num_poly*s+num(i);
    end
    for j=1:nd
       den_poly = den_poly*s+den(j);
    end
    tf_transfunc = num_poly/den_poly;
else   %type=0离散系统
    for i=1:nn    
       num_poly = num_poly*z+num(i);
    end
    for j=1:nd
       den_poly = den_poly*z+den(j);
    end
    tf_transfunc = num_poly/den_poly;
end



