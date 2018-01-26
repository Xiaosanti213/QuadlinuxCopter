%����PID����ת��Ϊ��ַ���
clear 
close all
%clc


%% s��PI������
s = tf('s');
g = 0.3/(s+1);                                                               %����ϵͳ����
g = g*(2+20/.3/s);                                                           %����P=8 tauI=0.3
g = feedback(g,1);                                                           %�ջ���
T = 0.02;
syms s z                                                                     %����Ǽ����Ծ�����ź���
%error = get_stady_state_error(transfunc_tf2sym(g,1)/s);
g1 = c2d(g,T,'foh')                                                          %�õ���ɢϵͳ����֮�󣬵��ƹ�ϵ������λ����ȷ��
g1 = simplify(subs(transfunc_tf2sym(g,1),s,2*(1-z^(-1))/(1+z^(-1))/T));    %˫���Ա任����Ͻ�����ǱȽϲ����
g1 = transfunc_sym2tf(g1,0)


%% ��ȡ��ɢ��������ʽ���ӷ�ĸ
% ���ڵ��������õ�Reference����˲�����Ҫ�ڴ����м���1/s
[num, den] = tfdata(g1);                    %����Ϊtf������ȡ����ʽϵ��



%% ���ƹ�ϵ��ʼ����ɢϵͳ����
finish_time = 10;                           %����ʱ��10s     
len_rec = length(den{1});                   %������Ҫ�õ�������
reference = ones(1,finish_time/T);                      
out_pre = zeros(1,len_rec-1);               %������������ÿ����Ҫ��ǰ�漸�ε����ϵ���������
ref_pre = reference(1:len_rec);             %ÿ����Ҫ��ǰ�漸�εĲο�ϵ���������
out_eff = den{1}(2:1:end)/den{1}(1);        %�������������������ϵ����������1
ref_eff = num{1}(1:end)/den{1}(1);          %�������������ο�����ϵ����������1
y_d = zeros(1,len_rec);                     %��ɢϵͳ���



%% ����
for i = len_rec:finish_time/T
    out_new = ref_eff*ref_pre'-out_eff*out_pre';            %��֮ǰ�Ĳο��������������������ǰ�����ֵ
    out_pre = [out_new out_pre(1:end-1)];                   %�������ϵ������
    if(i~=len_rec:finish_time/T)                            %��ֹ���
        ref_pre = [reference(len_rec+1) ref_pre(1:end-1)];  %���²ο�ϵ������
    end
    y_d(i) = out_new;
end



%% ����ת����ʱ��
%������Ӧ��Ҫ��1/s���任
time_domain_transfunc = ilaplace(transfunc_tf2sym(g,1)/s);  %ʹ������ϵͳ��������Ծ�ź�
t = 0:T:finish_time-T;
y = subs(time_domain_transfunc);                            %����ϵͳʱ�����



%% ��ͼ
figure 
plot(t,reference,'--r')
xlabel('Time: (s)')
ylabel('Signal')
ylim([0,1.2])
hold on

plot(t,y,'b')
plot(t,y_d,'go')
legend('Reference','Continuous','Discrete')

%ginput(2)%����Ĺ��ߣ�




