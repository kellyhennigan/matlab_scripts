% % This script takes over from that point, using the files output from
% % probtrackx.  This script takes those files,
% % thresholds the fiber tract number for each seed voxel and a given target region (default threshold value is 10 fibers),
% % calculates the ratio of fiber tracts going to one target region/tracts going to all other target regions for each voxel in the seed ROI,
% % and determines the target region to which each seed voxel is most strongly connected
% % 
% % It outputs a new .nii file exactly like the "seeds_to..." files generated by probtrackx only with the ratio values rather than the number of tracts for each voxel
% %     and another .nii file that gives the target region most strongly connected to each seed voxel
% % 
% % note: label the target regions alphabetically to avoid confusion over which target ROI goes with which "winner label" 
% % also, include the ACC and collapse over the NAcc subregions

%function probTrackxProportionScore(  , threshold)

% kelly

%NOTE: this script does the same thing as this from the command line:
% proj_thresh filenames threshnum
% and then
% find_the_biggest filenames outfilename
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

minThresh = 10;

%% load probtrackx output files

% cd to probtrackx directory
%cd ~/data/DTI/reno/probtrackx/classification

% find all probtrackx files in the directory
files = dir('seeds_to_*');

% load all probtrackx files into one structure
% and create a cell array that indexes the voxels
% with values > 0

numFibersIndex = {};
for n = 1:length(files)
    seedData(n) = readFileNifti(files(n).name);
    % set voxels with less than min threshold # of samples to 0
    indx = find(seedData(n).data > 0 & seedData(n).data < minThresh);
    seedData(n).data(indx) = 0;
    % create an index of all non zero voxels
    numFibersIndex{n} = find(seedData(n).data);
end

clear ans indx n 

% concatenate data across target regions (4th dim)
catData = cat(4, seedData.data);
% note the target region with the max # of samples/voxel
[tracknum, winningTarget] = max(catData,[],4);
indx2 = find(tracknum==0);
winningTarget(indx2) = 0;
% save a nifti file with the winning target index
niWinners = seedData(1);
niWinners.fname = 'winningTargets.nii.gz';
niWinners.data = int16(winningTarget);
writeFileNifti(niWinners);

% find the total # of tracks for all target regions at each voxel
totalVals = sum(catData, 4);


% convert data values into proportion of tracks to all target regions for
% each voxel
for p = 1:length(seedData)
    seedData(p).data = seedData(p).data ./ totalVals;
    indx = find(isnan(seedData(p).data));
    seedData(p).data(indx) = 0;
    % add "prop" suffix to file name to indicate proportional values
    strIndx = strfind(seedData(p).fname, '.nii.gz');
    seedData(p).fname = strcat(seedData(p).fname(1:strIndx-1), '_prop.nii.gz');
    writeFileNifti(seedData(p));

% % make files for viewing in ITKgray w/ binned proportion values
% 
% >50% label 11
    indx11 = find(seedData(p).data > .5 & seedData(p).data <= 1.0);
    seedData(p).data(indx11) = 11;
    
% >0-5% label 1
    indx1 = find(seedData(p).data > 0 & seedData(p).data <= .05);
    seedData(p).data(indx1) = 1;
    
% >5-10% label 2
    indx2 = find(seedData(p).data > .05 & seedData(p).data <= .1);
    seedData(p).data(indx2) = 2;
    
% >10-15% label 3
    indx3 = find(seedData(p).data > .1 & seedData(p).data <= .15);
    seedData(p).data(indx3) = 3;
    
% >15-20% label 4
    indx4 = find(seedData(p).data > .15 & seedData(p).data <= .2);
    seedData(p).data(indx4) = 4;
    
% >20-25% label 5
    indx5 = find(seedData(p).data > .2 & seedData(p).data <= .25);
    seedData(p).data(indx5) = 5;
    
% >25-30% label 6
    indx6 = find(seedData(p).data > .25 & seedData(p).data <= .3);
    seedData(p).data(indx6) = 6;
    
% >30-35% label 7
    indx7 = find(seedData(p).data > .3 & seedData(p).data <= .35);
    seedData(p).data(indx7) = 7;
    
% >35-40% label 8
    indx8 = find(seedData(p).data > .35 & seedData(p).data <= .4);
    seedData(p).data(indx8) = 8;
    
% >40-45% label 9
    indx9 = find(seedData(p).data > .4 & seedData(p).data <= .45);
    seedData(p).data(indx9) = 9;
    
% >45-50% label 10
    indx10 = find(seedData(p).data > .45 & seedData(p).data <= .5);
    seedData(p).data(indx10) = 10;
    
    seedData(p).fname = strcat(seedData(p).fname(1:strIndx-1), '_prop_BIN.nii.gz');
    writeFileNifti(seedData(p));
    
end

