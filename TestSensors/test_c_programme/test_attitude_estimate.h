/**
 *
 * @file attitude_estimate.c
 *
 * 
 *
 **/
//#ifndef _ATTITUDE_ESTIMATE_H
//#define _ATTITUDE_ESTIMATE_H

 
 
 
 #define DEG_TO_RAD 0.0175
 #define RAD_TO_DEG 57.3
 

 
 typedef struct sensors_data//sensors_data
{
  //u16 rc_command[4];
	//u16 motor[4];
	
	float acc[3];
    float gyro[3];
	//float temp[1];
	//float mag[3]; 
	//float press;
	
}sd;
 
 
 
 
 
 
 
//#endif
 
 
 
 
 
 
 
 
 