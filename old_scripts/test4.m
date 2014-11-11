%% 





%%  
E = 0;
dt = 0.1; % ms 
T_stim = 3000; % in units of dt 
tau_m = 10; % ms 
tau_b = 50; % ms
%%%%%%%%%%%%%%%%%%%%% 
current = 1.8; %nA 
current2 = 1.8; 
%%%%%%%%%%%%%%%%%%%% 
I_e = [zeros(1,1000) current*ones(1,T_stim) zeros(1,1000)]; % nA 
I_e2 =[zeros(1,1000) current2*ones(1,T_stim) zeros(1,1000)]     % bc process B is negative
I_e2 = -1*I_e2;
T = length(I_e); 
V = zeros(T,1); 
B = zeros(T,1);
% Initial condition: 
V(1) = E; 
B(1) = E;
for t=1:length(I_e)-1

    V(t+1) = V(t) + dt/tau_m*(-V(t)+I_e(t));   % Process A
    B(t+1) = B(t) + dt/tau_b*(-B(t)+I_e2(t));     % Process B

end

C=(V+B)./2;


figure(1),
title('Schmatic of Opponent Processes')
subplot(4,1,1) 
plot([(1:length(I_e))*dt],V,'LineWidth',2); 
xlabel('time') 
title('primary affective response')  
%title(['Ie = ' num2str(current) ' nA '; 'Firing Rate = ' num2str(avg_freq) 'Hz'; 
%'Theoretical Firing Rate = ' num2str(th_avg_freq) 'Hz'],'FontSize',10); 
%set(gca,'FontSize',16); 

subplot(4,1,2) 
plot([(1:length(I_e))*dt],B,'LineWidth',2); 
title('opponent response') 

subplot(4,1,3) 
plot([(1:length(I_e))*dt],C,'LineWidth',2); 
title('resulting response')

subplot(4,1,4) 
plot([(1:length(I_e))*dt],I_e,'LineWidth',2); ylim([0 2*current])  
xlabel('time') 
title('stimulus presentation') 


% figure(2),
% plot([(1:length(I_e))*dt],C,[(1:length(I_e))*dt],C2,'LineWidth',2);
% title('Habituation Effects')














