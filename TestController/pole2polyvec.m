function poly = pole2polyvec(pole)
%给出极点位置行向量 输出对应多项式从高到低阶系数


poly = 1;
n = length(pole);
for kk=1:n
    poly=conv([1 -pole(kk)], poly);                     % 得到多项式系数从高阶到低阶                               
end