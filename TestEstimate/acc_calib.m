%% SY1705423 ���� ��һ����ҵ ���ٶȼ������б궨
clear 
close all
clc

%% ���� ǰ-��-�� ����ϵ������������������ʼ����ֵ 
a = repmat([9.8*eye(3); -9.8*eye(3)],[20,1]);

% a = repmat([9.8*eye(3); -9.8*eye(3)],[20,1])+(0.5*rand(120,3)-0.25);
% a(:,1) = 1.02*a(:,1)-0.06*ones(size(a,1),1);
% a(:,2) = 1.08*a(:,2)+0.05*ones(size(a,1),1);
% a(:,3) = 1.04*a(:,3)-0.08*ones(size(a,1),1);
% ����ֵ����Ӿ�ֵΪ0.05 ����Ϊ0.1 �ĸ�˹������

%% ֱ�ӽ�����������������С���˽�
H = zeros(size(a,1),6);%��ʼ��
for i = 1:1:size(a,1)
    H(i,:) = [a(i,1)^2, a(i,1), a(i,2)^2, a(i,2), a(i,3)^2, a(i,3)];
end

b = -ones(size(a,1),1);
p = (H'*H)\H'*b;
%% ��p�����ƫ����b���궨ֵk
A_temp = -4*diag([p(1)/p(2)^2, p(3)/p(4)^2, p(5)/p(6)^2]);
A = A_temp+ones(3);

g = 9.8;% ȡg=9.8m/s2
G = ones(3,1)*g^2;

B = A\G;% ����ƫ����B
den_temp = 0;
for i = 1:1:3
    den_temp = den_temp + B(i);
end
den_temp = den_temp - g^2;

K = zeros(3,1);
for i = 1:1:3
    K(i) = p(2*i-1)*den_temp;
end
%% ��������С���˼��� �趨��ֵ
x = ones(6,1);
ratio = 1;
i = 1;

sum = 0;
sum_pre = 1;%��ֹ��ĸΪ0
%% ����ֱ�����ȴﵽҪ��
while(ratio >= 0.0001)
   
   J = [2*a(:,1).^2*x(1)+2*a(:,1)*x(4), 2*a(:,2).^2*x(2)+2*a(:,2)*x(5), 2*a(:,3).^2*x(3)+2*a(:,3)*x(6), 2*a(:,1)*x(4), 2*a(:,2)*x(5), 2*a(:,3)*x(6)];
   deltaZ = -(a(:,1).^2*x(1)^2 + 2*a(:,1)*x(1)*x(4) + a(:,2).^2*x(2)^2 + 2*a(:,2)*x(2)*x(5) +  a(:,3).^2*x(3)^2 + 2*a(:,3)*x(3)*x(6)+...
       +(x(4)^2+x(5)^2+x(6)^2-g^2)*ones(size(a,1),1));
   deltaX = (J'*J)\J'*deltaZ;
   r = deltaZ - J*deltaX;
   x = x+deltaX;
   for j = 1:1:ones(size(a,1))
       sum = sum + r(j);
   end
   
   ratio = abs((sum_pre - sum)/sum_pre);
   sum_pre = sum;
end





















