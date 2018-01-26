% ϵͳ�߽ף���ѡ���Ƹ��켣
% ȷ����Ҫ���㣬��ȥż����
% ����ϵͳͨ��ksi wn tsȷ�����棬��֤����
clear 
close all
clc


% %% �Զ�����ԭ�� ������ P124���� �ǵ�λ���� 
% syms K s
% n = K*[1 1];
% d = [1 2 0];
% transfunc = polyvec2numden_s(n,d,0);
% g = get_close_loop_transfunc(transfunc,1/(s+3));%P125�Ϸ���֤��ȷ


%% ϵͳ����
% num = [1];
% den = conv([1 1],[0.01 0.08 1]);
% G = tf(num, den);                      %ʹ��rlocus�����Ǳջ���������֤��������ȷ������
% ����������д�ɱ�׼��1+K*P(s)/Q(s)������PQΪ�㼫�����ʽ

%ϵͳ�ջ���������������ĳϵ��������ȷ����׼�ͣ���ĸ����ʽд��1+K*P(s)/Q(s)
G_open = zpk([-1],[0,-2,-3],1);         % ���ݹ�����켣���ۣ�ϵͳ���������͸��켣һһ��Ӧ
G = feedback(G_open,-1);               % �����ڷ���H~=1���ܵ��¶���ջ�������Ӧһ��������������λ��������-1

% R = rlocus(G);                      % ���÷�ʽA: ������ʽ����R��λ�ã�����û����ͼ������ʾ
rlocus(G);                            % ���÷�ʽB: ���켣ֻ��ͼ���ϻ������ͼ�ϵ�����Կ�������ص�
% [R,K] = rlocus(G);                  % ���÷�ʽC: ������������켣����K*��Ҫ�����������



% point = ginput(2);                    % �ֶ�ȷ���ٽ��λ�õ�
[K,P] = rlocfind(G);                  % ��λ����λ�ã�ȷ��K*���˴����ص�K�������������ʽ��׼�͵�����
%% ������Ƶ�ϵͳ��Ծ��Ӧ
time_finish = 10;
T = 0.02;
t = 0:T:time_finish-T;
K = 16.2879;
num = K*pole2polyvec([-1,-3]);
den_temp = pole2polyvec([0 -2 -3]);
den_temp1 = pole2polyvec([-1]);
den = [0 0 K*den_temp1]+den_temp;%���������� ����Ԫ�ظ��������
G = tf(num,den);
y = step(G,t);

%% ��ͼ
figure(1)
plot(t,ones(1,length(t)),'--r')
hold on
plot(t,y,'b')
xlabel('Time: s')
ylabel('Signal')
legend('Reference', 'Step Response of Designed System');


[num,den] = tfdata(G);                % ���¸�ֵһ�������tfͨ��zpk���ɱȽϷ���
% p = pole(G);                          % �ջ�����
% z = zero(G);
p = roots(den{1,1});                     % �ջ�����
z = roots(num{1,1});                     % �ջ����
figure(2)
plot(real(p),imag(p),'r*')
hold on
plot(real(z),imag(z),'ro')
xlabel('Real')
ylabel('Image')
title('Polars and Zeros locations of Close-loop Transfer Function');
grid on
%% �Ƚϱջ��������λ�ù�ϵ






%% ����
%������ʵ���ϣ��������
%ż���Ӷ��� ģ���Ⱦ����һ��������
%ʵ����СΪ���� ����5��ʵ������ֵ Ӱ��ɺ���

%���ݶ���ϵͳ����ʽ�ص� �ɻ�����
%�� �������
%�� ����Ƶ����
%�� ts����ʱ����










