% 将G1(s)的  tf对象转变成  sym对象 
function sym_transfunc = transfunc_tf2sym(G,type)
[num,den]=tfdata(G);                     %提取tf类型传函中的两个元胞
N=size(den);                             %den和num同维度，决定了输入输出矩阵的两个维数

if(type)%type=1连续系统
    syms s  
    for i=1:N(1)     
        for j=1:N(2)          
            Num=poly2sym(num{i,j},s);          
            Den=poly2sym(den{i,j},s);             
            sym_transfunc(i,j)=Num/Den;     
            %sym_transfunc(i,j)=polyvec2numden_s(num{i,j}, den{i,j},0);
        end
    end
else   %type=0离散系统
    syms z
        for i=1:N(1)     
            for j=1:N(2)          
                Num=poly2sym(num{i,j},z);          
                Den=poly2sym(den{i,j},z);             
                sym_transfunc(i,j)=Num/Den;     
            end
        end
end


%assignin('base','sym_G1',sym_G1);       %所用到的中间变量也将在基本工作空间'base'中保留。
%((36*s^3)/61 - (30087042341899*s^2)/17592186044416