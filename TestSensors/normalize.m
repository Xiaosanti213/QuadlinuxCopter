%向量正交化
function norm_result = normalize(vector_a)

norm_result = zeros(3,1);
amplitude = sqrt(dot_product(vector_a, vector_a));

norm_result(1) = vector_a(1)/amplitude; 
norm_result(2) = vector_a(2)/amplitude;
norm_result(3) = vector_a(3)/amplitude;