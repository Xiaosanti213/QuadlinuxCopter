%���Դ�z����ת���ɲ�ַ���
close all
clear
%clc

%%
ts=0.01;                      %����ʱ�� ����������̫�̿��ܲ�����  
sys=tf([1],[1 0 0]);          %�������ض��󴫵ݺ���  
dsys=c2d(sys,ts,'tustin');    %zoh 
[num,den]=tfdata(dsys,'v');   %��ɢ������ȡ���ӡ���ĸ    
rin=1.0;                      %����Ϊ��Ծ�ź�   
u_1=0.0; u_2=0.0;             %ϵͳ�������ֵ���ϵ����ʼ��  
y_1=0.0; y_2=0.0;             %
error_1=0;                    %��ʼ���  
x=[0 0 0]';                   %�洢����������΢�ֲ���  
pid = [3, 0.05, 4];           %PID�ڶ�����΢��
final_time=5;                 %����ʱ�䣬��10s
for k=1:1:final_time/ts  
    r(k)=rin;   
    u(k)=pid(1)*x(1)+pid(2)*x(2)+pid(3)*x(3);          %�����������������
    %���濹���ֱ���
    if u(k)>=10  
        u(k)=10;  
    end
    if u(k)<=-10  
        u(k)=-10;  
    end
    yout(k)=-den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;    %��ַ�����λ������� 
    error(k)=r(k)-yout(k);                                   %�������error
    u_2=u_1;u_1=u(k);  
    y_2=y_1;y_1=yout(k);                                     %��ǰʱ�̵�u��y��ǰһʱ�̵ĸ���
    
    x(1)=error(k);   
    x(2)=(error(k)-error_1)/ts;  
    x(3)=x(3)+error(k)*ts;                                   %�������Ҳ����ͨ����һ��z�任�õ���
    error_2=error_1;  
    error_1=error(k);  
end

%% ��������ϵͳ����һ��
% s = tf('s');
% sys_add_pid = sys*(pid(1)+pid(2)*s+pid(3)/s);
% close_transfunc = feedback(sys_add_pid,1);
% time_domain_transfunc = ilaplace(transfunc_tf2sym(close_transfunc/s,1));%�����Ծ�ź�
t = 0:ts:final_time-ts;
% y_c = subs(time_domain_transfunc);

%%
reference = ones(1,final_time/ts);
figure 
plot(t,reference,'--r')
xlabel('Time: (s)')
ylabel('Signal')
ylim([0,1.2])
hold on

%plot(t,y_c,'b')
plot(t,yout,'g.')
%legend('Reference','Continuous','Discrete')
legend('Reference','Discrete')
