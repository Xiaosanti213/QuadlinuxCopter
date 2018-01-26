#include <iostream>


using namespace std;

float Q_rsqrt( float number )//计算的是平方分之1
{
	long i;
	float x2, y;
	const float threehalfs = 1.5F;

	x2 = number * 0.5F;
	y  = number;
	i  = * ( long * ) &y;
    //cout << i << endl;	
	i  = 0x5f3759df - ( i >> 1 );               
	y  = * ( float * ) &i; 
	y  = y * ( threehalfs - ( x2 * y * y ) );      // 第一次迭代
    y  = y * ( threehalfs - ( x2 * y * y ) );      // 第二次迭代

	return y;
}



int main()
{
	float num = 0.04;
	float sqrt_25num;
	cout << "Sqrt of number 25 is" << endl;
	sqrt_25num = Q_rsqrt(num);
	cout << sqrt_25num << endl;
}








