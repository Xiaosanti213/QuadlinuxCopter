function ys = smooth_filter(y)

len = length(y);%一维向量
smoothing = 2;%滤波因子大于1，越大越平滑
ys = zeros(1,len);
for i = 2:1:len
    ys(i) = (ys(i-1) * (smoothing-1) +y(i))  / smoothing;
end