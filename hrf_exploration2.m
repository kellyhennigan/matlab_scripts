%% explore hrfs

clear all
close all


% define somes params; time units are seconds (s)

% labels for time series to compare
ts_strs = {'instantaneous event','1 s boxcar','2 s boxcar','6 s boxcar'}; 

boxcar = [0 1 2 6]; % model corresponding time series with a X s boxcar 

% ts_strs = {'instantaneous event','1 s','2 s','3 s','4 s','5 s','6 s'}; 
% boxcar = [0:6]; % model corresponding time series with a X s boxcar 

RT = .1; % sampling rate of .1 s

ts_dur = 35; % duration (s) of time series

e_onset = 1; % time (s) of event onset; this will count as t=0


%% define time series and hrf and convolve them


e_onset = e_onset./RT; % event onset in units of RT

t = 0:RT:ts_dur; % time point of each sample
t = t-t(e_onset); % time (s) relative to event onset

% create time series w/events of varying durations 
ts = zeros(numel(t),numel(ts_strs));  
ts(e_onset,:) = 1;                % instantaneous event onset 
for i=1:numel(ts_strs)
    ts(e_onset:e_onset+boxcar(i)/RT-1,i)=1;
end 


% convolve time series with hrf 
[hrf,p] = spm_hrf(RT);  % spm's canonical hrf
for i=1:numel(ts_strs)
    
    this_ts_conv = conv(ts(:,i),hrf);
    this_ts_conv = this_ts_conv./max(this_ts_conv); % normalize so that max height is 1
    ts_conv(:,i) = this_ts_conv(1:numel(t)); % truncate so they're all the same length
    
end


% plot them and print out peak times
[~,pt]=max(ts_conv);
fprintf('\n\ntime to peak: \n')
colors = solarizedColors(numel(ts_strs)+1);
figure; hold on
xlabel('time (s)')
for i=1:numel(ts_strs)
    plot(t,ts_conv(:,i),'color',colors(i,:),'Linewidth',2);
    fprintf([ts_strs{i} ': ' num2str(t(pt(i))) ' s\n']);
end
legend(ts_strs)
plot([0,0],ylim,'--','color',[.5 .5 .5])
hold off


