function merged_nii = mergeNiis(niis,merged_nii_name,saveOut)
% -------------------------------------------------------------------------
% usage: use this as a quick way to merge nifti files. As of now, this just
% adds the data of given input nifti files.
%
% INPUT:
%   niis - cell array of niftis to merge. Niftis in cell array must be
%          either all nifti filenames as strings or all loaded nifti
%          structs.
%   merged_nii_name (optional) - string specifying the merged_nii's filename
%   saveOut - 1 to save out merged file, otherwise, 0
%
% OUTPUT:
%   merged_nii - merged nifti
%
%
% author: Kelly, kelhennigan@gmail.com, 17-Apr-2015

% TODO: add input argument operation (e.g., 'sum','mean', etc.) to
% allow specification of what operation to perform on input niftis.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


% throw an error if niis argument isn't given or isn't a cell array
if notDefined('niis') || ~iscell(niis)
    error('input niis argument is required & must be a cell array');
end


% if niis elements are strings, then they should be filenames. Load those files.
if ischar(niis{1})
    niis=cellfun(@(x) readFileNifti(x), niis,'UniformOutput',0);
end


% if no name is given for the merged_nii, make one up
if notDefined('merged_nii_name')
    merged_nii_name = 'merged_data.nii.gz';
end

% default is to NOT save out the merged file
if notDefined('saveOut')
    saveOut=0;
end

% make sure that merged_nii_name has .nii.gz extension once and only once
merged_nii_name = [strrep(strrep(merged_nii_name,'.nii',''),'.gz','') '.nii.gz'];

% "merge" (add) data of input niis
merged_nii = niis{1};
merged_nii.fname = merged_nii_name;
for i=2:numel(niis)
    merged_nii.data=double(merged_nii.data)+double(niis{i}.data);
end

if saveOut
    writeFileNifti(merged_nii);
end


