function niiRoi = roiMatToNifti(matRoiFile, niiRefFile,outFName,saveNii)
%
% converts a .mat roi to a nifti file 
% and saves it in the same directory, unless saveNii==0
%
% note: assumes this is called from a subject's main directory and that the
% nii ref file is in the current dir
%
%
% inputs: matRoiFile - .mat roi file to convert 
%         refFile - reference file for header info
%         outFName (optional) - name of new nii file
%         saveNii (optional) - 1 to save out nii file, otherwise 0. Default
%               is to save.
%
% outputs: Roi nifti file and (if desired) saved to the same directory as
%          roi mat file. 
%
% kjh 4/2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 

% check on matRoiFile
if notDefined('matRoiFile')
    error('matRoiFile must be given as input argument');
end
if ischar(matRoiFile)
    [fp,~,~]=fileparts(matRoiFile); % fp gives filepath (if given)
    load(matRoiFile);
    matRoiFile = roi;
else
    fp = ''; % assign fp to '' if matRoiFile isn't a string
end

% checks on niiRefFile
if notDefined('niiRefFile')
    error('niiRefFile must be given as input argument');
end
if ischar(niiRefFile)
    niiRefFile = readFileNifti(niiRefFile);
end

% checks on outFName
if notDefined('outFName')
    outFName = fullfile(fp,matRoiFile.name);
end
if isempty(strfind(outFName,'.nii'))
    outFName = [outFName '.nii.gz'];
end

% check whether to save or not
if notDefined('saveNii')
    saveNii = 1;
end


%% do it 

fprintf(['\n\n creating roi file ',outFName,'\n\n']);

% get roi img coordinates
imgCoords = round(mrAnatXformCoords(niiRefFile.qto_ijk, matRoiFile.coords));
coordIndx = sub2ind(niiRefFile.dim(1:3),imgCoords(:,1),imgCoords(:,2),imgCoords(:,3));

% define a new nifti file w/1 for roi voxels
niiRoi = niiRefFile;
niiRoi.data = zeros(niiRoi.dim(1:3));
niiRoi.data(coordIndx) = 1;
niiRoi.fname = outFName;

% save new nifti ROI file
if saveNii
    writeFileNifti(niiRoi);
end
