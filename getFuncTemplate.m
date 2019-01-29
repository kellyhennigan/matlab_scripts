% Function name 
% ---------------------------------
% usage: say a little about the function's purpose and use here
% 
% INPUT:
%   var1 - integer specifying something
%   var2 - string specifying something 
% 
% OUTPUT:
%   var1 - output
% 
% NOTES: 
% 
% author: Kelly MacNiven, kelhennigan@gmail.com, Nov 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function getFuncTemplate()

fprintf('\n\ncopy and paste the text below for a new function heading:\n\n');

s = ['\n\nFunction name\n'...
    '-------------------------------------------------------------------------\n'...
    'usage: say a little about the function''s purpose and use here\n\n',...
    'INPUT:\n'...
    '  var1 - integer specifying something\n'...
    '  var2 - string specifying something\n\n'...
    'OUTPUT:\n'...
    '  var1 - etc.\n\n'...
    'NOTES:\n\n'...
    'author: Kelly, kelhennigan@gmail.com, '];

fprintf([s,date,'\n\n',repmat('%',1,75)]);
fprintf('\n\n');

