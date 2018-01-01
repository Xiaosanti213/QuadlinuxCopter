function rot_matrix = calculate_rot_matrix(before_vector, after_vector)
%�����໥��֤��������ȷ
%�����������ټ���н�
before_vector = normalize(before_vector);
after_vector = normalize(after_vector);
rot_angle = acos(dot_product(before_vector, after_vector));

%��ת����鲻�������������������޵������ת��ʽ�������
rot_axis = cross_product(before_vector, after_vector);
rot_matrix = rodrigue_rotation_matrix(rot_axis, rot_angle);

