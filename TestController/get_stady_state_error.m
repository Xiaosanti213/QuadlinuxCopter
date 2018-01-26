function steady_state_error = get_stady_state_error(close_transfunc)

%终值定理计算闭环稳态误差
syms s
steady_state = limit(s*close_transfunc, s, 0);
steady_state_error = 1-steady_state;%单位阶跃响应
%limit参数：syms类型变量 syms自变量 inf正无穷/-inf负无穷/x0点,left right单边极限

%计算多变量极限时候嵌套使用limit

