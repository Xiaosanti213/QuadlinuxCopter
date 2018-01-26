clear
close all
clc


%% 可用于根轨迹分析去掉偶极子 可忽略极点后 简化二阶系统性能指标计算
wn = sqrt(2.56);
ksi = 0.5;
[tr, tp, ts, sigma]=get_second_order_performance_index(ksi,wn);