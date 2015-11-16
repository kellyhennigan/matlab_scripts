function bf = get_spm_bf_derivatives(dt)
% TR = .1;
% [err,bf]=spm_bf(TR);
% 1st col of bf is the hrf function w/default spm parameters; 2nd col is
% the temporal derivative


%       dt = 0.1;             % sample rate in seconds (upsampled)
      [bf,p] = spm_hrf(dt);  % spm's canonical hemodynamic response function
  
%	p(1) - delay of response (relative to onset)	   6
%	p(2) - delay of undershoot (relative to onset)    16
%	p(3) - dispersion of response                      1
%	p(4) - dispersion of undershoot                    1
%	p(5) - ratio of response to undershoot             6
%	p(6) - onset (seconds)                             0
%	p(7) - length of kernel (seconds)                 32


 
    % add time derivative
    %---------------------------------------------------------------
 
        dp     = 1;
        p(6)   = p(6) + dp;
        D      = (bf(:,1) - spm_hrf(dt,p))/dp;
        bf     = [bf D(:)];
        p(6)   = p(6) - dp;
 
        % add dispersion derivative
        %--------------------------------------------------------
        
        dp    = 0.01;
        p(3)  = p(3) + dp;
        D     = (bf(:,1) - spm_hrf(dt,p))/dp;
        bf    = [bf D(:)];
        p(3)  = p(3) - dp;
        
        
        