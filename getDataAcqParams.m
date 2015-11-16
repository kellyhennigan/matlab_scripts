%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get data acquisition parameters from dicom files

% goal is for this function to return the parameters necessary to report
% for functional data, t1-weighted, fieldmap, and diffusion scans. Maybe
% more to be added later.

% NOTES:
% disclaimer: this is specific for data acquired at CNI!!
% MRI system: input dataPath were collected at the Stanford Center for
% Cognitive and Neurobiological Imaging using a 3T GE Sigma MR750 scanner
% and (probably) a Nova 32-channel RF head coil

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INPUTS:
%   dataPath - path to nifti data file or directory w/dicoms
%   dataType - string specifying data type; will only except:
%              'func' - functional data 
%              't1'   - t1-weighted (structural) data
%              'fmap' - fieldmap data 
%              'dwi'  - diffusion-weighted data

% OUTPUTS:
%   a - structural array with data acquisition parameters as fields; as
%     much as possible will be filled in and returned


% kjh, 24-Apr-2014

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% load input data 

% if dataPath is a directory, assume its a directory of dicom files
% if isdir(dataPath)
    cd(dataPath)
    all_d = dir('*dcm');
    d = dicominfo(all_d(1).name);
    


%% define structural array for output
a = struct();

switch dataType
    
    
    case 'func'                 % functional data
        
        pulse_seq = [];             % pulse sequence type (e.g., gradient/spin echo, EPI/spiral)
        parallel_im = [];           % if used, method (e.g. SENSE/GRAPPA) and acceleration factor
        
        nVolumes = d.dim(4);        % # of volumes acquired
        nSlices = d.dim(3);         % # of slices
        FOV = [];                   % field of view
        matrix_size = d.dim(1:2);   % matrix size
        slice_thickness = [];       % slice thickness (mm)
        slice_gap = [];             % slice gap aka interslice skip
        vox_size = []               % nominal spatial resolution *see note below*
        z_vol_coverage = [];        % volume coverage in the z plane (in mm)
        acq_orient = [];            % orientation of acquisition (e.g., axial, oblique, etc.)
        TR = [];                    % repetition time (TR)
        TE = [];                    % echo time (TE)
        FA = [];                    % flip angle (FA)
       
        % slice acquisition order
%         note: by default, the slice acquisition order for GE EPI scans is
%         interleaved, odd first (i.e., 1, 3, 5, ..., 2, 4, 6, ...)
%         whether its ascending or descending depends on whether slice 1
%         was prescribed on the top or bottom. The position of slice 1 is
%         the first slice in the nifti file, so if slice 1 is the most
%         superior, then the acq order is interleaved in the descending
%         direction; if slice 1 is the most inferior, then its in the
%         ascending direction.
        slice_acq_order = [];       % slice acquisition order (descending/ascending sequential or interleaved) 


  case 't1'                   % t1-weighted data
        
        
        
    case 'dw'                   % diffusion-weighted
        
        
    case 'fmap'                 % fieldmap
        
    otherwise
        disp('dataType must be specified')
        
end

% * note on 'nominal' spatial resolution: is 'nominal because this is the
% width of the estimated point-spread function (PSF), but this doesn't take
% into account the effects of in vivo image degradation.

%% if the input file is a nifti

% else
    d = readFileNifti(dataPath);
% end



