function roi = roiNiftiToMat(roiNii, outName,saveMat)
%
% converts a nifti roi file to a .mat file
% of the same format as those generated
% with dtiFiberUI and saves it in the same directory
%
% uses the dtiNewRoi function to make the Roi
%
% inputs:
%     roiNii - file name of nii file (e.g., 'ROI.nii.gz')
%     outName - name for new matRoiFile. If not given, it will be the
%               same name as the .nii file.
%     saveMat (optional) - 1 to save out .mat file, otherwise 0.
%                          Default is to save.
%
%
% outputs:
%     matRoi - roi in .mat format and (unless saveMatRoi=0) .mat file saved
%              out into the same directory as .nii roi file.
%
% example usage:
%   roiNiftiToMat('path/to/nii/roi.nii.gz')     % outRoi will be given the same name as roiNii
%   roiNiftiToMat('roiStr')                     % if roi is in the pwd
%   roiNiftiToMat('path/to/nii/roi.nii.gz','outRoi')    % to give outRoi a different name
%
% kjh 4/2011
%
% I took code from dtiConvertFreeSurferRoiToMat

% 3/15, edited to take more flexible inputs (i.e., string filenames, paths,
% or loaded roi niis)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checks on roiNii input
if notDefined('roiNii')
    error('roiNii must be given as input argument');
end

if ischar(roiNii)
    % if string doesn't have .nii.gz extension, add it
    if isempty(strfind(roiNii,'.nii'))
        roiNii = [roiNii '.nii.gz'];
    end
    roiNii = readFileNifti(roiNii);
end

% check on outName argument
if notDefined('outName')
    % get file path, & roi string wo ".nii.gz" extension
    [fp,fs,~]=fileparts(roiNii.fname); % fp gives filepath (if given)
    [~,outName,~]=fileparts(fs); % do this again in the case of *.nii.gz to get just the fileStr
end

% check on saveMat argument
if notDefined('saveMat')
    saveMat = 1;
end


%% do it

fprintf(['\ncreating roi ' outName '.mat\n']);

% get roi coords in img space
[i j k]=ind2sub(size(roiNii.data),find(roiNii.data));

% xform coords to acpc space
acpc_coords = mrAnatXformCoords(roiNii.qto_xyz,[i j k]);

% create a new roi with mrDiffusion structure
roi=dtiNewRoi(outName,[],acpc_coords); % name, color, coords


% save out .mat roi file unless saveMat==0
if saveMat
    dtiWriteRoi(roi,fullfile(fp,outName), [],'acpc');  % roi, filename, versionNum, coordinateSpace, xform
end

