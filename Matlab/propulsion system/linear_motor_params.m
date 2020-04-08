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

% Iduction motor linearization parameters
L_eq = L_ls_ind + L_M_ind *(L_lr_ind)/(L_lr_ind+L_M_ind);

%% Transfer functions
% Electrical subsystem
G_flux = tf(1,[(L_ls_ind+L_M_ind)/L_M_ind r_s_ind/L_M_ind]);
G_ids = G_flux/L_M_ind;
% Mechanical subsystem
G_torque = tf(3/2*P_ind/2*L_M_ind/(L_M_ind+L_lr_ind),[L_eq r_s_ind]);
G_w = G_torque*tf(P_ind/2,[J_ind 0]);


%% State space models
% Electrical subsystem
A_e = [-r_s_ind/(L_ls_ind+L_M_ind)];
B_e = [L_M_ind/(L_ls_ind+L_M_ind)];
C_e = [1; 1/L_M_ind];
D_e = [0;0];
% Mechanical subsystem
A_m = [-r_s_ind/L_eq 0; P_ind/(2*J_ind) 0];
B_m = [3/4*P_ind*L_M_ind/(L_eq*(L_lr_ind+L_M_ind)) 0; 0  -P_ind/(2*J_ind)];
C_m = [1 0; 0 1];
D_m = [0 0; 0 0];

%% For Zhen
K_w = P_ind/(2*J_ind);
K_lambda = L_M_ind;

% From the paper block diagram
G_e = G_ids;
G_m = G_torque;
% full open loop transfer function of the flux diagram is
G_flux = G_e*K_lambda;

% PI controllers
% PI_lambda 
P = 1; I = 0.1;
C_flux = tf([P I],[1 0]);
% PI_Te 
P = 1; I = 1;
C_torque = tf([P I],[1 0]);
% PI_w 
P = 10; I = 10;
C_w = tf([P I],[1 0]);

%% Closed loops 
% Flux loop
G_flux_cl = feedback(C_flux*G_flux,1);
% Angular velocity closed loop
G_w_cl = feedback(C_w*feedback(C_torque*G_m,1)*tf(K_w,[1 0]),1);

