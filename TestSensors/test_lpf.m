% 测试滤波器
clear
close all
clc

%% 采样数据
fs=2000;
t=(1:fs)/fs;                      %采样时间1s内周期是1/fs
ff1=100;                          %低频信号
ff2=400;                          %高频噪声
x=sin(2*pi*ff1*t)+sin(2*pi*ff2*t);%模拟信号叠加
y=LowPassFilter(x,300,350,0.1,20,fs);%低通滤波

figure;
subplot(211);plot(t,x);
xlabel('Time:(s)')
ylabel('Signal')
legend('原始信号')
hold on
subplot(212);plot(t,y);
xlabel('Time:(s)')
ylabel('Signal')
legend('低通滤波之后的信号')


plot_fft(x,fs,1);
plot_fft(y,fs,1);





%% 画信号的幅频谱和功率谱
function plot_fft(y,fs,varargin)
%可选输入参数是用来控制需要查看的频率段的
%第一个是需要查看的频率段起点
%第二个是需要查看的频率段的终点

nfft= 2^nextpow2(length(y));%找出大于y的个数的最大的2的指数值（自动进算最佳FFT步长nfft）
%nfft=1024;%人为设置FFT的步长nfft
y=y-mean(y);%去除直流分量
y_ft=fft(y,nfft);%对y信号进行DFT，得到频率的幅值分布
y_p=y_ft.*conj(y_ft)/nfft;%conj()函数是求y函数的共轭复数，实数的共轭复数是他本身。
y_f=fs*(0:nfft/2-1)/nfft;
% T变换后对应的频率的序列
% y_p=y_ft.*conj(y_ft)/nfft;%conj()函数是求y函数的共轭复数，实数的共轭复数是他本身。

figure
subplot(211);plot(y_f,2*abs(y_ft(1:nfft/2))/length(y));
ylabel('幅值');xlabel('频率');title('信号幅值谱');
subplot(212);plot(y_f,y_p(1:nfft/2));
ylabel('功率谱密度');xlabel('频率');title('信号功率谱');
end




