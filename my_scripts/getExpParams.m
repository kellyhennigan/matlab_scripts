function getExpParams(filePath)

% gets all the stimulus and timing parameters to run experiment SA2. saves
% out all the variables into the .mat file in the folder filePath.scripts
% called 'expParams.mat'. 
%
% the plan is to make this the single script that contains all the
% hard-coded experimental parameters.
% 
% this should only have to be executed if the experimental parameters
% (e.g., # of trials) are changed.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nConds = 2; % gains & losses
nContext = 2; % baseline and stress contexts

% so this is a 2 x 2 design, with gains and losses crossed by baseline and
% stress context. 

% now, define variables that apply to each of the 4 squares within this 2 x 2
% design:

%% RL TASK

% define variables for the reinforcement learning task. 

% outcome probabilities associated with cues
P_win =[
    .8 .2
    .7 .3
    .6 .4];    

nTrialsPerSet = 36;

%% CONTEXT EVENTS

% define variables for context events (shock, neutral)

nShockEvents = 24; % assumes the same # of neutral events is desired
pShock = .33; % proportion of stress events w/ a shock delivered


%% PRESENTATION SEQUENCE & TIMING (all in units of seconds except nScans)

nRuns = 6; % number of scan runs

initial_wait_time = 6; % seconds to wait at the beginning of a scan run for magnet to settle

cue_duration = 2; % duration of cue period 
outcome_duration = 2; % duration of feedback about choice

context_event_duration = 2; % duration of context trial cue presentation

cond_pres_duration = 2;   % duration that "try to win/avoid losing" instructions stay on the screen

fix_duration = 2;         % duration of fixation cross presentation after instructions and at the end of each run
% iti times
iti_params = [1 2 4]; % min mean max


%% now save them out into a matlab file 
save([filePath.scripts,'expParams.mat'])


%% now put them all into a structural array 

% varList = who;
% P = struct; %initialize structure
% 
% %use dynamic fieldnames
% for index = 1:numel(varList)
%     P.(varList{index}) = eval(varList{index});
% end 


