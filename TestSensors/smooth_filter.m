function ys = smooth_filter(y)

len = length(y);%һά����
smoothing = 2;%�˲����Ӵ���1��Խ��Խƽ��
ys = zeros(1,len);
for i = 2:1:len
    ys(i) = (ys(i-1) * (smoothing-1) +y(i))  / smoothing;
end