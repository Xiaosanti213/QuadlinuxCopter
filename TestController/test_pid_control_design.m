%PI��������ƣ���ɢ������
clear 
close all
clc

%% ָ��ԭϵͳ
syms s
transfunc = 1/(s+1);



%% ��ƿ���ϵͳ�����Ӧ��ʹ��һ���������������֤��������
Kp = 20;
tauI = 0.3;
tauD = 0;
controller_transfunc = Kp*[(1+tauI*s)/tauI/s]*(1+tauD*s); %PI���������
transfunc_open = transfunc*controller_transfunc;


%% ���������������
close_transfunc = get_close_loop_transfunc(transfunc_open,1);
time_domain_continuous_tf = ilaplace(close_transfunc/s);%��Ծ��Ӧ
time_finish = 10;                         %10s
T = 0.02;                                 %����0.02s
t = 0:T:time_finish-T;     
y = subs(time_domain_continuous_tf);      %����ϵͳ���
r = ones(1,length(t));


%% ����ϵͳ�����ֳ�����
% for k = 1:time_finish/T
%     u(k) = Kp*(r-y)+Kp/tauI*double(int(r-y, 0, k));
% end




%% ��ɢ������
i_term = 0;
error = zeros(1,time_finish/T);
u_d = error;
for i = 2:time_finish/T %���ֶ���ò��û��ֱ�ӷ��棬ֻ���������۵�����������Ƚϡ�
    error(i) = r(i)-y(i-1);
    p_term = Kp*error(i);
    i_term = i_term+Kp/tauI*error(i)*T;
    u_d(i) = p_term+i_term;
end



%% ��ͼ
figure(1)
plot(t,r,'--r')
hold on
plot(t,y,'b');
xlabel('Time:(s)');
ylabel('Signal');
ylim([0,1.2]);
legend('Reference','Continuous');%'Discrete');




figure(2)
plot(t,u_d,'ro');


