%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Numerical integration of I&F neuron: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
dt = 0.1; % ms 
T_stim = 3000; % in units of dt 
tau_m = 10; % ms 
E = -70; % mV 
R_m = 10; % MOhm 
V_th = -54; % mV 
V_reset = -80; % mV 
%%%%%%%%%%%%%%%%%%%%% 
current = 1.8; %nA 
%%%%%%%%%%%%%%%%%%%% 
I_e = [zeros(1,1000) current*ones(1,T_stim) zeros(1,1000)]; % nA 
T = length(I_e); 
V = zeros(T,1); 
% Initial condition: 
V(1) = E; 
for t=1:length(I_e)-1 
if V(t) >= V_th % Spike 
V(t) = 40; 
V(t+1) = V_reset; 
else 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% METHOD 1: Numerical integration with Euler Method: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%V(t+1) = V(t) + dt/tau_m*(E-V(t)+R_m*I_e(t)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% METHOD 2: Numerical integration with equation derived in class: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
V(t+1) = E + R_m*I_e(t) + (V(t)-E-R_m*I_e(t))*exp(-dt/tau_m); 
end 
end 
% Average frequency: 
avg_freq = length(find(V(1000:1000+T_stim)>=40))/(T_stim*dt)*1000; % Hz 
% Theoretical average frequency: 
th_avg_freq = 1000/(tau_m * (log((R_m*current + E - V_reset)/(R_m*current + E - V_th)))); % Hz 
%%%%%%%%%%%%% 
% Plot 
%%%%%%%%%%%%% 
subplot(2,1,1) 
plot([(1:length(I_e))*dt],V,'LineWidth',2); 
title(['Ie = ' num2str(current) ' nA; ' 'Firing Rate = ' num2str(avg_freq) 'Hz; ' ' Theoretical Firing Rate = ' num2str(th_avg_freq) ' Hz'],'FontSize',10); 
set(gca,'FontSize',16); 
xlabel('ms') 
ylabel('mV') 
subplot(2,1,2) 
plot([(1:length(I_e))*dt],I_e,'LineWidth',2); ylim([0 2*current]) 
set(gca,'FontSize',16); 
xlabel('ms') 
ylabel('nA') 
