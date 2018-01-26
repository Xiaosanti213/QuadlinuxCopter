  #include "test_attitude_estimate.h"
  #include <stdio.h>
  #include <math.h>//cos
  #include <stdlib.h>//abs
  // 不包含函数对应头文件，可能造成计算结果未知，编译可能不出错
  
  
  
  
  
  
  
  
  
  static void matrix_multiply(const float mat[3][3], const float* vec1, float* vec2);
  static void sensors_data_direction_correct(sd*);
  static void euler_to_rotmatrix(const float* euler_delta, float rot_matrix[3][3]);
  static void normalize(float*);
  static float fast_inv_sqrt(const float);
  static void calculate_rot_matrix(float*, float*, float rot_matrix[3][3]); 
  static float dot_product(const float*, const float*);
  static void cross_product(const float* vec1, const float* vec2, float* cp);
  static void rodrigue_rotation_matrix(float* rot_axis, const float rot_angle, float rot_matrix[3][3]);
  static void rot_matrix_to_euler(float R[3][3], float* euler_angle);
  static float atan2_numerical(float y, float x);
  static float abs_c_float_version(float);
  
  
  
  
  int main()
  {
	  // 测试sensors_data_direction_correct函数
	  sd s_data;//可以用sd sd
	  int i,j;
	  // for (i = 0; i<3; i++)
	  // {
		  // s_data.gyro[i] = 2*i;
	      // s_data.acc[i] = 3*i; 
	  // }
	  // sensors_data_direction_correct(&s_data);
	  // printf("sensors_data.gyro:%f %f %f\n", s_data.gyro[0],s_data.gyro[1],s_data.gyro[2]);
	  
	  // 测试euler_data_direction_correct函数
	  // float rot_matrix[3][3];
	  // float euler_delta[3] = {0.1,0.2,0.3};	  
	  // euler_to_rotmatrix(euler_delta, rot_matrix);
	  // for(i = 0; i<3; i++)
	  // {
		  // for(j = 0; j<3; j++)
		  // {
			  // printf("%-20.2f",rot_matrix[i][j]); 
		  // }
		  // printf("\n");
	  // }
	  // printf("end of matrix\n");
	  
	  // 测试matrix_multiply函数
	  float att_gyro[3];
	  float att_est[3] = {3,2,5};
	  // matrix_multiply(rot_matrix, att_est, att_gyro);
	  // for(i = 0; i <3; i++)
	  // {
		  // printf("%-20.2f", att_gyro[i]);
	  // }
	  // printf("\n");
	  
	  // 测试normalize函数
	  // float a[3] = {1,1,1};
	  // normalize(a);
	  // for(i = 0; i <3; i++)
	  // {
		  // printf("%-20.2f", a[i]);
	  // }
	  
	  // 测试加权
	  // att_est = (w_gyro2acc*att_gyro+sensors_data->acc)/(1+w_gyro2acc);
	  // normalize(att_est);
	  
	  // 测试calculate_rot_matrix等函数
	  float calibrated_att_init[3] = {7,-2,1};//初始化时必须有，
	  float rotmat_till_now[3][3];
	  calculate_rot_matrix(calibrated_att_init, att_est, rotmat_till_now);
	  for(i = 0; i<3; i++)
	  {
		  for(j = 0; j<3; j++)
		  {
			  printf("%-20.4f",rotmat_till_now[i][j]); 
		  }
		  printf("\n");
	  }
	  printf("end of matrix\n");
	  
	  //测试rot_matrix_to_euler函数 *****估计不准*****
	  float euler_angle[3];
      rot_matrix_to_euler(rotmat_till_now, euler_angle);
	  for(i = 0; i<3; i++)
	  {
		  printf("%-20.2f",euler_angle[i]);
	  }
	  printf("\n");
	  
	  //测试normalize函数
	  // normalize(calibrated_att_init);
	  // for(i = 0; i<3; i++)
	  // {
		  // printf("test normalize:%-20.4f\n",calibrated_att_init[i]);
	  // }
	  
	  //测试rodrigue_rotation_matrix函数
	 /*  float rot_axis[3] = {5,4,2};
	  float rot_mat[3][3];
	  rodrigue_rotation_matrix(rot_axis,37,rot_mat);
	  for(i = 0; i<3; i++)
	  {
		  for(j = 0; j<3; j++)
		  {
			  printf("%-20.4f",rot_mat[i][j]); 
		  }
		  printf("\n");
	  }
	  printf("end of matrix\n"); */
	  
	  // 测试点积和三角函数
/* 	  normalize(calibrated_att_init);
	  normalize(rot_axis);
	  printf("N1--%-20.4f", calibrated_att_init[2]);
	  printf("N2--%-20.4f", rot_axis[2]);
	  printf("dot product: %-20.4f", dot_product(calibrated_att_init, rot_axis));
	  printf("acos: %-20.4f\n",acos(dot_product(calibrated_att_init, rot_axis))); */
  }
  
  
  
  
  
  void sensors_data_direction_correct(sd* sd_data)
 {
	 float temp;
	 temp = sd_data->gyro[1];
	 sd_data->gyro[1] = sd_data->gyro[2];
	 sd_data->gyro[2] = temp;
	 
	 temp = -sd_data->acc[1];
	 sd_data->acc[1] = -sd_data->acc[2];
	 sd_data->acc[2] = temp;
	 return ;
 }
 
 
 void euler_to_rotmatrix(const float* euler_delta, float rot_matrix[3][3])
 {
	 float phi = DEG_TO_RAD * euler_delta[0];
	 float theta = DEG_TO_RAD * euler_delta[1];
	 float psi = DEG_TO_RAD * euler_delta[2];
	 
	 rot_matrix[0][0] = cos(theta)*cos(psi);
	 rot_matrix[0][1] = cos(theta)*sin(psi);
	 rot_matrix[0][2] = -sin(theta);
	 
	 rot_matrix[1][0] = sin(phi)*sin(theta)*cos(psi)-cos(phi)*sin(psi);
	 rot_matrix[1][1] = sin(phi)*sin(theta)*sin(psi)+cos(phi)*cos(psi);
	 rot_matrix[1][2] = sin(phi)*cos(theta);
	 
	 rot_matrix[2][0] = cos(phi)*sin(theta)*cos(psi)+sin(phi)*sin(psi);
	 rot_matrix[2][1] = cos(phi)*sin(theta)*sin(psi)-sin(phi)*cos(psi);
	 rot_matrix[2][2] = cos(phi)*cos(theta);
	 
	 return ;
 }
 
 
 
 
  void matrix_multiply(const float mat[3][3], const float* vec1, float* vec2)//左乘
 {
	 vec2[0] = mat[0][0]*vec1[0]+mat[0][1]*vec1[1]+mat[0][2]*vec1[2];
     vec2[1] = mat[1][0]*vec1[0]+mat[1][1]*vec1[1]+mat[1][2]*vec1[2];
	 vec2[2] = mat[2][0]*vec1[0]+mat[2][1]*vec1[1]+mat[2][2]*vec1[2];
	 return ;
 }
 
 
 
 
 
  void normalize(float* vec)
 {
	 float legth = 0;
	 int i; 
	 for(i = 0; i<3; i++)	 					 
	 {
		legth = vec[i]*vec[i]+legth;
	 }
	 float inv_norm = fast_inv_sqrt(legth);
	 for(i = 0; i<3; i++)
	 {
		vec[i] = vec[i]*inv_norm;    
	 }
 }
 
 
 
 
  float fast_inv_sqrt(const float number)
 {
    long i;
	float x2, y;
	const float threehalfs = 1.5f;

	x2 = number * 0.5f;
	y  = number;
	i  = * ( long * ) &y;                       
	i  = 0x5f3759df - ( i >> 1 );                 
	y  = * ( float * ) &i;
	y  = y * ( threehalfs - ( x2 * y * y ) );   
	//	y  = y * ( threehalfs - ( x2 * y * y ) );   
	return y;
 }
 
 
 
 
 
 void calculate_rot_matrix(float* vec1, float* vec2, float rot_matrix[3][3])//向量需要正交化，因此不能const
 {
	 normalize(vec1);
	 normalize(vec2);
	 float rot_angle = acos(dot_product(vec1, vec2));//这个不准
	 float rot_axis[3];
	 int i;
	 cross_product(vec1, vec2, rot_axis);
	 for(i = 0; i<3; i++)
	 {
		 printf("%-20.4f\n",rot_axis[i]);
	 }
	 printf("rot angle:%-20.4f\n",rot_angle);
	 rodrigue_rotation_matrix(rot_axis, rot_angle, rot_matrix);
	 return ;										
 }
 
 
 
 
 
  float dot_product(const float* vec1, const float* vec2)
 {
	 int i;
	 float dp = 0;
	 for (i = 0; i<3; i++)
	 {
		dp = vec1[i]*vec2[i]+dp;
	 }
	 return dp;
 }
 
 
 
 
 
 
  void cross_product(const float* vec1, const float* vec2, float* cp)
 {
	 cp[0] = vec1[1]*vec2[2]-vec1[2]*vec2[1];
	 cp[1] = vec1[2]*vec2[0]-vec1[0]*vec2[2];
	 cp[2] = vec1[0]*vec2[1]-vec1[1]*vec2[0];
	 return ;
 }
 
 
 
 
 
 
 
 void rodrigue_rotation_matrix(float* rot_axis, const float rot_angle, float rot_matrix[3][3])
{
	normalize(rot_axis);
	
	float w1 = rot_axis[0];
	float w2 = rot_axis[1];
	float w3 = rot_axis[2];
	float cos_theta = cos(rot_angle);
	float sin_theta = sin(rot_angle);
	
	rot_matrix[0][0] = w1*w1*(1-cos_theta)+cos_theta;
	rot_matrix[0][1] = w1*w2*(1-cos_theta)-w3*sin_theta;
	rot_matrix[0][2] = w1*w3*(1-cos_theta)+w2*sin_theta;
	
	rot_matrix[1][0] = w2*w1*(1-cos_theta)+w3*sin_theta;
	rot_matrix[1][1] = w2*w2*(1-cos_theta)+cos_theta;
	rot_matrix[1][2] = w2*w3*(1-cos_theta)-w1*sin_theta;
	
	rot_matrix[2][0] = w1*w3*(1-cos_theta)-w2*sin_theta;
	rot_matrix[2][1] = w2*w3*(1-cos_theta)+w1*sin_theta;
	rot_matrix[2][2] = w3*w3*(1-cos_theta)+cos_theta;
	
	return ;
}
 
 
 
 
 
 
 void rot_matrix_to_euler(float R[3][3], float* euler_angle)
{
	
	float theta = atan2_numerical(-R[0][2], 1/fast_inv_sqrt(R[0][0]*R[0][0]+R[0][1]*R[0][1]));
	float psi = atan2_numerical(R[0][1], R[0][0]);
	float phi = atan2_numerical(R[1][2], R[2][2]);
	euler_angle[0] = phi;
	euler_angle[1] = theta;
    euler_angle[2] = psi;
	return ;
}
 
 
 
 
 
 
 
 float atan2_numerical(float y, float x)     
{
	float z = y/x;
	float a;
  if (abs_c_float_version(y) < abs_c_float_version(x))											
  {
     a = 57.3 * z / (1.0f + 0.28f * z * z); 
   if (x<0) 
   {
     if (y<0) a -= 180; //(-pi,-pi/2)三象限，前面计算在一象限
     else 
	 {
		 a += 180;//(pi/2,pi)二象限，前面计算在四象限
	 }
   }
  } 
  else
  {
   a = 90 - 57.3 * z / (z * z + 0.28f);
   if (y<0) a -= 180;
  }
  return a;																	
}
 
 
 
 
 float abs_c_float_version(float num)//在c语言中abs输入输出都是整数，cpp中abs支持float类型
 {
	 if (num<0)
		return -num;
	else
		return num;
 }
 
 
 
 
 