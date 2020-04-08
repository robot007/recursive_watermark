%% PROFINET network simulation necessary parameters

% Global sampling time of simulation, it doesn't have much to do with
% PROFIBUS itself
Ts = 1e-4;

% Soft Real Time sampling time. Dtaa sent by SRT channel is encrypted and
% cannot be intercepted by attacker and it used to prevent and discover
% intruders
Ts_SRT = 1e-1;

% Real Time Chanels of PROFIBUS ar two high frequency channels with low
% level of jutter and their samplig times are in range of 100us to 10ms 
% Real Time Channel
Ts_RT = 1e-3;
% Isosynchronious Real Time Channel
Ts_IRT = 1e-4;


%% DC motor parameters 
% J and L parameters have direct effect on motor tranzient
J = 0.6284E-4;
L = 1.75E-4;
% b, R and K have direct effect to stationary state of the motor
b = 3.5077E-6;
K = 0.0274;
R = 4;

% System state space matrices
A = [0 1 0;
0 -b/J K/J;
0 -K/L -R/L];
B = [0 ; 0 ; 1/L];
C = [1 0 0];
D = [0];
G = ss(A,B,C,D);
% ZOH Discretisation 
Gd = c2d(G,Ts_RT,'zoh');
% Simple optimal LQR controller wih infinite horizon
K = dlqr(Gd.a,Gd.b,diag([1,1,1]),1);


% Initial condition
% Xo = [ Ia(0) Theta(0) Theta'(0)]
Xo = [1 0 0];
