% ������
function dot_result = dot_product(vector_a, vector_b)

dot_result = 0;
%�����ж�һ��
for i = 1:1:length(vector_a)
    dot_result = vector_a(i)*vector_b(i)+dot_result;
end
