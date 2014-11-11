function HHmodel() 
% PARAMETERS 
% TIME 
T = 50; dt=.01;t = 0:dt:T; 
% Membrane parameters 
V=zeros(size(t)); 
n=zeros(size(t)); 
m=zeros(size(t)); 
h=zeros(size(t)); 
gL = 3; %microS/mm^2 
gK = 360; %microS/mm^2 
gNa = 1200; %microS/mm^2 
EL = -54.387; %mV 
EK = -77; %mV 
ENa = 50; %mV 
cm = 10; %nF/A 
taun=zeros(size(t)); 
taum=zeros(size(t)); 
tauh=zeros(size(t)); 
aln=zeros(size(t)); 
alm=zeros(size(t)); 
alh=zeros(size(t)); 
bn=zeros(size(t)); 
bm=zeros(size(t)); 
bh=zeros(size(t)); 
im =zeros(size(t)); 
% Input Current 
I=ones(size(t))*200; %200nA/mm^2 
% INITIAL CONDITIONS 
V(1) = -65; 
m(1) = 0.0529; 
h(1) = 0.5961; 
n(1) = 0.3177; 
%1
for i = 1:length(t)-1 
% Update input current 
im(i) = gL*(V(i) - EL) + gK*(n(i)^4)*(V(i) - EK) + gNa*m(i)^3*h(i)*(V(i) - ENa); 
% Update membrane voltage 
V(i+1) = V(i) + (dt/cm)*(-im(i) + I(i)); 
% UPDATE CHANNELS 
% DEFINE ALPHA AND BETA 
if(abs(V(i) +55) <= 1e-6) 
aln(i) =.1; 
else 
aln(i) = .01*(V(i) + 55)/( 1 - exp(-.1*(V(i)+55))); 
end 
if( abs(V(i) +40) <= 1e-6) 
alm(i) =1; 
else 
alm(i) = .1*(V(i) + 40)/( 1 - exp(-.1*(V(i)+40))); 
end 
% Determine kinetic variables 
bn(i) = 0.125*exp(-0.0125*(V(i)+65)); 
bm(i) = 4*exp(-0.0556*(V(i)+65)); 
bh(i) = 1/( 1 + exp(-.1*(V(i)+35))); 
alh(i) = .07*exp(-0.05*(V(i)+65)); 
taun(i) = 1/(aln(i) + bn(i)); 
taum(i) = 1/(alm(i) + bm(i)); 
tauh(i) = 1/(alh(i) + bh(i)); 
% UPDATE TRANSITION PROBABILITIES 
n(i+1) = n(i) + (dt/taun(i))*( - n(i) + aln(i)/( aln(i)+bn(i)) ); 
m(i+1) = m(i) + (dt/taum(i))*( - m(i) + alm(i)/( alm(i)+bm(i)) ); 
h(i+1) = h(i) + (dt/tauh(i))*( - h(i) + alh(i)/( alh(i)+bh(i)) ); 
end 
im(i+1) = gL*(V(i) - EL) + gK*(n(i)^4)*(V(i) - EK) + gNa*m(i)^3*h(i)*(V(i) - ENa); 
% PLOTTTING 
figure(1);hold on; 
plot(t,V);xlabel('time [ms]','FontSize',15);ylabel('Voltage [mV]','FontSize',15); 
title('HH response to 200nA/mm^2 of injected current','FontSize',15) 
figure(2);hold on; 
subplot(3,1,1) 
plot(t,n);xlabel('time [ms]','FontSize',15);ylabel('n','FontSize',15); 
subplot(3,1,2);hold on; 
plot(t,m);xlabel('time [ms]','FontSize',15);ylabel('m','FontSize',15); 
subplot(3,1,3); hold on; 
%2
plot(t,h);xlabel('time [ms]','FontSize',15);ylabel('h','FontSize',15); 
% figure(3);hold on; 
% plot(t,im) 
% 
%b.) HH model has a discontinuity in the FI curve. This is not the case for the 
%IF model. 
%Sample Code 
% function HHmodel() 
%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%****TIME****** 
% T = 1000; dt=.01;t = 0:dt:T; 
% %*****Membrane parameters*** 
% V=zeros(size(t)); 
% n=zeros(size(t)); 
% m=zeros(size(t)); 
% h=zeros(size(t)); 
% gL = 3; %microS/mm^2 
% gK = 360; %microS/mm^2 
% gNa = 1200; %microS/mm^2 
% EL = -54.387; %mV 
% EK = -77; %mV 
% ENa = 50; %mV 
% cm = 10; %nF/A 
% taun=zeros(size(t)); 
% taum=zeros(size(t)); 
% tauh=zeros(size(t)); 
% aln=zeros(size(t)); 
% alm=zeros(size(t)); 
% alh=zeros(size(t)); 
% bn=zeros(size(t)); 
% bm=zeros(size(t)); 
% bh=zeros(size(t)); 
% im =zeros(size(t)); 
% %*********Input Current********** 
% A=0:10:500; %200nA/mm^2 
% rate = zeros(size(A)); 
% Spikecount =0; 
% %3
% %**********INITIAL CONDITIONS 
% V(1) = -65; 
% m(1) = 0.0529; 
% h(1) = 0.5961; 
% n(1) = 0.3177; 
% for j =1: length(A) 
% I=ones(size(t))*A(j); %200nA/mm^2 
% for i = 1:length(t)-1 
% im(i) = gL*(V(i) - EL) + gK*(n(i)^4)*(V(i) - EK) + gNa*m(i)^3*h(i)*(V(i) - ENa); 
% V(i+1) = V(i) + (dt/cm)*(-im(i) + I(i)); 
% % Spike Counter 
% if(V(i+1) >-40 & V(i) < -40) 
% Spikecount = Spikecount +1; 
% end 
% %%%UPDATE PROTEIN CHANNELS 
% %%%%DEFINE ALPHA AND BETA 
% if(abs(V(i) +55) <= 1e-6) 
% aln(i) =.1; 
% else 
% aln(i) = .01*(V(i) + 55)/( 1 - exp(-.1*(V(i)+55))); 
% end 
% if(abs(V(i) +40) <= 1e-6) 
% alm(i) =1; 
% else 
% alm(i) = .1*(V(i) + 40)/( 1 - exp(-.1*(V(i)+40))); 
% end 
% bn(i) = 0.125*exp(-0.0125*(V(i)+65)); 
% bm(i) = 4*exp(-0.0556*(V(i)+65)); 
% bh(i) = 1/( 1 + exp(-.1*(V(i)+35))); 
% alh(i) = .07*exp(-0.05*(V(i)+65)); 
% taun(i) = 1/(aln(i) + bn(i)); 
% taum(i) = 1/(alm(i) + bm(i)); 
% tauh(i) = 1/(alh(i) + bh(i)); 
% %***%*%**%*%*%*%*%*%*% 
% %%%%%%%%%%%UPDATE TRANSITION PROBABILITIES 
% n(i+1) = n(i) + (dt/taun(i))*( - n(i) + aln(i)/( aln(i)+bn(i)) ); 
% m(i+1) = m(i) + (dt/taum(i))*( - m(i) + alm(i)/( alm(i)+bm(i)) ); 
% h(i+1) = h(i) + (dt/tauh(i))*( - h(i) + alh(i)/( alh(i)+bh(i)) ); 
% end 
% 4
% im(i+1) = gL*(V(i) - EL) + gK*(n(i)^4)*(V(i) - EK) + gNa*m(i)^3*h(i)*(V(i) - ENa); 
% rate(j) = Spikecount/(0.001*T); 
% % Reset Spikecount 
% Spikecount =0; 
% end 
% %%%%%%%%%PLOTTING 
% figure(1);hold on; 
% plot(t,V);xlabel('time [ms]');ylabel('Voltage [mV]'); 
% figure(2);hold on; 
% subplot(3,1,1) 
% plot(t,n);xlabel('time [ms]');ylabel('n'); 
% subplot(3,1,2);hold on; 
% plot(t,m);xlabel('time [ms]');ylabel('m'); 
% subplot(3,1,3); hold on; 
% plot(t,h);xlabel('time [ms]');ylabel('h'); 
% figure(3);hold on; 
% plot(t,im) 
% figure(4);hold on; 
% plot(A,rate,'r:.');xlabel('Current [nA/mm^2]','FontSize',15); 
% ylabel('Firing rate [Hz] (binsize = 500ms)','FontSize',15); 
% title('FI curve for HH model','FontSize',15); 
% % c.) Neuron spikes after shutting off inhibitory input. During hyper-polarization 
% % the inactivation gating variable h increases to a large enough value so that once 
% % hyper-polarizing current is removed a sufficient number of sodium channels 
% % open for spiking to occur. 
% function HHmodel() 
% %%%%Turning off a Hyperpolarizing current causes a spike 
% %%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% %****TIME****** 
% T = 50; dt=.01;t = 0:dt:T; 
% %*****Membrane parameters*** 
% 5
% V=zeros(size(t)); 
% n=zeros(size(t)); 
% m=zeros(size(t)); 
% h=zeros(size(t)); 
% gL = 3; %microS/mm^2 
% gK = 360; %microS/mm^2 
% gNa = 1200; %microS/mm^2 
% EL = -54.387; %mV 
% EK = -77; %mV 
% ENa = 50; %mV 
% cm = 10; %nF/A 
% taun=zeros(size(t)); 
% taum=zeros(size(t)); 
% tauh=zeros(size(t)); 
% aln=zeros(size(t)); 
% alm=zeros(size(t)); 
% alh=zeros(size(t)); 
% bn=zeros(size(t)); 
% bm=zeros(size(t)); 
% bh=zeros(size(t)); 
% im =zeros(size(t)); 
% %*********Input Current********** 
% I=zeros(size(t)); %200nA/mm^2 
% I(1:5/dt +1) = -50; 
% %**********INITIAL CONDITIONS 
% V(1) = -65; 
% m(1) = 0.0529; 
% h(1) = 0.5961; 
% n(1) = 0.3177; 
% %%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% for i = 1:length(t)-1 
% im(i) = (gL*(V(i) - EL) + gK*(n(i)^4)*(V(i) - EK) + gNa*(m(i)^3)*h(i)*(V(i) - ENa)); 
% V(i+1) = V(i) + (dt/cm)*(-im(i) + I(i)); 
% %%%%DEFINE ALPHA AND BETA 
% if( abs(V(i) +55) <= 1e-6) 
% aln(i) =.1; 
% else 
% aln(i) = .01*(V(i) + 55)/( 1 - exp(-.1*(V(i)+55))); 
% end 
% if( abs(V(i) +40) <= 1e-6) 
% alm(i) =1; 
% else 
% alm(i) = .1*(V(i) + 40)/( 1 - exp(-.1*(V(i)+40))); 
% end 
% 6
% bn(i) = 0.125*exp(-0.0125*(V(i)+65)); 
% bm(i) = 4*exp(-0.0556*(V(i)+65)); 
% bh(i) = 1/( 1 + exp(-.1*(V(i)+35))); 
% alh(i) = .07*exp(-0.05*(V(i)+65)); 
% taun(i) = 1/(aln(i) + bn(i)); 
% taum(i) = 1/(alm(i) + bm(i)); 
% tauh(i) = 1/(alh(i) + bh(i)); 
% %***%*%**%*%*%*%*%*%*% 
% %%%%%%%%%%%UPDATE TRANSITION PROBABILITIES 
% n(i+1) = n(i) + (dt/taun(i))*( - n(i) + aln(i)/(aln(i)+bn(i)) ); 
% m(i+1) = m(i) + (dt/taum(i))*( - m(i) + alm(i)/(alm(i)+bm(i)) ); 
% h(i+1) = h(i) + (dt/tauh(i))*( - h(i) + alh(i)/(alh(i)+bh(i)) ); 
% end 
% i = i+1; 
% %%%%DEFINE ALPHA AND BETA 
% if(abs(V(i) +55 )<= 1e-6) 
% aln(i) = 0.1; 
% else 
% aln(i) = .01*(V(i) + 55)/( 1 - exp(-.1*(V(i)+55))); 
% end 
% if(abs(V(i) +40) <= 1e-6) 
% alm(i) =1; 
% else 
% alm(i) = .1*(V(i) + 40)/( 1 - exp(-.1*(V(i)+40))); 
% end 
% bn(i) = 0.125*exp(-0.0125*(V(i)+65)); 
% bm(i) = 4*exp(-0.0556*(V(i)+65)); 
% bh(i) = 1/( 1 + exp(-.1*(V(i)+35))); 
% alh(i) = .07*exp(-0.05*(V(i)+65)); 
% taun(i) = 1/(aln(i) + bn(i)); 
% taum(i) = 1/(alm(i) + bm(i)); 
% tauh(i) = 1/(alh(i) + bh(i)); 
% %***%*%**%*%*%*%*%*%*% 
% %im(i) = (gL*(V(i) - EL) + gNa*(m(i)^3)*h(i)*(V(i) - ENa)); 
% im(i) = gL*(V(i) - EL) + gK*(n(i)^4)*(V(i) - EK) + gNa*m(i)^3*h(i)*(V(i) - ENa); 
% i = i-1; 
% %%%%%%%%%%%UPDATE TRANSITION PROBABILITIES 
% n(i+1) = n(i) + (dt/taun(i))*( - n(i) + aln(i)/(aln(i)+bn(i)) ); 
% m(i+1) = m(i) + (dt/taum(i))*( - m(i) + alm(i)/(alm(i)+bm(i)) ); 
% h(i+1) = h(i) + (dt/tauh(i))*( - h(i) + alh(i)/(alh(i)+bh(i)) ); 
% 7
% %%%%%%%%%PLOTTTING 
% figure(1);hold on; 
% plot(t,V,'r');xlabel('time [ms]','FontSize',15); 
% ylabel('Voltage [mV]','FontSize',15);hold on; 
% figure(2);hold on; 
% subplot(3,1,1) 
% plot(t,n);xlabel('time [ms]','FontSize',15);ylabel('n','FontSize',15); 
% subplot(3,1,2);hold on; 
% plot(t,m);xlabel('time [ms]','FontSize',15);ylabel('m','FontSize',15); 
% subplot(3,1,3); hold on; 
% plot(t,h);xlabel('time [ms]','FontSize',15);ylabel('h','FontSize',15); 
% figure(3);hold on; 
% plot(t,im) 
% figure(4);hold on; 
% plot(t,I) 
% end 
% 
% 
% % 2 
% 
% % Trigger presynaptic action potentials at times 100, 200, 230, 300, 320, 400, and 
% % 410 ms. Explain what you see. 
% % Each presynaptic spike changes the neuron's conductance. One presynaptic 
% % spike is not enough to bring the membrane voltage to threshold and spike, 
% % however two presynaptic spikes which arrive within a sufficient time window, on 
% % the order of ?ex , are enough to bring the neuron to spike. Only the final inputs, 
% % at times 400 and 410 ms, arrive within a time of order ?ex and cause subsequent 
% % firing. 
% % Sample code 
% 
% 
% function LeakyIF() 
% clear all; 
% %Determines the voltage of a single compartment, leaky, neuron as a function of time. 
% %%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% %TOTAl TIME of SIMULATION (ms) 
% totaltime = 500;dt = .01; 
% 8
% %VOLTAGE units in mV 
% El = -70; Eex = 0;Vth = -54;Vreset = -80; 
% %Each element is going to hold the voltage at a dt unit of time 
% Voltage = zeros(1,totaltime/dt); 
% %MEMBRANE PARAMETERS 
% cm = 10; %membrane capacitance 
% %%Conductances and conductance decay times 
% gl=1.0; gexstart =0; gex =gexstart; deltag =.5; tauex =10; 
% %INPUT CURRENT 
% I = zeros(1,totaltime/dt); 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% %Presynaptic Action Potential arrival times 
% Pret = [100,200,230,300,320,400,410]; 
% tspike =100; 
% spikecounter = 1; 
% %%%%%%%%%%%%%%%%%%%%INITIAL CONDITIONS%%%%%%% 
% Voltage(1,1) = El; 
% I(1,1) = El*gex; 
% time = 0:dt:totaltime;counter = 1;%Time vector 
% %%%%%%%%%%%%%%time loop%%%%%%%%%%%%%%%%%%%%%% 
% while ( time(counter) <= totaltime-dt ) 
% %%%%CHECK IF A PRESYNAPTIC SPIKE HAS OCCURRED%%%%%%%% 
% if(time(counter) == Pret(spikecounter)) 
% gexstart = gex + deltag; 
% tspike=Pret(spikecounter); 
% if(spikecounter<length(Pret)) 
% spikecounter = spikecounter +1; 
% end 
% Voltage(1,counter) 
% end 
% Vinf = (El*gl + gex*Eex)/(gl+gex);%THE "STEADY STATE" VOLTAGE%%% 
% taum = cm/(gl+gex); %Effective time constant depends on g. 
% Voltage(1,counter+1) = Vinf + (Voltage(1,counter)-Vinf)*exp(-dt/taum); 
% gex = gexstart*exp(-(time(counter)-tspike)/tauex); 
% I(1,counter+1) = gex*Voltage(counter+1); 
% %%%%%%%%%%%%%%%%%%What to do if Voltage crosses threshold%%%%%%%%%%%%%%%%%%%%% 
% if(Voltage(1,counter+1) > Vth) 
% Voltage(1,counter+1) = 0;%%%%SPIKE 
% Voltage(1,counter+2) = Vreset;%%%%MOVE DOWN TO VRESET 
% counter = counter+1; 
% end 
% counter = counter + 1; 
% end 
% 9
% figure(1) 
% plot(time,Voltage,'b');xlabel('time (ms)');ylabel('Voltage (mV)'); 
% figure(2) 
% plot(time,I,'r');xlabel('time (ms)'); ylabel('Current(nA)'); 
% end
% 
% % 3 Stability Analysis
% 
% 
% function pr3 
% clear all 
% close all 
% global p 
% % initial conditions 
% q0 = [1; 1]; 
% % initial and final time values 
% tspan = [0 10]; 
% % output option for phase plane drawing 
% options = odeset('OutputFcn','odephas2'); 
% [T Y] = ode45(@toyprob,tspan,q0,options); 
% xlabel('x','Fontsize',15);ylabel('y','Fontsize',15) 
% grid on 
% figure 
% plot(T,Y(:,1),'-',T,Y(:,2),'-.') 
% legend('x(t)','y(t)') 
% xlabel('time');ylabel('Solutions') 
% function f = toyprob(t,y) 
% %global p 
% k = 0.15;% set k 
% f = zeros(2,1); % column vector 
% f(1) = -y(1)*(y(1) -1)*(y(1)+1) + y(2); 
% f(2) = -k*(2*y(1)+y(2)); 
% end
% end
% end
% 
