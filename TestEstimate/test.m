clear 
close all
clc

a = 9.8*eye(3)+[0.1;0.1;0.1]*ones(1,3);
g = 9.8;

%% 非线性最小二乘计算 设定初值
x = [ones(3,1);-0.1;-0.1;-0.1];
ratio = 1;
i = 1;

sum = 0;
sum_pre = 1;%防止分母为0
%% 迭代直到精度达到要求
while(ratio >= 0.0001)
   
   J = [2*a(:,1).^2*x(1)+2*a(:,1)*x(4), 2*a(:,2).^2*x(2)+2*a(:,2)*x(5), 2*a(:,3).^2*x(3)+2*a(:,3)*x(6), 2*a(:,1)*x(4), 2*a(:,2)*x(5), 2*a(:,3)*x(6)]
   deltaZ = -(a(:,1).^2*x(1)^2 + 2*a(:,1)*x(1)*x(4) + a(:,2).^2*x(2)^2 + 2*a(:,2)*x(2)*x(5) +  a(:,3).^2*x(3)^2 + 2*a(:,3)*x(3)*x(6)+...
       +(x(4)^2+x(5)^2+x(6)^2-g^2)*ones(size(a,1),1))
   deltaX = (J'*J)\J'*deltaZ
   r = deltaZ - J*deltaX;
   x = x+deltaX
   for j = 1:1:ones(size(a,1))
       sum = sum + r(j);
   end
   
   ratio = abs((sum_pre - sum)/sum_pre)
   sum_pre = sum
end



