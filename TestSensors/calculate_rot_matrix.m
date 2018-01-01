function rot_matrix = calculate_rot_matrix(before_vector, after_vector)
%经过相互验证本计算正确
%先正交化，再计算夹角
before_vector = normalize(before_vector);
after_vector = normalize(after_vector);
rot_angle = acos(dot_product(before_vector, after_vector));

%旋转轴这块不用正交化，正交化在罗德里格旋转公式当中完成
rot_axis = cross_product(before_vector, after_vector);
rot_matrix = rodrigue_rotation_matrix(rot_axis, rot_angle);

