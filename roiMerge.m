
function merged_roi = roiMerge(rois,merged_roi_name,saveOut)
% -------------------------------------------------------------------------
% usage: merge rois
%
% INPUT:
%   rois - cell array of roi niftis, roi structs (from .mat files), or the
%          names of these files. All rois must be given in the same format,
%          whether thats as loaded nifti files, .mat structs, or filenames.
%          If roi.mat files are loaded, it should be like:
%          rois{1}=load('roi1.mat'), etc., so that the coords for that roi
%          are rois{1}.roi.coords.
%          If rois elements are filenames, this function will save out the
%          merged_roi to the same directory as rois{1}.
%
%   merged_roi_name (optional) - string specifiying the merged_roi_name
% 
%   saveOut - 1 to save out merged roi file, otherwise 0. Default is 0. If
%          saveOut=1 and the rois given are filepaths, the merged roi will
%          be saved out to the same directory as rois{1}. If saveOut=1 and
%          the rois are loaded, then it will save out to the current
%          working directory.
%
% OUTPUT:
%   merged_roi - merged_roi in nifti or .mat struct format
%
%
% author: Kelly, kelhennigan@gmail.com, 17-Apr-2015

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% only save out merged roi file if user requests it
if notDefined('saveOut')
    saveOut = 0;
end


% check to make sure rois argument is given and that's its a cell array
if notDefined('rois') || ~iscell(rois)
    error('input rois argument is required & must be a cell array');
end


% if no name is given for the mergedNii, make one up
if notDefined('merged_roi_name')
    merged_roi_name = 'merged_roi';
end


% figure out if rois are filepaths or loaded, and whether they are in nifti
% or .mat format

if ischar(rois{1})
    
    % load them
     if strfind(rois{1},'.mat')  % or mat format
       roi_format = 'mat'; % .mat roi files
        [saveDir,~] = fileparts(rois{1}); % get roi dir in case saving out roi
        rois=cellfun(@(x) load(x), rois,'UniformOutput',0);
        
     elseif strfind(rois{1},'.nii')      % nifti format
      roi_format = 'nii';  %  nifti files
        rois=cellfun(@(x) readFileNifti(x), rois,'UniformOutput',0);
   
    end
    
% if roi is already loaded, figure out whether its a nifti or .mat format
else
    if isfield(rois{1},'coords')
        roi_format = 'mat';    % .mat format
    else
        roi_format = 'nii';    % nifti format
    end
end
    


%% merge rois 


switch roi_format
    
    
    case 'mat'  % mat format
        
        merged_roi=rois{1}.roi;
        merged_roi.name = merged_roi_name;
        for i=2:numel(rois)
            merged_roi.coords = [merged_roi.coords;rois{i}.roi.coords];
        end
        
        % note if there are overlapping voxels
        if size(merged_roi.coords,1) ~= size(unique(merged_roi.coords,'rows'),1)
            fprintf('\nNote that the input rois have overlapping voxels.\n\n');
            merged_roi.coords = unique(merged_roi.coords,'rows');
        end
        
        % save merged roi if saveDir is defined
        if saveOut
            save(fullfile(saveDir,merged_roi_name),'-struct','merged_roi');
        end
        
    
    case 'nii' % nifti format
        
        [saveDir,~] = fileparts(rois{1}.fname);
        merged_roi=mergeNiis(rois,fullfile(saveDir,merged_roi_name));
        
        % note if there are overlapping voxels
        if any(merged_roi.data(:)>1)
            fprintf('\nNote that the input rois have overlapping voxels.\n\n');
            merged_roi.data(merged_roi.data>1)=1;
        end
        
        % save merged roi if saveDir is defined
        if saveOut
            writeFileNifti(merged_roi);
        end
        
        
  
end % roi_format

