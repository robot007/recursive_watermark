%% Plotting script made to plot and save figures for the paper. 
% It uses currents and compar structures from the sinks of the
% linear_motor.slx model
% It outputs the figure pdf files in figures folder

d = dir;
location = strcat(d(1).folder,'\figures');
sufix = 'delay_attack_on_current_idq_14ms';

%% linear and nonlinear comparison of motor currents
h = figure(651)
subplot(2,1,1)
plot(currents.time,currents.signals(1).values,'LineWidth',1.5)
legend('i_{qs} nonlinear','i_{qs} linear');
% plot(currents.time,currents.signals(1).values(:,2),'LineWidth',1.5)
% legend('i_{qs} linear');
xlabel('Time [s]')
ylabel('Current [A]')
subplot(2,1,2)
plot(currents.time,currents.signals(2).values,'LineWidth',1.5)
legend('i_{ds} nonlinear','i_{ds} linear');
% plot(currents.time,currents.signals(2).values(:,2),'LineWidth',1.5)
% legend('i_{ds} linear');
xlabel('Time [s]')
ylabel('Current [A]')

set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,strcat(location,'\currents_',sufix),'-dpdf','-r0')

%% linear and nonlinear comparison of motor velocities
h=figure(652)
subplot(2,1,1)
title('aa')
plot(compar.time,compar.signals(2).values,'LineWidth',1.5)
legend('\omega nonlinear','\omega linear', '\omega set point',[315 100 30 250]);
% plot(compar.time,compar.signals(2).values(:,2:3),'LineWidth',1.5)
% legend('\omega linear', '\omega set point',[315 100 30 250]);
xlabel('Time [s]')
ylabel('Velocity [1/s]')
subplot(2,1,2)
plot(compar.time,compar.signals(3).values,'LineWidth',1.5)
legend('\lambda_{dr} nonlinear','\lambda_{dr} linear', '\lambda_{dr} set point');
% plot(compar.time,compar.signals(3).values(:,2:3),'LineWidth',1.5)
% legend('\lambda_{dr} linear', '\lambda_{dr} set point');
xlabel('Time [s]')
ylabel('Flux [Wb]')
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,strcat(location,'\comparison_',sufix),'-dpdf','-r0')

%% linear and nonlinear comparison of motor velocities
h = figure(653)
subplot(2,1,1)
plot(compar.time,compar.signals(2).values,'LineWidth',1.5)
legend('\omega nonlinear','\omega linear', '\omega set point',[315 100 30 250]);
% plot(compar.time,compar.signals(2).values(:,2:3),'LineWidth',1.5)
% legend('\omega linear', '\omega set point',[315 100 30 250]);
xlabel('Time [s]')
ylabel('Velocity [1/s]')
subplot(2,1,2)
plot(currents.time,currents.signals(1).values,'LineWidth',1.5)
legend('i_{qs} nonlinear','i_{qs} linear');
% plot(currents.time,currents.signals(1).values(:,2),'LineWidth',1.5)
% legend('i_{qs} linear');
xlabel('Time [s]')
ylabel('Current [A]')
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,strcat(location,'\mechanical_',sufix),'-dpdf','-r0')


%% linear and nonlinear comparison of motor fluxes
h=figure(654)
subplot(2,1,1)
plot(compar.time,compar.signals(3).values,'LineWidth',1.5)
legend('\lambda_{dr} nonlinear','\lambda_{dr} linear', '\lambda_{dr} set point');
% plot(compar.time,compar.signals(3).values(:,2:3),'LineWidth',1.5)
% legend('\lambda_{dr} linear', '\lambda_{dr} set point');
xlabel('Time [s]')
ylabel('Flux [Wb]')
subplot(2,1,2)
plot(currents.time,currents.signals(2).values,'LineWidth',1.5)
legend('i_{ds} nonlinear','i_{ds} linear');
% plot(currents.time,currents.signals(2).values(:,2),'LineWidth',1.5)
% legend('i_{ds} linear');
xlabel('Time [s]')
ylabel('Current [A]')
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,strcat(location,'\electrical_',sufix),'-dpdf','-r0')

