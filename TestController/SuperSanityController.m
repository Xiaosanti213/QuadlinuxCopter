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
%get_second_order_performance_index(ksi,wn);

[~,den] = numden(close_transfunc_outer);
coe = coeffs(den);
p_o = double(roots(coe(end:-1:1)));
% figure
% plot(real(p_o),imag(p_o),'r*');
% hold on
% plot(-K,0,'b*');
% legend('�⻷����','�ڻ�����');


%% ����ϵͳʱ��
time_finish = 2;                                                    %����ʱ��1.5s
T = 0.02;                                                           %���沽��20ms
Reference_o = ones(1,time_finish/T);                                %��Ծ�ο��ź�
t = 0:T:time_finish-T;

time_domain_transfunc_outer = ilaplace(close_transfunc_outer/s);    %ʱ���ڻ����� ��λ��Ծ�ź�
time_domain_transfunc_inner = ilaplace(close_transfunc_inner/s);
yo = double(subs(time_domain_transfunc_outer));                     %sym���ͱ��������¼������
yi = double(subs(time_domain_transfunc_inner));

%% ��������ɢ�� �ò���д�������
i_term = 0;
u_i = zeros(1,time_finish/T);                       
u_o = zeros(1,time_finish/T);
y_i = u_i;
y_o = u_o;
for i = 2:time_finish/T 
    %�����⻷�������룺
    error_o = Reference_o(i)-y_o(i-1);
    %p_term = Kp*error_o;                            %��ͳPI���� ��������λ������·��
    p_term = -double(Kp*y_o(i-1));                   %IP���� ��������λ�ڷ�����·��
    i_term = i_term+Kp/tauI*error_o*T;               %�ۻ����ã����Կ����ֱ���
    u_o(i) = p_term+i_term;
    Reference_i = u_o(i);                            %�⻷�����ź���Ϊ�ڻ��ο��ź�
    %�����ڻ��������룺
    error_i = Reference_i-y_i(i-1);                  
    u_i(i) = K*error_i;                              %������ܿ��������ڻ���������������
    %�������⻷״̬�����
    y_i(i) = y_i(i-1)+u_i(i)*T;                      %����ʵ���ϸ���Ĺ��̾����������ģ��
    y_o(i) = y_o(i-1)+y_i(i)*T;
end

%% ˫��΢��֮���õ���ǰһ�ο�����������ǰ�����������ۻ����÷���anti-windup
i_term = 0;
u_i_antiwindup = zeros(1,time_finish/T);                       
u_o_antiwindup = zeros(1,time_finish/T);
y_i_antiwindup = u_i_antiwindup;
y_o_antiwindup = u_o_antiwindup;

for i = 3:time_finish/T 
    %�⻷
    p_term = double(Kp*(-y_o_antiwindup(i-1)+y_o_antiwindup(i-2)));           %IP���� ��������λ�ڷ�����·��
    i_term = Kp/tauI*(Reference_o(i)-y_o_antiwindup(i-1))*T;                  %���ۻ�����,����������������y�����������ܺ��ϸ���һ��T�ӳ�
    u_o_antiwindup(i) = p_term+i_term+u_o_antiwindup(i-1);
    
    %�ڻ�
    Reference_i = u_o_antiwindup(i);                                          %�⻷�����ź���Ϊ�ڻ��ο��ź�
    error_i = Reference_i-y_i_antiwindup(i-1);                  
    u_i_antiwindup(i) = K*error_i;                                            %������ܿ��������ڻ���������������
    
    % �����ֱ���
    output_limit = 50;
    if(u_i_antiwindup(i) > output_limit)
        u_i_antiwindup(i) = output_limit;
    elseif(u_i_antiwindup(i) < -output_limit)
        u_i_antiwindup(i) = -output_limit;
    end
    %���⻷���
   y_i_antiwindup(i) = y_i_antiwindup(i-1)+u_i_antiwindup(i)*T;              %����ʵ���ϸ���Ĺ��̾����������ģ��
   y_o_antiwindup(i) = y_o_antiwindup(i-1)+y_i_antiwindup(i)*T;
%     y_i(i) = 0;
%     y_o(i) = 0;
end




%% ��ͼ 
%�ڻ�
figure(1)
subplot(211)
plot(t,u_o,'--r');%�ڻ��ο��ź�
hold on
%plot(t,yi,'m');   %�ڻ�����ϵͳ����ź�,���ʵ��û��ȷ��
plot(t,y_i,'b.'); %�ڻ���ɢϵͳ����ź�
plot(t,y_i_antiwindup,'c.')%�����ֱ���΢����ʽ��ƣ���ɢϵͳ���
xlabel('Time:(s)')
ylabel('Signal')
legend('Reference','Discrete System','Discrete Antiwindup System');
title('�ڻ�ϵͳ״̬���ͼ')

subplot(212)
plot(t,u_i,'b.'); %�ڻ���ɢϵͳ�����ź�
hold on 
plot(t,u_i_antiwindup,'c.')
xlabel('Time:(s)')
ylabel('Output')
legend('Control Output','Anti-Windup Control Output Design')
title('�ڻ���������ͼ')


%�⻷
figure(2)
subplot(211)
plot(t,Reference_o,'--r');
hold on
plot(t,yo,'m'); %�⻷����ϵͳ����ź�
plot(t,y_o,'b.');%�⻷��ɢϵͳ����ź�
plot(t,y_o_antiwindup,'c.')%�����ֱ���΢����ʽ��ƣ���ɢϵͳ���
xlabel('Time:(s)')
ylabel('Signal')
legend('Reference','Designed Continuous System','Discrete System','Anti-Windup Control Output Design');
title('�⻷ϵͳ���״̬ͼ')

subplot(212)
plot(t,u_o,'b.');%�⻷��ɢϵͳ�����ź�
xlabel('Time:(s)')
ylabel('Output')
hold on
plot(t,u_o_antiwindup,'c.')
legend('Control Output','Anti-windup Output');
title('�⻷��������ͼ')



% %�Ƚ��ڻ��⻷�����ٶ�
% figure(3)
% plot(t,Reference_o,'--r');
% hold on
% plot(t,yo,'b');
% plot(t,yi,'g');
% xlabel('Time:(s)')
% ylabel('Signal')
% legend('Reference','Outer Loop','Inner Loop');






