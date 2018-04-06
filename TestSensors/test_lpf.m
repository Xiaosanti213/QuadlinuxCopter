% �����˲���
clear
close all
clc

%% ��������
fs=2000;
t=(1:fs)/fs;                      %����ʱ��1s��������1/fs
ff1=100;                          %��Ƶ�ź�
ff2=400;                          %��Ƶ����
x=sin(2*pi*ff1*t)+sin(2*pi*ff2*t);%ģ���źŵ���
y=LowPassFilter(x,300,350,0.1,20,fs);%��ͨ�˲�

figure;
subplot(211);plot(t,x);
xlabel('Time:(s)')
ylabel('Signal')
legend('ԭʼ�ź�')
hold on
subplot(212);plot(t,y);
xlabel('Time:(s)')
ylabel('Signal')
legend('��ͨ�˲�֮����ź�')


plot_fft(x,fs,1);
plot_fft(y,fs,1);





%% ���źŵķ�Ƶ�׺͹�����
function plot_fft(y,fs,varargin)
%��ѡ�������������������Ҫ�鿴��Ƶ�ʶε�
%��һ������Ҫ�鿴��Ƶ�ʶ����
%�ڶ�������Ҫ�鿴��Ƶ�ʶε��յ�

nfft= 2^nextpow2(length(y));%�ҳ�����y�ĸ���������2��ָ��ֵ���Զ��������FFT����nfft��
%nfft=1024;%��Ϊ����FFT�Ĳ���nfft
y=y-mean(y);%ȥ��ֱ������
y_ft=fft(y,nfft);%��y�źŽ���DFT���õ�Ƶ�ʵķ�ֵ�ֲ�
y_p=y_ft.*conj(y_ft)/nfft;%conj()��������y�����Ĺ������ʵ���Ĺ������������
y_f=fs*(0:nfft/2-1)/nfft;
% T�任���Ӧ��Ƶ�ʵ�����
% y_p=y_ft.*conj(y_ft)/nfft;%conj()��������y�����Ĺ������ʵ���Ĺ������������

figure
subplot(211);plot(y_f,2*abs(y_ft(1:nfft/2))/length(y));
ylabel('��ֵ');xlabel('Ƶ��');title('�źŷ�ֵ��');
subplot(212);plot(y_f,y_p(1:nfft/2));
ylabel('�������ܶ�');xlabel('Ƶ��');title('�źŹ�����');
end




