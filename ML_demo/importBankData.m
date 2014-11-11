function [age,job,marital,education,default,balance1,housing,loan,contact,day1,month1,duration,campaign,pdays,previous,poutcome,y] = importBankData(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [AGE,JOB,MARITAL,EDUCATION,DEFAULT,BALANCE1,HOUSING,LOAN,CONTACT,DAY1,MONTH1,DURATION,CAMPAIGN,PDAYS,PREVIOUS,POUTCOME,Y]
%   = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [AGE,JOB,MARITAL,EDUCATION,DEFAULT,BALANCE1,HOUSING,LOAN,CONTACT,DAY1,MONTH1,DURATION,CAMPAIGN,PDAYS,PREVIOUS,POUTCOME,Y]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [age,job,marital,education,default,balance1,housing,loan,contact,day1,month1,duration,campaign,pdays,previous,poutcome,y]
%   = importfile('bank-full.csv',2, 45212);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2014/05/07 11:36:41

%% Initialize variables.
delimiter = ';';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: text (%s)
%   column3: text (%s)
%	column4: text (%s)
%   column5: text (%s)
%	column6: double (%f)
%   column7: text (%s)
%	column8: text (%s)
%   column9: text (%s)
%	column10: double (%f)
%   column11: text (%s)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: text (%s)
%   column17: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%s%s%s%s%f%s%s%s%f%s%f%f%f%f%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
age = dataArray{:, 1};
job = dataArray{:, 2};
marital = dataArray{:, 3};
education = dataArray{:, 4};
default = dataArray{:, 5};
balance1 = dataArray{:, 6};
housing = dataArray{:, 7};
loan = dataArray{:, 8};
contact = dataArray{:, 9};
day1 = dataArray{:, 10};
month1 = dataArray{:, 11};
duration = dataArray{:, 12};
campaign = dataArray{:, 13};
pdays = dataArray{:, 14};
previous = dataArray{:, 15};
poutcome = dataArray{:, 16};
y = dataArray{:, 17};

