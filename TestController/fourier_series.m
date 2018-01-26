%Fourier�����汾�����Խ�һ��д������ɢ���汾
%��������һ����Χ���ü����ƽ�
function [A,B,F] = fourier_series(f,x,p,a,b)
% ���� �Ա��� ǰ������ �������Ҷ˵�
if nargin == 3 %�������������
    a = -pi; 
    b = pi; 
end
L=(b-a)/2; 
if (a+b~=0)
    f=subs(f,x,x+L+a); %��ԭ��Գƺ���ӳ�䵽ԭ��Գƺ���
end
A = int(f,x,-L,L)/L;  %����a0
B = [];               %��ʼ�� 
F=A/2;
for n= 1:p
    an= int(f*cos(n*pi*x/L),x,-L,L)/L;%���ֺ���
    bn = int(f*sin(n*pi*x/L),x,-L,L)/L; 
    A=[A, an]; 
    B=[B, bn];
    F=F+an*cos(n*pi*x/L)+bn*sin(n*pi*x/L);
end
if (a+b~=0)
   F=subs(F,x,x-L-a); %��ԭ��Գƺ���ӳ���ȥ
end
    
    
    
    
    