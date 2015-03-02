function hf = setupFig(hf)
% --------------------------------
% usage: call this to set up a matlab figure 

% INPUT:
%   hf - figure handle
  
% OUTPUT:
%   hf - figure handle 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

font = 'Arial';
fSize = 12;

if notDefined('hf')
    hf = figure; 
else
    hf;
end
hold on

set(gca,'fontName',font,'fontSize',fSize);
set(gca,'box','off');
set(gcf,'Color','w','InvertHardCopy','off','PaperPositionMode','auto');
