# Ship propulsion system

- Ship propulsion system is **inherently nonlinear**.
- The propulasion system is based on **FOC controlled electrical induction motor** linearized uzin input output linearization procedure - nonlinear controller. 
	Most important used papers are: 
 - "Simulation of symetric induction machinery" by P.C.Krause et al.
 - *"Control of Induction Motors for both High Dynamic Performance and High Power Efficiency" by Gyu-Sik Kim el al.*
- Ship propulsion system is linearized based on the journal paper 
 - *"Linearization of a ship propulsion system model" by D.Stapersma and A. Vrijdag*

#### Simulation files in the directory
- lin_propulsion.slx
	-	Simulation of (per unit) linearized ship propulsion system based on previously mentioned paper.
- linear_motor.slx
	-	Simulaiton of linearized induction motor based on previously mentioned papers. 
		-	The simulation offers **compariosn of nonlinear model dynamics and linear dynamics**.
		- The intended purpose is to test robust control principles on linearized model.
- ship_induction_motor_propulsion_extended_linear.slx
	-	Coprehensive simulaiton of complete linearized ship propulsion system with induction motor included. 
		- **Simulation includes man in the middle attack simulation**
			-	delay attack
			- 	injection attack
		- **Watermarking infrastructure for all measured variables**

