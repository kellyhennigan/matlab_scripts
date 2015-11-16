
% save fg endpoint density maps as ROIs in t1 space

%% define directories and file names, load files

subjects = {'sa28'};

% fdFNames = {'caudate_endpts_fd.nii.gz','nacc_endpts_fd.nii.gz','putamen_endpts_fd.nii.gz'};
fdFNames = {'caudate_DAendpts_fd.nii.gz','nacc_DAendpts_fd.nii.gz','putamen_DAendpts_fd.nii.gz'};
fgRoiDir = 'fg_endpoints';

thresh = 10; % omit voxels w/lowest thresh percent fd values

for i = 1:length(subjects)
    
    subject = subjects{i};
    
    expPaths = getSAPaths(subject);
    cd(expPaths.t1);
    
    t1 = readFileNifti('t1.nii.gz');
      
    t1_bb1 = t1.qto_xyz(1:3,4)'+1;
    t1_bb2 = t1_bb1+(size(t1.data)-1);
    t1_bb = [t1_bb1;t1_bb2];
    
    cd(expPaths.ROIs);
    if (~exist(fgRoiDir, 'dir'))
    mkdir(fgRoiDir)
    end
    
    for j = 1:length(fdFNames)
        
        cd(expPaths.fibers); cd fg_densities;
        fd = readFileNifti(fdFNames{j});
         
    fprintf(['\n\nresampling to t1 dimensions for subject ',subject,'\n\n']);
    
    [fd_t1dim,fd2t1_xform]=mrAnatResliceSpm(fd.data, fd.qto_ijk,[t1_bb],[1 1 1],[1 1 1 0 0 0]);
    
    if (fd2t1_xform~=t1.qto_xyz) % xform should be the same as t1.xformToAcpc
        error('resampled file and t1 should have the same xforms');
    end
    
    idx_all = find(fd_t1dim>0);
    vals = sort(fd_t1dim(idx_all));
    thresh_val = vals(round(length(vals)./thresh));
    idx = find(fd_t1dim>thresh_val);
    fd_t1dim = zeros(size(fd_t1dim));
    fd_t1dim(idx) = 1;
    
    cd (expPaths.ROIs); cd(fgRoiDir);
    
    dtiWriteNiftiWrapper(fd_t1dim,fd2t1_xform,fd.fname)
    roiNiftiToMat(fd.fname);
    end

end




