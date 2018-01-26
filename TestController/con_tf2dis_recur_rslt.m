function y_d = con_tf2dis_recur_rslt(transfunc,k,T)
%transfunc:�ջ������봫�� k���������

g1 = c2d(transfunc,T,'zoh');                                               %�õ���ɢϵͳ����֮�󣬵��ƹ�ϵ��ȷ��
 

%% �������õ��ƹ�ϵ��ʼ����ɢϵͳ����
% ���ڵ��������õ�Reference����˲�����Ҫ�ڴ����м���1/s
[num, den] = tfdata(g1);
len_rec = length(den{1});                   %������Ҫ�õ�������
reference = ones(1,k);                      
out_pre = zeros(1,len_rec-1);               %������������ÿ����Ҫ��ǰ�漸�ε����ϵ���������
ref_pre = reference(1:len_rec);             %ÿ����Ҫ��ǰ�漸�εĲο�ϵ���������
out_eff = den{1}(2:1:end);                  %�������������������ϵ��
ref_eff = num{1}(1:end);                    %�������������ο�����ϵ��
y_d = zeros(1,len_rec);                     %��ɢϵͳ���


%% ����
for i = len_rec:k
    out_new = ref_eff*ref_pre'-out_eff*out_pre';            %��֮ǰ�Ĳο��������������������ǰ�����ֵ
    out_pre = [out_new out_pre(1:end-1)];                   %�������ϵ������
    if(i~=k)                                                %��ֹ���
        ref_pre = [reference(len_rec+1) ref_pre(1:end-1)];  %���²ο�ϵ������
    end
    y_d(i) = out_new;
end

%% ��ͼ
% figure 
% plot(t,y,'b')
% xlabel('Time: (s)')
% ylabel('Signal')
% ylim([0,1.2])
% hold on
% 
% plot(t,reference,'--r')
% plot(t,y_d,'go')
% legend('Continuous','Reference','Discrete')



