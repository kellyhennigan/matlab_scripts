%% get hrf and derivative of hrf

TR = 1; % sample rate

[hrf,p] = spm_hrf(TR);
% p contains spm_hrf's default parameters:  6  16   1   1   6   0  32

dp = TR; % one time step

p(6) = p(6)+dp; % move the onset forward 1 time step

dhrf = (hrf - spm_hrf(TR,p))/dp;

figure
plot(hrf)
hold on
plot(dhrf,'b')
hold off


%% compare stick function to boxcar

t = zeros(50,1); 
t(10)=1;
t2=t;
t2(10:12)=1;

tc = conv(t,hrf);
t2c = conv(t2,hrf);

figure
subplot(2,1,1); hold on
plot(t,'r')
plot(t2,'b')

subplot(2,1,2); hold on
plot(tc,'r')
plot(t2c,'b')

