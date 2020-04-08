
Matlab code information
===================

Models
--------------
####  profinet_simulation_ss_separated.slx

Complete Networked Control System simulation.  
 The simulation consists of:

 - State space model of plant
 - Sensor device
	 - **Smart Pseudo Random M-sequence Noise**
	 - Quantization
	 - PROFINET interface 
 - Actuator device
	 -  PROFINET interface  
 - Controller Device
	 - State Space Controller 
	 - Time-Delay estimation
	 - PROFINET interface  
 - **PROFINET network**
	 - Stohastic package delivery time
	 - Package loss
	 - Man in the middle attack simulation RT and IRT channel 

##### Running

 - Run  motor.m
 - Run simulation

----------
####   simplified.mdl

Simplified delay attack simulation used for testing the algorithms. 

##### Running
 - No initializations needed
 - **If changing plant parameters - change in Time Delay Estimation block is needed**

----------

Scripts 
-------------
#### Motor.m

Contains all the process parameters, it is important to run it before running simulation.

----------
Model Functions
-------------
**This script are here just if you don't want to open the whole model to review the algorithms used.**

####  MeasurementVerification.m 

This is a function from the *profinet_simulation_ss_separated.slx* model. It is places in Controller device and it does the verification of measurement data received from sensor. 
*To verify data it estimates time-delay of the system.*
**This script is here just if you don't want to open the whole model to review the algorithms used.**

----------
####  TimeDelayEstimationSearch_Profibus.m
This is a function from  *simplified.mdl*. I estimates the attack time-delay using **Search algorithm**. 
Two basic algorithm are used:

 - Burst sampling algorithm 
 - Weighted burst sampling algorithm, used in paper:

> System Identification and Adaptive Control Based on a Variable Regression for Systems Having Unknown Delay
> A. Elnaggar

----------
####  TimeDleayEstimationGradient.m
This is a function from  *simplified.mdl*.  I estimates the attack time-delay using Gradient algorithm. 
The algorithm is implemened using papers:
>Resilient Desing of Networked Control System Under Time Delay Switch Attack, Application in Smart Grid
>A. Sargolzaei

>   New Results on Discrete-time Delay System Identification 
>   S. Bedoui



**This script is here just if you don't want to open the whole model to review the algorithms used.**

----------



