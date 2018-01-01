% 计算3维向量叉积
function vector_c = cross_product(vector_a, vector_b)


vector_c = zeros(3,1);
vector_c(1) = vector_a(2)*vector_b(3)-vector_a(3)*vector_b(2);
vector_c(2) = vector_a(3)*vector_b(1)-vector_a(1)*vector_b(3);
vector_c(3) = vector_a(1)*vector_b(2)-vector_a(2)*vector_b(1);

