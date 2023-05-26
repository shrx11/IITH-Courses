#include<stdio.h>

int main()
{
	int sum=0;
	for (int i = 0; i < 128; ++i)
  		for (int j = 0; j < 128; ++j)
    		{
    			int temp=i*10;
    			sum=temp+j;
    		}
}