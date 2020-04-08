#include <iostream>
#include "md5.h"
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/time.h>
#include <math.h>


using std::cout; 
using std::endl;

/**
 * Convenience function for elapsed time calculation
 * I am not sure if this is the best approach. I am sure there can be found better ones.
 * This one even though it calculates the microseconds it has precision set to milliseconds.
 * I did not have time to investigate it much, but there are a lot of things online to use.
 */
double time_diff(struct timeval x , struct timeval y)
{
	double x_ms , y_ms , diff;

	x_ms = (double)x.tv_sec*1000000 + (double)x.tv_usec;
	y_ms = (double)y.tv_sec*1000000 + (double)y.tv_usec;

	diff = (double)y_ms - (double)x_ms;

	return diff;
}


 
int main(int argc, char *argv[])
{
    struct timeval before , after;
    const std::string str1="1234.56";
    const std::string str2="1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 ";
    gettimeofday(&before , NULL);

	const int loopNum = 1000000; 
	// const int loopNum = 1000;  // for quick test
	for(int i =0; i < loopNum; i++){
	    md5("1234.56");
		// md5("1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 1234.56 ");
	}
    gettimeofday(&after , NULL);

	printf("%.2f micros\n",time_diff(before , after));
    return 0;
}