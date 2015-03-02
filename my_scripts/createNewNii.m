function outNii = createNewNii(refNii, newName, descrip, varargin)
% -------------------------------------------------------------------------
% usage: use this function to create a new nifti for a volume(s) that have
% the same dimensions/space as a given template nifti file


% INPUT:
%   refNii - reference nifti to get all header info (xform, voxel
%            dimensions, etc.)
%   newName - string specifying the file name for the new out nifti
%   descrip (optional) - string giving additional info about this
%           data, e.g., 'vol1 is Fstat; vol2 is p-stat; df(2,17)
%   varargin - 3d volumes to include in outNii; must be the same
%           dimensions as the refNii

% OUTPUT:
%   outNii - nifti struct containing info/data specified by input

% NOTES:
%
% kelly 2012

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

outNii = refNii; % get all header info from refNii

% if fname is not defined, call it outNii
if notDefined('newName')
    newName = 'outNii.nii.gz';
end

% if fname doesn't have nii file extension, had it
if ~ischar(newName)
    error('name for output nifti file must be a string');
else
    suffix = strfind(fname,'.nii');
    if isempty(suffix)
        fname = [fname,'.nii.gz'];
    end
outNii.fname = newName;

% add description of the data if provided
outNii.descrip = descrip;


% fill in data w/input volumes
outNii.data = [];
if ~isempty(varargin)
    for h = 1:length(varargin)
        outNii.data = cat(4,outNii.data, varargin{h});
    end
end


outNii.dim = size(outNii.data);

