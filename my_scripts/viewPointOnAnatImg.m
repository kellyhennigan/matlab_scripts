% check out node 9 of R NAcc group

close all
clear all

cd ~/dti/data
dataDir = pwd
coords = dlmread('naccR_best_coords')


subjects = getDTISubjects;
i=1

for i = 1:length(subjects)
    cd(subjects{i});
    
    t1 = readFileNifti('t1_fs.nii.gz');
    dt=dtiLoadDt6('dti96trilin/dt6.mat');
    
    imgCoords = dtiBuildSphereCoords(round(mrAnatXformCoords(t1.qto_ijk,coords(i,:))),2);
    idx = sub2ind(size(t1.data),imgCoords(:,1),imgCoords(:,2),imgCoords(:,3));
    
    nii=t1;
    nii.data=zeros(size(nii.data));
    nii.data(idx)=1;
    
%     plotOverlayImage(nii,t1,autumn,[.5 2],1,round(coords(i,1)));
%     plotOverlayImage(nii,t1,autumn,[.5 2],2,round(coords(i,2)));
    plotOverlayImage(nii,t1,autumn,[.5 2],3,round(coords(i,3)));
    
    cd ../
end

