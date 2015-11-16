function Rsq = Rsquared(Y,X,B)

% compute the coefficient of determination Rsquared, 
% Rsquared is the percent variance explained by a model

% Y is a n x 1 column vector
% X is a n X m matrix of regressors 
% B is a m x 1 vector of regressor weights 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Yhat = X*B; % model prediction

% for data Y, regressors X and best fit weights B:

SSy = sum( (Y - mean(Y)).^2 );   % total sum of squares
SSe = sum( (Y - Yhat).^2 );      % residual sum of squares (aka sq error)

Rsq = 100 * (1 - ( SSe / SSy ));      % percent variance explained

