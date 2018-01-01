% 计算点积
function dot_result = dot_product(vector_a, vector_b)

dot_result = 0;
%可以判断一下
for i = 1:1:length(vector_a)
    dot_result = vector_a(i)*vector_b(i)+dot_result;
end
