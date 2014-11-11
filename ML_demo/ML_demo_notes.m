% matlab machine learning demo %% 
% 
% example data from:
% http://archive.ics.uci.edu/ml/datasets/Bank+Marketing#

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd '/Users/Kelly/Documents/MATLAB/ML_demo'


% import data
dataFName = 'bank/bank-full.csv';

[age,job,marital,education,default,balance1,housing,loan,contact,day1,month1,duration,campaign,pdays,previous,poutcome,y] = importBankData(dataFName);

