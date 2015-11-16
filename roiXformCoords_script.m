% script to transform ROIs defined in structural acpc space to functional
% space
clear all
close all


% xform DA in structural native space to functional tlrc space
cd /home/kelly/ShockAwe/data/sa07

t1 = readFileNifti('t1.nii.gz')

cd afni
xform = dlmread('xform_orig2tlrc')

t1_tlrc=readFileNifti('t1_tlrc.nii.gz');
func=readFileNifti('all_scaled_stlrc.nii.gz');

cd ../ROIs
load('DA.mat')

refNii.data = zeros(refNii.dim(1:3));
refNii.dim = refNii.dim(1:3);

subjects = getSASubjects('fmri');

roiNames = {'DA'};
outNames = {'DA_tlrc'};
% targetSpaceRef = 'afni/all_scaled_stlrc.nii.gz';

for s = 1:length(subjects);
s=1    
    fprintf(['\n\n working on subject ',subjects{s},'\n\n']);
    subject = subjects{s};
    
    expPaths = getSAPaths(subject);
%     cd(expPaths.subj); 
%     
%     ref = readFileNifti(targetSpaceRef);
%     
    cd(expPaths.ROIs); 
    
    
%     for j = 1:length(roiNames)
    j=1;
%     roiNiftiToMat([roiNames{j},'.nii.gz']);
    load([roiNames{j},'.mat']);
    
    % get xform to tlrc structural space
    cd ../afni
    xform = dlmread('xform_orig2tlrc');
    
    
    
%     [roiNii,roiImgCoords] = roiXformCoords_kh(roi.coords, refNii,[roiNames{j},'_tlrc.nii.gz']);
    
    [roiNii,roiImgCoords] = roiXformCoords_kh(roi.coords, refNii,outNames{j});
    
     writeFileNifti(roiNii);

end
    
cd ~/ShockAwe/data/ROIs_tlrc

mb = readFileNifti('midbrain_tlrc.nii.gz');
cd /home/kelly/ShockAwe/data/sa07/afni

refNii=readFileNifti('all_scaled_s.nii.gz');


cd ~/ShockAwe/data/ROIs_tlrc/
for s=1:14
       fprintf(['\n\n working on subject ',subjects{s},'\n\n']);
    
    expPaths = getSAPaths(subjects{s});

    cd(expPaths.ROIs); 
    
roi = readFileNifti('habenula_tlrc.nii.gz');
roi.data = roi.data(:,:,:,1);
writeFileNifti(roi);
all.data = all.data+roi.data;
end

