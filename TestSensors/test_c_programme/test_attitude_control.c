#include "test_attitude_estimate.h"






void attitude_control(const ad attitude_data, const float reference, int* output)
{
	float K = 40;					//内环大增益很快收敛
	float Kp = 14.14;
	float tauI = 0.1414;
	T = 0.2;						//应该使用当前的执行时间
	float error_o[4] = {0,0,0,0};	//外环偏差值，用于数据记录并分析
	float error_i[4] = {0,0,0,0};
	float u_o; 						//外环输出，作为内环参考
	float u_i[4];
	short i = 0;
	
	/*角度,角速度数据->内外环输出量*/
	for(i = 0; i<2; i++)			//滚转 俯仰轴
	{
		error_o[i] = reference[i]-attitude_data.euler_angle[i];
		p_term = -Kp*attitude_data.euler_angle[i];
		i_term = i_term+Kp/tauI*error_o[i]*T;
		u_o = p_term+i_term;
		error_i[i] = u_o - attitude_data.angle_rate[i];
		output[i] = K*error_i[i];
	}
	/*外环输出量->四个电机映射mix_table*/
	if(i = 2)
	{
		error_i[i] = reference[i]-attitude_data.angle_rate[i];
		output[i] = K*error_i[i];
	}	
	else if(i = 3)
	{
		output[i] = reference[i];//当前没有定高功能
	}
	//这块应该加上抗积分饱和
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



