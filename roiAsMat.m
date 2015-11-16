
function [roi,roiDir,inFormat,roiNii] = roiAsMat(roi)
% -------------------------------------------------------------------------
% usage: this function takes in an roi filepath, loaded in .mat format, or
% loaded as a nifti and returns the roi loaded in .mat format (mrVista
% format).
% I made this a function basically to avoid having to write the same old
% checks over and over again to see if an roi is a filepath or loaded and
% whether its in .mat format or as a nifti mask.
%
%
% INPUT:
%   roi - filepath, or loaded roi, in .mat or nifti format. If already
%         loaded and in .mat format, this function does nothing.

%
% OUTPUT:
%   roi - roi loaded in .mat format (basically, with acpc coords in field,
%         roi.coords).
%   roiDir - if given as input, (either as a filepath or in the nii field,
%         roi.fname), roiDir is the directory housing the roi file. Returns
%         '' if it can't be determined.
%   inFormat - 'mat' if input roi was in .mat format, 'nii' for nifti
%         format.
%   roiNii - blah. I realized that if the in roi is a nifti, you want that
%         returned, since you might want to use its transform, etc. So if
%         inFormat is 'nii', this returns the loaded roi nii. If inFormat
%         is 'mat', this is empty. 
% 
%
% author: Kelly, kelhennigan@gmail.com, 27-Apr-2015

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% figure out if roi is a filepath or loaded, and whether its in nifti or
% .mat format

roiNii=''; % return this as empty unless in roi is inFormat 'nii'


% if roi is given as a filepath, note the directory for saving out rois
if ischar(roi)
    
    [roiDir,~]=fileparts(roi); % get roiDir from filepath
    
    % if roi filepath has '.mat', load the .mat file
    if strfind(roi, '.mat')
        inFormat = 'mat'; %  .mat roi file
        load(roi); % loads roi variable
        
        
        % if roi filepath has '.nii', load the nifti file
    elseif strfind(roi,'.nii')
        inFormat = 'nii';  %  nifti file
        roiNii = readFileNifti(roi);
        roi = roiNiftiToMat(roiNii,0); % load it in .mat format
        
    end
    
    
    % if roi is already loaded, figure out whether its a nifti or .mat format
else
    
    if isfield(roi,'coords')
        roiDir = '';         % don't know the roiDir from a loaded .mat file
        inFormat = 'mat';    % .mat format
    else
        inFormat = 'nii';    % nifti format
        roiNii = roi;
        [roiDir,~] = fileparts(roi.fname); % try to get roiDir from roi.fname field of nifti
        roi = roiNiftiToMat(roi,0); % convert to .mat format
    end
    
end
