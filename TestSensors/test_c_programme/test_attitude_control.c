#include <stdio.h>
/* 使用开发人员命令提示注意
 * 不支持的变量类型 int16_t等
 * 头文件不要随便引用，不要随便少
 * 声明直接用[]的，少用*以防出错
 * 不要使用未给出的指针便来那个
 *
**/

typedef struct{
	float euler_angle[3];
	float angle_rate[3];
}ad;

void attitude_control(ad , const float reference[4], int output[4]);//还是这种声明方式比指针形式好

int main()
{
   const float reference[4] = {1,1,1,1};
   int output[4];//
   ad attitude_data;
   short i;
   for(i=0; i<3; i++)
   {
	  attitude_data.euler_angle[i] = 0;
      attitude_data.angle_rate[i] = 0;
   }

   for(i=0; i<100; i++)
   {
	   attitude_control(attitude_data, reference, output);
   }	   
}



void attitude_control(ad attitude_data, const float reference[4], int output[4])
{
	float K = 40;															
	float Kp = 14.14;
	float tauI = 0.1414;
	float T = 0.02;														
	float error_i = 0;
	static float euler_angle_pre[2] = {0,0};  //这个东西好像没更新过
	float p_term, i_term;
	static float u_o_pre[2] = {0,0};
	float u_o[2];
	short i;
	const int output_limit=20000; 
	
	//Roll Pitch
	for (i=0; i<2; i++)
	{
		p_term = Kp*(-attitude_data.euler_angle[i]+euler_angle_pre[i]);
		i_term = Kp/tauI*(reference[i]-attitude_data.euler_angle[i])*T;
		u_o[i] = p_term+i_term+u_o_pre[i];

		error_i = u_o[i]-attitude_data.angle_rate[i];
		output[i] = K*error_i; 	
		
		euler_angle_pre[i] = attitude_data.euler_angle[i];//补充
		if(output[i] > output_limit)
			output[i] = output_limit;
		else if(output[i] < -output_limit)
			output[i] = -output_limit;
		else
			u_o_pre[i] = u_o[i];//超出限制，不更新u_o_pre
	}

	

	error_i = reference[2]-attitude_data.angle_rate[2];
	output[2] = K*error_i;
	output[3] = reference[3];

	printf("Refer  Signal (----): %.2f%s%.2f%s%.2f%s%.2f%s",reference[0], "    ",reference[1], "    ",reference[2], "      ", reference[3], "\n"); 
	printf("Output Signal (----): %d%s%d%s%d%s%d%s",output[0], "               ",output[1], "               ",output[2], "               ", output[3], "                    \n");

	
	
}







void set_reference(const int* rc_commands, float* reference)
{
	short deg_lim = 20;										//u8 总限制范围：-20~20度
	float deg_per_signal = 2*deg_lim/2000; 					//每单位信号量对应的角度
	
	reference[0] = (rc_commands[0]-1000)*deg_per_signal;    //1副翼2升降3油门4方向
	reference[1] = (rc_commands[1]-1000)*deg_per_signal;
	reference[2] = (rc_commands[3]-1000)*deg_per_signal;    //磁罗盘没调通
	reference[3] = rc_commands[2];        					//高度参考
}



