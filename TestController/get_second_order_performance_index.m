function [tr, tp, ts, sigma, N]=get_second_order_performance_index(ksi,wn)
%% ��������ָ��
if(ksi>=1)
    %�����������������ֵ��������
    return;
else                                        %Ƿ����
    wd = sqrt(1-ksi^2)*wn;
    beta = atan2(sqrt(1-ksi^2),-ksi);       %-pi~pi
    tr = beta/wd;                           %����ʱ��
    tp = pi/wd;                             %��ֵʱ��
    ts = 3.5/ksi/wn;                        %5%����
    ts1 = 4.5/ksi/wn;                       %2.5%����
    sigma = exp(-pi*ksi/sqrt(1-ksi^2));     %������,����
    N = -2.25/log(sigma);                   %�񵴴��� 2%����
    N1 = -1.75/log(sigma);                  %�񵴴��� 5%����
end


%% ʱ��λ��Ծ��Ӧ
syms s t;
g = wn^2/(s^2+2*ksi*wn*s+wn^2);
time_domain_transfunc = ilaplace(g/s);
time_finish = 1.5;
T = 0.02;
t = 0:T:time_finish-T;
y = subs(time_domain_transfunc);
r = ones(1,time_finish/T);


%% ��ͼ
figure(1)
plot(t,r,'--r')
hold on
plot(t,y,'b');
xlabel('Time:(s)')
ylabel('Signal')

%����ָ��ؼ���

syms t
yr = subs(time_domain_transfunc,t,tr);%��������Ŀ��100%λ�õ�
plot(tr,yr,'p');
yp = subs(time_domain_transfunc,t,tp);%���������ֵ�õ�
plot(tp,yp,'p');
ys = subs(time_domain_transfunc,t,ts);%��������5%����λ�õ�
plot(ts,ys,'p');
ys1 = subs(time_domain_transfunc,t,ts1);%��������2.5%����λ�õ�
plot(ts1,ys1,'p');



legend('Reference','Designed Second-Order System','����ʱ��','��ֵʱ��',...
    '5%����','2.5%����');
sigma_str = strcat('�������� ',num2str(sigma*100),' %');
N_str = strcat('�񵴴���(5%������: ',num2str(N1));
text(tp,1+sigma+0.10,sigma_str);
text(tp-0.1,1+sigma+0.05,N_str);

