clear
close all
clc


%% �����ڸ��켣����ȥ��ż���� �ɺ��Լ���� �򻯶���ϵͳ����ָ�����
wn = sqrt(2.56);
ksi = 0.5;
[tr, tp, ts, sigma]=get_second_order_performance_index(ksi,wn);