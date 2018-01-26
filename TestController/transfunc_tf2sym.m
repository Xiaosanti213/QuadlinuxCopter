% ��G1(s)��  tf����ת���  sym���� 
function sym_transfunc = transfunc_tf2sym(G,type)
[num,den]=tfdata(G);                     %��ȡtf���ʹ����е�����Ԫ��
N=size(den);                             %den��numͬά�ȣ�����������������������ά��

if(type)%type=1����ϵͳ
    syms s  
    for i=1:N(1)     
        for j=1:N(2)          
            Num=poly2sym(num{i,j},s);          
            Den=poly2sym(den{i,j},s);             
            sym_transfunc(i,j)=Num/Den;     
            %sym_transfunc(i,j)=polyvec2numden_s(num{i,j}, den{i,j},0);
        end
    end
else   %type=0��ɢϵͳ
    syms z
        for i=1:N(1)     
            for j=1:N(2)          
                Num=poly2sym(num{i,j},z);          
                Den=poly2sym(den{i,j},z);             
                sym_transfunc(i,j)=Num/Den;     
            end
        end
end


%assignin('base','sym_G1',sym_G1);       %���õ����м����Ҳ���ڻ��������ռ�'base'�б�����
%((36*s^3)/61 - (30087042341899*s^2)/17592186044416