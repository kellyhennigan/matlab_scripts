function onsets = getStimOnsets(filePath, stim)

% finds etimulus events of interest as defined by input string 'stim'
% from .csv file as defined by input string 'filePath'
% and returns the stimulus onset times

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
fid = fopen(filePath);
allStimTimes = textscan(fid, '%*q %q "%f" ','Delimiter',';','HeaderLines',1);
fclose(fid);

% set python start time as time = 0
trigIndx = strmatch('python start time', allStimTimes{1});
allStimTimes{2} = allStimTimes{2} - allStimTimes{2}(trigIndx);

% find the stim events of interest and their onset times
eventIndx = strmatch(stim, allStimTimes{1},'exact');  % use exact or else shock finds shockslide, too
onsets = allStimTimes{2}(eventIndx);




