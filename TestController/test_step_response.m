%������������ɢϵͳPID������Ӧ���
close all
clear 
clc


%% ͨ���㼫�㹹������
% num = 0.3;
% den = pole2polyvec(-1);
% %transfunc = tf(num, den);                                    %��������tf����
% transfunc = polyvec2numden_s(num, den, 0);                    %�õ���������ʽ
% close_transfunc = get_close_loop_transfunc(transfunc, 1);     %��λ������

% z = [0 1 2]';
% p = [-1 -2 -3]';
% K = 1.2;
% tfunc = zpk(z,p,K);                                           %�õ�����zpk����

%% ���ֱ�Ӹ�������ʽ��������
%syms s 
s = tf('s');
Kp = 10;           %����������ϵ��
tauD = 0.1;       %΢��ϵ��������̬���������
tauD1 = 0.3;
tauD2 = 0.5;
tauI = 0.3;       %����,������ϵ��Kp/tauI��tauI��С����Ӧ�ٶȱ�졣��ĸ��s���ϵͳ�ͱ���̬����0
tauI1 = 0.4;
tauI2 = 0.1;

transfunc = 0.3/(s+1);                                                   %����ϵͳ����
close_transfunc = add_p2transfunc(transfunc, Kp, tauD, tauI);        %���봫ͳPID������
close_transfunc1 = add_p2transfunc(transfunc, Kp, tauD1, tauI1);     
close_transfunc2 = add_p2transfunc(transfunc, Kp, tauD2, tauI2);     
%steady_state_error = get_stady_state_error(close_transfunc);        %�����ź�֮�������̬���

%% s��ת��z��Χ��
final_time = 10;                                                     %����ʱ��10s
T = 0.02; T1 = 0.05; T2 = 0.1;                                       %���沽��
k = final_time/T; k1 = final_time/T1; k2 = final_time/T2;            %��������
t = 0:T:final_time-T;
% t1 = 0:T1:final_time-T1;
% t2 = 0:T2:final_time-T2;
y_d = con_tf2dis_recur_rslt(close_transfunc2,k,T);
% y_d1 = con_tf2dis_recur_rslt(close_transfunc,k1,T1);
% y_d2 = con_tf2dis_recur_rslt(close_transfunc,k2,T2);


%% ����ϵͳ���Ϸ��任ת����ʱ��Χ��
close_transfunc = close_transfunc/s;
close_transfunc1 = close_transfunc1/s;
close_transfunc2 = close_transfunc2/s;


time_domain_res_func  = ilaplace(transfunc_tf2sym(close_transfunc,1));                              %��ת����sym����
time_domain_res_func1 = ilaplace(transfunc_tf2sym(close_transfunc1,1));
time_domain_res_func2 = ilaplace(transfunc_tf2sym(close_transfunc2,1));

%��t�滻
response = double(subs(time_domain_res_func));                                                      %subs����ʹ��t��ֵ�����еı���
response1 = double(subs(time_domain_res_func1));              
response2 = double(subs(time_domain_res_func2));              


% k = t/T;                                                                                            %����������
% response_discrete = abs(double(subs(time_res_discrete_func)));                                      %�õ�������������������

%% ��ͼ
figure
plot(t,ones(1,length(t)),'--r')
hold on
plot(t,response,'b')
plot(t,response1,'g')
plot(t,response2,'m')

plot(t,y_d,'b.')
% plot(t1,y_d1,'g.')
% plot(t2,y_d2,'m.')

xlabel('Time: s')
ylabel('Signal')
legend('Reference', 'Continuous1','Continuous2', 'Continuous3',...
        'Discrete1')%, 'Discrete2','Discrete3');
%sse = strcat('Steady-state Error: ', num2str(double(steady_state_error)));%��ת��double���ͣ���ת��str
%text(7,1,sse);%����˵����ע
xlim([0 t(end)]);
ylim([0 1.2])

