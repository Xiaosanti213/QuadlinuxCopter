function poly = pole2polyvec(pole)
%��������λ�������� �����Ӧ����ʽ�Ӹߵ��ͽ�ϵ��


poly = 1;
n = length(pole);
for kk=1:n
    poly=conv([1 -pole(kk)], poly);                     % �õ�����ʽϵ���Ӹ߽׵��ͽ�                               
end