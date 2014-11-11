%% some useful plotting commands

% get screensize
scrSize = get(0,'Screensize')

% get a figure's position
fig = figure(1)
rect = get(fig,'Position')
% where rect = [left, bottom, width, height] of figure 

% set a figure to be in the upper right corner of the screen
set(fig,'Position',[scrSize(3)-rect(3),scrSize(4)-rect(4),rect(3),rect(4)]);
