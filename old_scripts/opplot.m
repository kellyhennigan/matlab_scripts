%% Opponent Process response 

E = 0;
dt = 0.1; % ms 
T_stim = 3000; % in units of dt 
tau_a = 10; % ms 
tau_b = 50; % ms
%%%%%%%%%%%%%%%%%%%%% 
current = 1.8; %nA 
%%%%%%%%%%%%%%%%%%%% 
Ie = [zeros(1,1000) current*ones(1,T_stim) zeros(1,1000)]; % nA 
Ie_b = -1*Ie;      % bc process B is negative
T = length(Ie); 
V = zeros(T,1); 
B = zeros(T,1);    % voltage for process B

% Initial condition: 
V(1) = E; 
B(1) = E;
for t=1:length(Ie)-1
    V(t+1) = V(t) + dt./tau_a * (E - V(t) + Ie(t));   % process A
    B(t+1) = B(t) + dt./tau_b * (E - B(t) + Ie_b(t));   % process B
end
both=(V+B)./2;

figure(1),
title('Schematic of Opponent Processes')
subplot(4,1,1) 
plot([(1:length(Ie))*dt],V,'LineWidth',2); 
xlabel('time') 
title('primary affective response')  

subplot(4,1,2) 
plot([(1:length(Ie))*dt],B,'LineWidth',2); 
title('opponent response') 

subplot(4,1,3) 
plot([(1:length(Ie))*dt],both,'LineWidth',2); 
title('resulting response')

subplot(4,1,4) 
plot([(1:length(Ie))*dt],Ie,'LineWidth',2); ylim([0 2*current])  
xlabel('time') 
title('stimulus presentation') 











