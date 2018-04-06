%最后调整pid
%% 提取数据
[raw_data]=importdata('test9.txt','%s'); 
finish = 2433;
i=17;
out = zeros(4,floor((finish+1-i)/4));
index = 1;
while(i < finish)
    str_temp = cell2mat(raw_data(i)); %每个元胞中的数据变成字符串数组
    out(1,index) = str2double(str_temp(7:10));
    i = i+1;
    str_temp = cell2mat(raw_data(i));
    out(2,index) = str2double(str_temp(7:10));
    i = i+1;
    str_temp = cell2mat(raw_data(i));
    out(3,index) = str2double(str_temp(7:10));%多给一个空格
    i = i+1;
    str_temp = cell2mat(raw_data(i));
    out(4,index) = str2double(str_temp(7:10));
    i = i+1;
    index = index + 1;
end


%% 画图
figure(1)
subplot(411)
plot(out(1,:),'r')
xlabel('Time(s)')
ylabel('Signal')
legend('1st motor')

subplot(412)
plot(out(2,:),'b')
xlabel('Time(s)')
ylabel('Signal')
legend('2nd motor')

subplot(413)
plot(out(3,:),'g')
xlabel('Time(s)')
ylabel('Signal')
legend('3rd motor')

subplot(414)
plot(out(4,:),'k')
xlabel('Time(s)')
ylabel('Signal')
legend('4th motor')




