function a = atan2_numerical(y, x)

z = y/x;
if(abs(y) <abs(x))%45���߷ָ�
    a = 573*z/(1+0.28*z*z);%���Ȱ���������һ��������
    if(x<0)
        if(y<0) 
            a = a-1800;%������
        else
            a = a+1800;%������
        end
    end
else
    a = 900 -573.*z/(z.*z+0.28);%45��������һ�ֹ��Ʒ�ʽ
    if(y<0) 
        a = a-1800;%���ܺ�ifд�ɲ���
    end
end
