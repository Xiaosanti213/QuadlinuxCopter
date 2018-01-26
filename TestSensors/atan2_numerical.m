function a = atan2_numerical(y, x)

z = y/x;
if(abs(y) <abs(x))%45度线分隔
    a = 573*z/(1+0.28*z*z);%首先按照正常在一，四象限
    if(x<0)
        if(y<0) 
            a = a-1800;%三象限
        else
            a = a+1800;%二象限
        end
    end
else
    a = 900 -573.*z/(z.*z+0.28);%45度线外另一种估计方式
    if(y<0) 
        a = a-1800;%不能和if写成并排
    end
end
