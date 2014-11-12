function dtiFixTensorsAndDT6(dt6file,tensorfile,newtensorfile)

% Usage: dtiFixTensorsAndDT6(dt6file,tensorfile,[newtensorfile])
%
% This function will take an existing TENSORFILE, run DTIFIXTENSORS on it
% to set all negative eigenvalues to 0, write this to a new file
% (NEWTENSORFILE), and update the DT6FILE so that this new tensor nifti is
% what is associated with the subject. 
%
% Default if NEWTENSORFILE not specified, add "nonneg_" as filename prefix
%
% DY 03/2008
%
% kjh: updated this so that tensors path saved in dt6.mat is correct

[dtdir,dfile]=fileparts(dt6file);
[tensordir,tfile]=fileparts(tensorfile);

if(~exist('newtensorfile','var')||isempty(newtensorfile))
    newtensorfile=fullfile(tensordir,['nonneg_' tfile '.gz']);
end

dtiFixTensors(tensorfile,newtensorfile)

dt=load(dt6file);
[tensorPath] = fileparts(dt.files.tensors);
[dtMainDir]=fileparts(tensorPath);
dt.files.tensors=fullfile(dtMainDir,newtensorfile);

save(dt6file,'-struct','dt');