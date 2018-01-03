%clear
close all
clc
for i = 1:1:10
    if i == 3
        continue;
    elseif i == 4
        break;
    end
    disp(i);
end