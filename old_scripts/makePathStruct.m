%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% makePathStruct() 
% makes a path structure & adds relevant search paths 
%
% Janice Chen 05/01/08
% Adam November 01/31/09
% Kelly Hennigan 05/2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function thePath = makePathStruct()
    thePath.main = pwd
    thePath.scripts = fullfile(thePath.main, 'scripts');
    thePath.data = fullfile(thePath.main, 'data');
    thePath.stim = fullfile(thePath.main, 'stim');

    % Add relevant paths 
    names = fieldnames(thePath);
    for f = 1:length(names)
        eval(['addpath(thePath.' names{f} ')']);
        fprintf(['added ' names{f} '\n']);
    end
 
end