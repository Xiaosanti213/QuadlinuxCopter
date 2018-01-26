function [Kp,tauI,close_transfunc] = fir_odr_sec_odr_get_PIDs(a,b,ksi,wn,type)
%ԭϵͳһ��
%Ŀ����ױջ����� ͨ�����1��������ȻƵ��wn 2��������ksi���
%����PIDϵ�� ϵͳ����Ϊa/(s+b)

syms s
%% ��ͳPI���������õõ��ջ������������
% �ջ���û����ȫʵ��,���Ӷ�һ���ջ����taus+1
if(type == 1)
    tauI = (2*ksi*wn-b)/wn^2;
    Kp = (2*ksi*wn-b)/a;
    close_transfunc = wn^2/(s^2+2*ksi*wn*s+wn^2)*(s+1/tauI);
%% IP����,�����ͳPI������
% ��Ϊ������Kp������֧·G(s)�ϣ�������һ�ַ�������
% ����Ա����⣺���ֻ�����Ȼ��ԭλ��Kp/(tauI*s)�㷨һģһ��
elseif(type == 2)
    tauI = (2*ksi*wn-b)/wn^2;
    Kp = (2*ksi*wn-b)/a;
    close_transfunc = wn^2/(s^2+2*ksi*wn*s+wn^2);%û�����
elseif(type == 3)
%% �����˲�����PD������
% �ϱ��Ѿ����Դﵽ����Ŀ�� �������ʹ��
elseif(type == 4)
%% ����΢���˲�����PID������
else
end



%% �����˲�����PD������
% ģ��: C(s)=Kp+Kd*s/(tauf+1) 
% �߽���ʽ���������Լ������Ҫָ������λ�ò�ͨ������ʽ��ʽ����ϵ���õ�






%% ��ʱ���ڻ�����Ӧ����
time_finish = 3;                              %����ʱ��10s
T = 0.02;                                     %���沽��20ms
Reference = ones(1,time_finish/T);            %��Ծ�ο��ź�
time_domain_transfunc = ilaplace(close_transfunc/s);
t = 0:T:time_finish-T;
y = subs(time_domain_transfunc);


% ��ͼ
% figure(1)
% plot(t,Reference)
% hold on
% plot(t,y);
% xlabel('Time:(s)')
% ylabel('Signal')
% legend('Reference','Designed System');
