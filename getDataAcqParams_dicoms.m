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
%   dataPath - path to directory w/dicom files (e.g., 'path/to/dicom_dir')
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
%% get data

% cd to dicom directory and load a dicom file
if isdir(dataPath)
    cd(dataPath)
    all_d = dir('*dcm');
    d = dicominfo(all_d(1).name);
else
    error('dataPath must specify a directory w/dicom files')
end


%% get data acquisition parameters

% MR system info
coil = d.ReceiveCoilName;                   % RF head coil
scanner_model = d.ManufacturerModelName;    % scanner model


% MR scan sequence info
switch dataType
    
    
    case 'func'                 % functional data
        
        nPrescribedVolumes = d.NumberOfTemporalPositions;   % # of volumes acquired *NOTE: this is the number of *prescribed vols; not necessarily the number of vols actually scanned!!
        nSlices = d.ImagesInAcquisition./d.NumberOfTemporalPositions;      % # of slices; also in the dicom field "Private_0021_104f"
        FOV = [d.PixelSpacing(1).*d.Rows, d.PixelSpacing(2).*d.Columns];   % field of view
        matrix_size = d.AcquisitionMatrix;   % matrix size (frequency rows/columns phase rows/columns)
        slice_thickness = d.SliceThickness;       % slice thickness (mm)
        slice_gap = d.SpacingBetweenSlices-d.SliceThickness;     % slice gap aka interslice skip
        in_plane_res = d.PixelSpacing;           % in-plane resolution
        vox_size = [in_plane_res',slice_thickness]; % nominal spatial resolution
        TR = d.RepetitionTime;      % repetition time (TR) (ms)
        TE = d.EchoTime;            % echo time (TE) (ms)
        FA = d.FlipAngle;           % flip angle (FA)
        
        % slice acquisition order & direction (descending/ascending sequential or interleaved)
        % note: this assumes that the dataPath directory contains the dicoms for the first
        % volume of data acquired-if this isn't the case, then this may not accurate!!
        for i = 1:nSlices
            sl{i} = dicominfo(all_d(i).name);
            sl_times(i) = sl{i}.TriggerTime;
            sl_loc(i) = sl{i}.SliceLocation;
        end
        
        % slice_acq_order will be either sequential or interleaved
        [~,slice_acq_order] = sort(sl_times);
        
        sl_acq_direction = [];
        if diff(sl_loc(1:2))>0
            sl_acq_direction = 'ascending';
        elseif diff(sl_loc(1:2))<0
            sl_acq_direction = 'descending';
        end
        
        
        
        % type of scan sequence
        %         from here: http://dicomlookup.com/lookup.asp?sw=Ttable&q=C.8-4
        % Description of the type of data taken. Enumerated Values: SE = Spin Echo
        % IR = Inversion Recovery GR = Gradient Recalled EP = Echo Planar RM = Research Mode
        % Note: Multi-valued, but not all combinations are valid (e.g. SE/GR, etc.).
        scan_seq = d.ScanningSequence;  % pulse sequence type (e.g., gradient/spin echo, EPI/spiral)
        
        % phase encoding direction
        % this field returns either row or col; not sure what this means in terms
        % of A >> P or P >> A...
        phase_encode_direction = d.InPlanePhaseEncodingDirection; % phase encode direction (e.g., A-P)
        
        
        clear sl all_d d i sl sl_loc sl_times
        
        
    case 't1'                   % t1-weighted data
        
        
        
    case 'dw'                   % diffusion-weighted
        
        
    case 'fmap'                 % fieldmap
        
    otherwise
        disp('dataType must be specified')
        
end

%% save variables into a structural array for output

a = struct();





% * note on 'nominal' spatial resolution: is 'nominal because this is the
% width of the estimated point-spread function (PSF), but this doesn't take
% into account the effects of in vivo image degradation.




