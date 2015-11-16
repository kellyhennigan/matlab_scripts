
% multiple comparisons correction
% non-parametric permutation method as
% described in Nichols & Holmes (2001)

% returns 1) the family-wise error corrected alpha value for single voxels 
% & 2)the supra-threshold cluster value for a given primary alpha threshold

%%%%%%%%%%%%  1) SINGLE THRESHOLD 

% get the critical threshold such that the probability that it is exceeded
% by the maximum voxel statistic is less than alpha

% rejection of the omnibus hypothesis (that all the voxels' hypotheses are 
% true) occurs if a voxel has a value that exceeds the critical threshold

%%%%%%%%%%%% 2) SUPRA THRESHOLD 

% for a given primary threshold, get the suprathreshold cluster size 
% required to declare alpha value, determine the cluster size required to 
% reject the null hypothesis for a given region


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this script is set up to get corrected values for testing the hypothesis 
% that the response to cond A > cond B (i.e., that cond A - cond B > 0).
% the null hyp  is that the response to cond A and cond B are the same.

% permute labels for cond A and B and note the maximum voxel statistic of
% interest for each iteration to form a distribution of max stats
% the critical threshold is then determined by finding the max stat value
% at a given alpha level.
% also notes the largest cluster size that exceeds a given primary threshold 
% for each iteration to form a distribution of largest cluster sizes
% the cluster size is then taken from that distribution. 


clear all

np = 5000;       % # of permutations

stat = max();     % note: make this a function handle!!! can also take the max cluster size for a given primary threshold

alpha = .05;      % alpha - the probability of Type I error (false positives) 
primary_thresh= 3.9;  % the primary threshold (t stat) for finding sig clusters

maskFile = '/home/kelly/ShockAwe/data/ROIs_tlrc/DA_func_tlrc_all.nii.gz';
% maskFile = '/home/kelly/ShockAwe/data/ROIs_tlrc/group_mask.nii';
betaFilesDir = '/home/kelly/ShockAwe/data/results_spm_hrf';

% test the contrast of condition 1 > condition 2 (finds files within
% betFilesDir with these strings)
cond1Str = 'shock';
cond2Str = 'neutral';

volIdx = 1; % which volume of the nifti files to use


%%% variance smoothing?
varSmooth = 0;    % 1 for variance smoothing
kSize = [3 3 3];       % size of kernel for variance smoothing (in units of voxels)


%% get mask and betas

mask = readFileNifti(maskFile);
mask.data = single(mask.data);
idx = find(mask.data);
dim = mask.dim;

cd(betaFilesDir)
f1 = dir(['*',cond1Str,'*beta*nii*']);
f2 = dir(['*',cond2Str,'*beta*nii*']);
if length(f1) ~=length(f2)
    error('make sure there are an equal number of cond1 and cond2 files in the working directory');
end

n = length(f1);  % number of subjects

for s = 1:n
    
    nii1 = readFileNifti(f1(s).name); cond1Vals = nii1.data(:,:,:,volIdx); % cond1 betas
    nii2 = readFileNifti(f2(s).name); cond2Vals = nii2.data(:,:,:,volIdx); % cond2 betas
    betas(:,s) = cond1Vals(idx) - cond2Vals(idx); 
    
end


%% null hyp 1: there is no difference between betas in cond1 and cond2
% permute cond1 and cond2 labels & find the maximum
% (pseudo) t-stat for the difference between juice and neutral across all
% voxels at each permutation

% get all possible combinations of '+' and '-' labels for n subjects
possible_labelings = permpos(0,n); % all possible permutations of 0 values in n positions
for pp = 1:floor(n/2)
    possible_labelings = [possible_labelings;permpos(pp,n)];
end

sample_idx = randsample(length(possible_labelings),np); % index vector of the rows from possible_labelings to sample 

for i = 1:np % # of permutations
    theseBetas = betas;
    thisPerm = possible_labelings(sample_idx(i),:);
    theseBetas(:,thisPerm)=theseBetas(:,thisPerm).*-1;
  
    % get mean and variance stats for each voxel across subjects
    diffBi = nanmean(theseBetas');
    varBi = nanvar(theseBetas');
    if(varSmooth)
        varMap = mask.data;
        varMap(idx)=varBi;
        varMap = smooth3(varMap,'gaussian',kSize);  % variance smoothing
        varBi = varMap(idx);
    end
    tvals = diffBi./(sqrt(varBi)./sqrt(n));
  
    maxTVals(i)=max(tvals); 
    minTVals(i)=min(tvals); % the abs() of this is the max of the exact opposite permutation of labels
    
    % max cluster size for a given primary threshold value
    thisNii = mask;
    thisNii.data(idx) = tvals;
    thisNii.data(thisNii.data<primary_thresh)=0;
    maxCSizes1(i) = nii_cluster_max(thisNii);
    
    % do this again for negative t values
    thisNii.data(idx) = tvals;
    thisNii.data(thisNii.data>-primary_thresh)=0;
    maxCSizes2(i) = nii_cluster_max(thisNii); % this is the max cluster size for the exact opposite permutation of labels

    if ~rem((i.*10),np)
        fprintf([num2str((i.*100)./np),' percent done...\n\n']);
    end
    
end % np 

maxTs=sort([maxTVals';abs(minTVals)']);
cSizes = sort([maxCSizes1';maxCSizes2']);
% close all
% figure
% subplot(1,2,1)
% title('max t stats')
% hist(maxTs,50)
% subplot(1,2,2)
% title('max cluster size')
% hist(cSizes,50)

% tstat_corrected = maxTs(length(maxTs).*(1-alpha));
% cSize_corrected = cSizes(length(cSizes).*(1-alpha));
tstat_corrected = quantile(maxTs,1-alpha)
cSize_corrected =  quantile(cSizes,1-alpha)


% %% test the robustness of the estimate using monte carlo simulations
% 
% % get 100 estimates of tstat_corrected & cSize_corrected using 1000,5000,
% % and 10000 permutations and compare this distribution to the corrected
% % values obtained from doing all possible permutations
% 
% minmaxTs = [minTVals',maxTVals'];
% maxCSizes12 = [maxCSizes1',maxCSizes2'];
% 
% nEst = 100;
% 
% thisNp = 10000;
% 
% for j = 1:nEst
%     
% this_sample_idx = randsample(length(maxTVals),thisNp); % index vector of the rows from possible_labelings to sample 
% 
% theseTs = minmaxTs(this_sample_idx,:);
% theseMaxCSizes12= maxCSizes12(this_sample_idx,:);
% 
% these_tstat_corrected(j) = quantile(reshape(theseTs,prod(size(theseTs)),1),1-alpha);
% these_cSize_corrected(j) =  quantile(reshape(theseMaxCSizes12,prod(size(theseMaxCSizes12)),1),1-alpha);
% 
% end




