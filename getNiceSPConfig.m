function [r,c] = getNiceSPConfig(n)

% function to return the optimal number of rows and columns given a number
% of subplots for a figure. "Optimal" in the sense that it makes good use 
% of the figure window space, assuming the default window ratio of 4:3 
% (default matlab figure window is 512 pixels in width & 384 in height)

% input: 
%     n - number of subplots you want in a figure

% output:
%     r - number of rows
%     c = number of columns 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r = floor(sqrt(n)); % number of rows
c = ceil(n./r); % number of columns