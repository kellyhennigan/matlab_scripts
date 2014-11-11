function varlist2(X,Y,varargin)
fprintf('Total number of inputs = %d\n',nargin);
fprintf('Total number of vararg inputs = %d\n',length(varargin));

nVarargs = length(varargin);
fprintf('Inputs in varargin(%d):\n',nVarargs)
for k = 1:nVarargs
    iscell(varargin{k})
%    fprintf(num2str(k),'\n')
%     fprintf('   %d\n', varargin{k})
end