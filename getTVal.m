function t = getTVal(p,df,tail)

% given a p-value and degrees of freedom, this returns the corresponding t value
% optional input is tail, specifying 1 or 2 tailed test (default is 2)
%
% this is totally unnecessary but I keep forgetting which matlab function
% does this, so whatevs.

if ~exist('tail','var') || isempty(tail)
    tail = 2;
end

if tail==2
    p = p./2;
end

t = tinv(1-p,df);


% to get p values for a given T: 

% pdf('t',3.224,17)