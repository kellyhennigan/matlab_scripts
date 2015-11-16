function [roiNii,roiImgCoords] = roiXformCoords_kh(roiAcpcCoords, refNii, outRoiFName)

% script to transform ROIs in t1 acpc aligned space to another space
% (functional or dti)

%%%% INPUTS
% roiAcpcCoords, M x 3 matrix of acpc coordinates 
% refNii, roiCoords will be transformed from the sourceNii to refNii file's space/dimensions
% outRoiFName (optional) roiNii's file name

%%%% OUTPUTS
% roiNii, nii w/refNii's info except 0/1 data corresponding to the roi coords
% roiImgCoords, imgCoords corresponding to the roi w/ refNii dimensions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if (~exist('outRoiFName','var') || isempty(outRoiFName))
    outRoiFName = 'roiNii.nii.gz';
end

if size(roiAcpcCoords,1)==3
    roiAcpcCoords = roiAcpcCoords';
end

if ~size(roiAcpcCoords,2)==3
    error('roi coords must have either 3 rows or columns');
end

    imgCoords = round(mrAnatXformCoords(refNii.qto_ijk, roiAcpcCoords));
    
    % check if coordinates are out of the range of refNii dataset
    out_of_range_ind = find(imgCoords(:,3)>refNii.dim(3)); 
    if out_of_range_ind
        fprintf(['\n',num2str(length(out_of_range_ind)),' voxels out of '...
            num2str(length(imgCoords)),'are out of range\n']);
        imgCoords(out_of_range_ind,:) = [];
    end
    
    coordIndx = sub2ind(size(refNii.data), imgCoords(:,1), imgCoords(:,2), imgCoords(:,3));
    coordIndx = unique(coordIndx); % eliminate duplicate indices
    
    [i,j,k] = ind2sub(size(refNii.data),coordIndx);
    roiImgCoords = [i,j,k];
    
    % make a nii file with imgCoords set to 1
    roiNii = refNii;
    roiNii.data = zeros(size(roiNii.data(:,:,:,1)));
    roiNii.data(coordIndx) = 1;
    roiNii.dim=size(roiNii.data);
    roiNii.fname = outRoiFName;
    




