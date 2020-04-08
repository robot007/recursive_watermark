
/**
watermark_test_functions.c 

This is an implementation of the following paper and released as Open Source Software under the MIT license. Please cite the following paper if you found the code useful. Thanks.


@Article{SongRWM2020,
  author   = {Z. {Song} and A. {Skuric} and K. {Ji}},
  title    = {A Recursive Watermark Method for Hard Real-Time Industrial Control System Cyber-Resilience Enhancement},
  journal  = {IEEE Transactions on Automation Science and Engineering},
  year     = {2020},
  pages    = {1-14},
  issn     = {1558-3783},
  doi      = {10.1109/TASE.2019.2963257},
  url 	   = {https://github.com/robot007/recursive_watermark},
  abstract = {Cybersecurity is of vital importance to industrial control systems (ICSs), such as ship automation, manufacturing, building, and energy automation systems. Many control applications require hard real-time channels, where the delay and jitter are in the levels of milliseconds or less. To the best of our knowledge, no encryption algorithm is fast enough for hard real-time channels of existing industrial fieldbuses and, therefore, made mission-critical applications vulnerable to cyberattacks, e.g., delay and data injection attacks. In this article, we propose a novel recursive watermark (RWM) algorithm for hard real-time control system data integrity validation. Using a watermark key, a transmitter applies watermark noise to hard real-time signals and sends through the unencrypted hard real-time channel. The same key is transferred to the receiver by the encrypted nonreal-time channel. With the same key, the receiver can detect if the data have been modified by the attackers and take action to prevent catastrophic damages. We provide analysis and methods to design proper watermark keys to ensure reliable attack detection. We use a ship propulsion control system for the simulation-based case study, where our algorithm smoothly shuts down the system after attacks. We also evaluated the algorithm speed on a Siemens S7-1500 programmable logic controller (PLC). This hardware experiment demonstrated that the RWM algorithm takes about 2.8 μs to add or validate the watermark noise on one sample data point. As a comparison, common cryptic hashing algorithms can hardly process a small data set under 100 ms. The proposed RWM is about 32 to 1375 times faster than the standard approaches.},
  keywords = {Cyber resilience;cyber security;delay attack;industrial control system (ICSs);Internet of Things (IoT);watermark.}
}

(The MIT License)

Copyright (c) 2018, author name [author email] and others contributors.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction, 
including without limitation the rights to use, copy, modify, merge, publish, distribute, 
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or 
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**/

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/time.h>
#include <math.h>

// If you 


// Different random noise parameters, i.e., the watermark key in the paper.
// NOTE: this file is used for a PC-based testing. It is not a TIA portal project
// for a PLC-based programming. You can add the following code to an ODK (Open Development 
// Kit) and call the ODK function a PLC application. 

/*int base = 31; //Base
int m = 4;  // degree
int poly_w[9] = {9,2,0,0,0,0,0,0,0};//polynomial values
int reg[9] = {1,1,1,1,1,1,1,1,1};    // seed value
*/

/*int base = 5; //Base
int m = 4;  // degree
int poly_w[9] = {3,1,0,3,0,0,0,0,0};//polynomial values
int reg[9] = {1,1,1,1,1,1,1,1,1};    // seed value
*/

int base = 5; //Base
int m = 9;  // degree
int poly_w[9] = {3,1,0,0,0,0,0,0,3}; //polynomial values
int reg[9] = {1,1,1,1,1,1,1,1,1};    // seed value

// Lookup table parameters
int dict_len = 1000;
double hash_noise[1000]={0};
double random_noise[1000]={0};


// chi2 detector parameters
int w = 10; // Window size
double v = 1; // variance
double s[50] = {0};
double s_est[50] = {0};


/*
* Convenience function for elapsed time calculation
*/
double time_diff(struct timeval x , struct timeval y)
{
	double x_ms , y_ms , diff;

	x_ms = (double)x.tv_sec*(uint64_t)1000000 + (double)x.tv_usec;
	y_ms = (double)y.tv_sec*(uint64_t)1000000 + (double)y.tv_usec;

	diff = (double)y_ms - (double)x_ms;

	return diff;
}


/**
 * Function calculating hashing noise from the input value x
 * The output of the system is x + hash(x)
 */
double hashingNoiseAdder(double x){

	double max = 1.0;

	int id = (int)((x + max)*2*max*dict_len) % dict_len + 1;
	return hash_noise[id];
}


/**
 * Function scalling the input int number x =[0,..,base] to double output [-1,1]
 */
double scaleNoise(double x,double base){

	return x / (base - 1)*2 -1 ;
}

/**
 * Function generating pseudo random noise and adding it to the input signal x
 */
double radnomNoiseAdderOnline(double x){

	int n_val = 0;
	// Calculate next value of the noise
	for(int k = 0; k < m; k++){
		n_val += poly_w[k]*reg[k];
	}
	n_val = (n_val + base) % base;

	// Shift the register
	for(int k = m-1; k > 0; k--){
	  reg[k] = reg[k-1];
	}
	reg[0] = n_val;

	// Scale the noise to [-1,1] and add it to the signal
	return x + (double)scaleNoise(n_val,base);
}

/**
 * Function getting pseudo ranom noise from lookup table and adding it to input x
 */
double radnomNoiseAdderOffline(double x){
	return x + random_noise[(int)x % dict_len];
}

/**
 * Function calculating chi^2 detector for given input signal x
 */
double chi2Detector(double x){

	// prepare for calculation
	for(int i = w-1; i > 0; i--){
		s_est[i] = s_est[i-1];
		s[i] = s[i-1];
	}

	// state estimation
	s_est[0] = s[1] + (s[1] - s[2]);
	s[0] = x;

	// chi2 detector calculation
	double chi2 = 0;
	for(int i =0; i < w; i++){
		chi2 += 1/v *pow(s[i]-s_est[i],2);
	}
	return chi2;

}



int main(int argc, char* argv[]) {

    struct timeval before , after;
    gettimeofday(&before , NULL);

	const int loopNum = 10000000; 
	// const int loopNum = 1000;  // for quick test

	for(int i =0; i < loopNum; i++){
		hashingNoiseAdder( 1234.56 );
		radnomNoiseAdderOffline( (double)i );
		//radnomNoiseAdderOnline((double) i);
		//chi2Detector((double) i);
	}
    gettimeofday(&after , NULL);

	printf("%.2f micros\n",time_diff(before , after));
}


