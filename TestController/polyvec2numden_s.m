%ͨ������ʽ����ϵ����ʽ���㺬����s�Ķ���ʽ
function transfunc = polyvec2numden_s(num, den, signal)
% num��den��������

if(signal)%�������������Ӧ
    for k = 1:signal
        den = [den, 0];%��ĸ����ʽ������Ӷ�Ӧ0�ĸ���
    end
end


syms s

s_vec_num = 1;
s_vec_den = 1;

%����[1 s^1 s^2 ...]������
if(length(num) ~= 1)
    for i = 1:length(num)-1
        s_vec_num = [s_vec_num; s^i];
    end
end
num_s = num*s_vec_num(end:-1:1);%���ڻ�

if(length(den) ~= 1)
    for j = 1:length(den)-1
        s_vec_den = [s_vec_den; s^j];
    end
end
den_s = den*s_vec_den(end:-1:1);

transfunc = num_s/den_s;



