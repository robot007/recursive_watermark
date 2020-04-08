close all;
%% Induction machine parameters
% J_ind = 4.1; % kgm^2
range=15;
J_ind = ureal('J_ind',4.1,'Percentage',range); % kgm^2
r_s_ind = ureal('r_s_ind', 7.6e-3, 'Percentage', range); % Ohm
r_r_ind = ureal('r_r_ind', 4.6e-3, 'Percentage', range); % Ohm
L_ls_ind = ureal('L_ls_ind',15e-3, 'Percentage',range); % H
L_lr_ind = ureal('L_lr_ind',15e-3, 'Percentage',range); % H
L_M_ind = ureal('L_M_ind',5.2e-3, 'Percentage',range); % H
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


tf(G_w.NominalValue)


figure(1)
subplot(2,1,1)
bode(G_ids);
title(['G_{ids} Bode plot with ', num2str(range), '% error']);
subplot(2,1,2)
bode(G_w);
title(['G_w open Bode plot with ', num2str(range), '% error']);
set(gcf, 'Position', [488.2000  223.4000  579.2000  634.4000]);
print('-depsc', 'BodePlot.eps');
print('-dpng', 'BodePlot.png');
saveas(gcf,'BodePlot','fig');

figure(2)
subplot(2,1,1)
nyquist(G_ids);
title(['G_{ids} Nyquist plot with ', num2str(range), '% error']);
subplot(2,1,2)
nyquist(G_w);
title(['G_w open Nyquist plot with ', num2str(range), '% error']);
set(gcf, 'Position', [488.2000  223.4000  579.2000  634.4000]+[10 10 0 0]);
print('-depsc', 'NyquistPlot.eps');
print('-dpng', 'NyquistPlot.png');
saveas(gcf,'NyquistPlot','fig');

% %% State space models
% % Electrical subsystem
% A_e = [-r_s_ind/(L_ls_ind+L_M_ind)];
% B_e = [L_M_ind/(L_ls_ind+L_M_ind)];
% C_e = [1; 1/L_M_ind];
% D_e = [0;0];
% % Mechanical subsystem
% A_m = [-r_s_ind/L_eq 0; P_ind/(2*J_ind) 0];
% B_m = [3/4*P_ind*L_M_ind/(L_eq*(L_lr_ind+L_M_ind)) 0; 0  -P_ind/(2*J_ind)];
% C_m = [1 0; 0 1];
% D_m = [0 0; 0 0];