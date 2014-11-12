function dtiFixITKGrayHeader2(fileName,RefFileName)
% This function fixes the header of the NIFTI file exported from MrVista
% using the header of the reference file and overwrites the original file
%
%   dtiFixITKGrayHeader(fileName,RefFileName)
%
%EXAMPLE:
%           dtiFixITKGrayHeader('ROI1.nii.gz','t1.nii.gz');
%
% KH: edited to convert data from unsigned to signed integers

% Read the Nifti Files
ni = readFileNifti(RefFileName);
ni2 = readFileNifti(fileName);

%Fix Headers
ni.fname = fileName;
ni.data = int16(ni2.data);

%generate new file
writeFileNifti(ni);

return