function [row, col] = find_element_in_matrix(A, n)

row_len = size(A,1);
column_len = size(A,2);
% reshape(A, [row_len*column_len, 1]);%�������Ⱥ�չ��
index = 1;

for i= 1:row_len
    for j = 1:column_len
        if(A(i,j) == n)
            row(index) = i;%��¼��Ӧ������
            col(index) = j;
            index = index+1;
        end
    end
end

