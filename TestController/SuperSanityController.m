clear
close all
clc

%% �ڻ���� �ڻ���һ����P �������� ������10���⻷
% ���з����Ļ��ֻ����ǹ��Ի��ڣ�����������ڱջ�������
% K = -root(root<0)
K = 40;
syms s
close_transfunc_inner = get_close_loop_transfunc(K/s,1);

%% �ڻ���Ч���������㷨���㼫��ֲ�
%close_trans_tf_inner = transfunc_sym2tf(close_transfunc_inner,1);
%rlocus(close_trans_tf_inner);                       %���Ƹ��켣�����Ч
%���������ܿ죬��ֱ�ӵ�ЧΪ1


%% �⻷��� PI������
a = 1;b = 0;%1/s
ksi = 0.707; wn = 10;%Ŀ�����ϵͳ
type = 2; %ʹ��IP������������У����
[Kp,tauI,close_transfunc_outer] = fir_odr_sec_odr_get_PIDs(a,b,ksi,wn,type);


%% �ڻ��⻷����λ����֤
get_second_order_performance_index(ksi,wn);

[~,den] = numden(close_transfunc_outer);
coe = coeffs(den);
p_o = double(roots(coe(end:-1:1)));
figure
plot(real(p_o),imag(p_o),'r*');
hold on
plot(-K,0,'b*');
legend('�⻷����','�ڻ�����');


%% ʱ��
time_finish = 1.5;                                                  %����ʱ��1.5s
T = 0.02;                                                           %���沽��20ms
Reference_o = ones(1,time_finish/T);                                %��Ծ�ο��ź�
t = 0:T:time_finish-T;
time_domain_transfunc_outer = ilaplace(close_transfunc_outer/s);    %ʱ���ڻ����� ��λ��Ծ�ź�
time_domain_transfunc_inner = ilaplace(close_transfunc_inner/s);
yo = double(subs(time_domain_transfunc_outer));                     %sym���ͱ��������¼������
yi = double(subs(time_domain_transfunc_inner));%��� 


%% ��������ɢ�� �ò���д�������
i_term = 0;
u_i = zeros(1,time_finish/T);                       
u_o = zeros(1,time_finish/T);
for i = 2:time_finish/T 
    error_o = Reference_o(i)-yo(i-1);
    %p_term = Kp*error_i(i);                        %��ͳPI���� ��������λ������·��
    p_term = -double(Kp*yo(i-1));                   %IP���� ��������λ�ڷ�����·��
    i_term = i_term+Kp/tauI*error_o*T;
    u_o(i) = p_term+i_term;
    Reference_i = u_o(i);                           %�⻷�����ź���Ϊ�ڻ��ο��ź�
    error_i = Reference_i-yi(i-1);                  
    u_i(i) = -K*error_i;                            %������ܿ��������ڻ���������������
                                                    %�����Ҫ���ǵģ�������
end



%% ��ͼ
%�ڻ� ��׼ û��
% figure(1)
% subplot(211)
% plot(t,u_o,'--r');%�ڻ��ο��ź�
% hold on
% plot(t,yi,'b');   %�ڻ�����ź�
% xlabel('Time:(s)')
% ylabel('Signal')
% legend('Reference','Designed System');

% subplot(212)
% plot(t,u_i,'r.');%�ڻ������ź�
% xlabel('Time:(s)')
% ylabel('Output')
% legend('Control Output')

%�⻷
figure(2)
subplot(211)
plot(t,Reference_o,'--r');
hold on
plot(t,yo,'b');
xlabel('Time:(s)')
ylabel('Signal')
legend('Reference','Designed System');

subplot(212)
plot(t,u_o,'r.');
xlabel('Time:(s)')
ylabel('Output')
legend('Control Output')

%�Ƚ��ڻ��⻷�����ٶ�
figure(3)
plot(t,Reference_o,'--r');
hold on
plot(t,yo,'b');
plot(t,yi,'g');
xlabel('Time:(s)')
ylabel('Signal')
legend('Reference','Outer Loop','Inner Loop');






