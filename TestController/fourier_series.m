%Fourier解析版本，可以进一步写出其离散化版本
%本质是在一定范围内用级数逼近
function [A,B,F] = fourier_series(f,x,p,a,b)
% 函数 自变量 前多少项 区间左右端点
if nargin == 3 %三个输入参数，
    a = -pi; 
    b = pi; 
end
L=(b-a)/2; 
if (a+b~=0)
    f=subs(f,x,x+L+a); %非原点对称函数映射到原点对称函数
end
A = int(f,x,-L,L)/L;  %计算a0
B = [];               %初始化 
F=A/2;
for n= 1:p
    an= int(f*cos(n*pi*x/L),x,-L,L)/L;%积分函数
    bn = int(f*sin(n*pi*x/L),x,-L,L)/L; 
    A=[A, an]; 
    B=[B, bn];
    F=F+an*cos(n*pi*x/L)+bn*sin(n*pi*x/L);
end
if (a+b~=0)
   F=subs(F,x,x-L-a); %非原点对称函数映射回去
end
    
    
    
    
    