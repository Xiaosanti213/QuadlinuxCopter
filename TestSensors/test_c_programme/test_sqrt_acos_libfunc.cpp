#include <iostream>
#include <cmath>
#include <cstdio>


using namespace std;
float atan2_numerical(float, float);


int main()
{
	float z = atan2_numerical(-0,1);
	float z1 = atan2(-0,0);
	cout << z1 << "\n" << z << endl;
	cout << "This is the result\n";
	//cout << sqrt(25) << endl;
	//cout << acos(sqrt(3)/2)*180/3.1416 << endl;
	cout << (abs(-0.91240430)) << endl;
	float a = -0.91240430;
	printf("%f\n", abs(a)) ;
}



float atan2_numerical(float y, float x)
{
	float z = y/x;
	float a;
  if (abs(y) < abs(x))//
  {
     a = 57.3 * z / (1.0f + 0.28f * z * z);
   if (x<0) 
   {
     if (y<0) a -= 180;
     else a += 180;
   }
  } 
  else
  {
   a = 90 - 57.3 * z / (z * z + 0.28f);
   if (y<0) a -= 180;
  }
  return a;
}









