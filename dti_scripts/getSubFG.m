function subFG = getSubFG(fg, indx)

% this function takes a .pdb fiber structure and a logical index and
% returns the subgroup of fibers as specified by the index


subFG = fg;

subFG.fibers = subFG.fibers(indx);
subFG.pathwayInfo=subFG.pathwayInfo(indx);

for p = 1:length(subFG.params)
    subFG.params{p}.stat = subFG.params{p}.stat(indx);
end