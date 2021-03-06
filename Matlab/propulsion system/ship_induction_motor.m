%% Shyp dynamics parameters
w0 = 0.05;% [�]
X0 =16.09;% [mm]
Mb_0 =9.10e4;% [Nm]
n0 =1.67;% [s^?1]
J0 =0.93;% [�]
F0 =1.90e5;% [N]
vs_0 =6.83;% [m/s]
KT_0 =0.115;% [�]
KQ_0= 0.0245;% [�]
mship =3211000;% [kg]
Ip =68000;% [kg m2]
a = -5.4036;% [�]
b = -3.499;% [�]
p =6.58;% [�]
q =5.0245;% [�]
e =1.861;% [�]
g = -0.5816; %[�]
v = 1.9099; %[�]
Tn = 7.83; % [s]
Tv = 115.69;% [s]
Tth = 2;% [s] 
T1 = 15.93; %[s]
T2 = 1.42; %[s]
%s1 approx ?0.0233 [s?1]
%s2 approx ?0.7019 [s?1]
%s1 exact ?0.0208 [s?1] ?0.0248
%s2 exact ?0.7438 [s?1] ?0.8141

Kp = 2;
Ki = 1;

A = [ - (2-b)/Tn  -b/Tn ; (2-a)/Tv  -(e-a)/Tv];
B = [1/Tn -q/Tn; 0 p/Tv];
G = [0 b/Tn; -1/Tv -a/Tv];
C = eye(2);
D = zeros(2);

Ac = [ -(2-b-g)/Tn -b/Tn -q/Tn; (2-a)/Tv  -(e-a)/Tv p/Tv; 0 0 -1/Tth];
Bc = [v/Tn 0; 0 0; 0 1/Tth];
Gc = [0 b/Tn; -1/Tv -a/Tv; 0 0];
Cc = eye(3);
Dc = zeros(2,3);

%% Induction machine parameters
J_ind = 4.1; % kgm^2
r_s_ind = 7.6e-3; % Ohm
r_r_ind = 4.6e-3; % Ohm
L_ls_ind = 15e-3; % H
L_lr_ind = 15e-3; % H
L_M_ind = 5.2e-3; % H
P_ind = 4;

L_aq_ind = 1/(1/L_M_ind + 1/L_ls_ind + 1/L_lr_ind);
L_ad_ind = L_aq_ind;

% Flux estimation params
T_r_ind = L_lr_ind/r_r_ind;
T_s_est = 1e-2;


%% Simulation params
Ts = 1e-3;

% Iduction motor linearization
L_eq = L_ls_ind + L_M_ind *(L_lr_ind)/(L_lr_ind+L_M_ind);

% Transfer functions
G_flux = tf(1,[(L_ls_ind+L_M_ind)/L_M_ind r_s_ind/L_M_ind]);
G_ids = G_flux/L_M_ind;
G_torque = tf(3/2*P_ind/2*L_M_ind/(L_M_ind+L_lr_ind),[L_eq r_s_ind]);
G_w = G_torque*tf(P_ind/2,[J_ind 0]);


