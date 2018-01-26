function tf_transfunc = transfunc_sym2tf(sym_transfunc, type)
%������sym����ת����tf����,type=1:����ϵͳ��type=0:��ɢϵͳ

[n, d] = numden(sym_transfunc);  %��ȡ�������ӷ�ĸ����ʽ
num = tf(double(coeffs(n,'All')));     %�õ�ϵ���ӵʹ���ߴ���,���ַ�����̫�걸
den = tf(double(coeffs(d,'All')));     
nd = length(den);               %���ڳ��洫����˵�Ƿ��ӷ�ĸ������ͬ       
nn = length(num);

s = tf('s'); 
z = tf('z');
num_poly = 0*s;                   %��ʼ��
den_poly = 0*s;
if(type)%type=1����ϵͳ
    for i=1:nn    
       num_poly = num_poly*s+num(i);
    end
    for j=1:nd
       den_poly = den_poly*s+den(j);
    end
    tf_transfunc = num_poly/den_poly;
else   %type=0��ɢϵͳ
    for i=1:nn    
       num_poly = num_poly*z+num(i);
    end
    for j=1:nd
       den_poly = den_poly*z+den(j);
    end
    tf_transfunc = num_poly/den_poly;
end



