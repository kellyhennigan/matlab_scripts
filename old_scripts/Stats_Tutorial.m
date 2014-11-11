%% Tutorial with useful examples of regression, plotting, etc.
% 
% got it here: 
% http://vision.psych.umn.edu/users/kallie/matlab/

clear all;

x = dat(:,1);
y = dat(:,2);

% dat is a 100 x 2 matrix 
b = regress(y,[x ones(size(x))]);   % regression coefficients
t = [min(x) max(x)];
yhat = b(1).*t + b(2);

% Publication Quality Graph
figure(2); clf; % explicit figure call and clear figure
plot(x,y,'o','LineWidth',1,'MarkerEdgeColor',...
    'k','MarkerFaceColor','b','MarkerSize',6);

% Add a line
hold on;
plot(t,yhat,'r-','LineWidth',1.5);
hold off;

% Add Labels
title('Scatter Plot of X and Y','FontSize',14);
xlabel('X-data','FontSize',12);
ylabel('Y-data','FontSize',12);

% Rescaling, changing tick marks, and saving graph to file
set(gca,'XTick',[0:.5:2.5],'YTick',[0:.5:2.5],'FontSize',10);
axis([0 2.5 0 2.5]);
set(figure(2),'PaperSize',[4 4],'PaperPosition',[0 0 4 4]);
saveas(figure(2),'myfigure','png');

% Histogram
figure(3); clf;
subplot(2,1,1);
hist(x);
subplot(2,1,2);
histfit(x);

% Bar graphs and errorbars
figure(4); clf;
subplot(1,2,1);
bar([mean(dat)]); hold on;
errorbar(mean(dat),std(dat),'b.','LineWidth',2,'MarkerSize',8);
errorbar(mean(dat),err,'r.','LineWidth',2,'MarkerSize',8); hold off;
subplot(1,2,2);
errorbar(mean(dat),std(dat),'b.','LineWidth',2,'MarkerSize',8); hold on;
errorbar(mean(dat),err,'r.','LineWidth',2,'MarkerSize',8); hold off;
legend('Standard Deviation','Standard Error','Location','NorthWest');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualizing Eigenvectors and Eigenvalues
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Contents
% % 
% %     * Create Bivariate Normal Data
% %     * Calculating Eigenvectors and Eigenvalues
% %     * Visualizing results
% % 

% Eigenvectors and Eigenvalues can be used to describe the variability of multivariate data.

%% Create Bivariate Normal Data
x = randn(334,1);

% Skew x by s, to make two simulated dependent variables y1 and y2
s = [2 2];  % skew factor
y1 = normrnd(s(1).*x,1);
y2 = normrnd(s(2).*x,1);
dat = [y1 y2];

%% Calculating Eigenvectors and Eigenvalues

% Subtract off the means of y1 and y2
mu = mean(dat);
dat = dat - repmat(mu,length(dat),1);

% Using the inner (or dot) product find the eigenvectors and eigenvalues
[v,d] = eig(dat'*dat)   % eigenvectors and eigenvalues

%% Visualizing results

Plot centered data and eigenvectors

figure(1); clf;
plot(dat(:,1),dat(:,2),'b.');   % centered data
hold on;
plot([0 v(1,2)],[0 v(2,2)],'r-');   % first eigenvector
plot([0 v(1,1)],[0 v(2,1)],'g-');   % second eigenvector
hold off;
axis equal; % rescale plot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% More Plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Now, let's load the data and do some operations:

clear all;      % clear workspace
load('/Users/kellyhennigan/Desktop/matlab/dat.mat')

% Playing with matrices

x = dat(:,1);   % not necessary, but makes things more clear for now
y = dat(:,2);   % again, just making two vectors out of one matrix

% Let's see the raw data

figure(1);      % declare a figure (usually not necessary)
clf;            % clear contents of figure (not always necessary)
plot(x,y,'b.'); % plot y versus x, and use blue dots
title('Scatter Diagram');

% Let's look at some histograms of raw data

figure(2); clf;
subplot(2,1,1)
histfit(x,20);
title('Histogram of X Values (with normal density curve)');
xlabel('X-values');
ylabel('Frequency');

subplot(2,1,2)
hist(y,20);
title('Histogram of Y Values','FontSize',14,'Color','r');
xlabel('Y-values','FontSize',12,'Color','b');
ylabel('Frequency','FontSize',12,'Color','b');

% Let's do a paired t-test

hyp = ttest(x,y)                % prints result (0 = null, 1 = alternative)
[h,p,ci,stats] = ttest(x,y);    % more information stored into new variables
% h = result
% p = p-value
% ci = confidence interval
% stats is not any type of matrix (i.e. scalar, vector, n by m matrix)
% instead, it is what Matlab calls a "structure"

% type "stats" to see the elements contained in the structure type "stats.tstat" to return only the value of the t-statistic

% notice that this is a matched pairs t-test. The same result comes from taking the difference between x and y, and testing whether it is different from zero

difference = x-y;   % subtract y from x, and store it in a new variable
% this ttest should be the same as the one above:
[h2,p2,ci2,stats2] = ttest(difference);

% Let's try another ttest with explicit parameters:

[h3,p3,ci3,stats3] = ttest(difference,0,0.01,'both');
% Here, we tested whether "difference" is different than "0", at the 99%
% confidence level. We performed a two-tailed test, indicated by the "both"
% parameter. The defaults are 95% confidence interval and two-tailed.
% Notice that the confidence interval of this t-test is related to our
% p-value, and is therefore different than the confidence intervals found
% above. The t-statistic, and degrees of freedom will naturally stay the
% same.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% More regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % Here, we will perform a simple linear regression on our data, 
% % and plot the regression function. Secondly, we will perform a 
% % regression analysis on normalized z-scores, then visually demonstrate 
% % the relationship between regression and correlation. 

clear all;      % clear workspace
load('/Users/kellyhennigan/Desktop/matlab/dat.mat')

b = regress(dat(:,2),[ones(size(dat(:,1))) dat(:,1)]);  % linear regression
t = [min(dat(:,1)) max(dat(:,1))];                      % x-values for plotting regression line
yht = b(1) + b(2).*t;                                   % y-values for plotting regression line

z = zscore(dat);                % find the z-scores of data (i.e. normalize data)
r = corrcoef(z(:,1),z(:,2));    % find correlation between variables
t2 = [min(z(:,1)) max(z(:,1))]; % x-values for showing z-score correlation
yht2 = t2.*r(2);                % y-values for showing z-score correlation

% scatter diagram (similar to earlier lesson)

figure(1); clf;
subplot(2,1,1);
plot(dat(:,1),dat(:,2),'b.');   % no need to use "x" and "y"
hold on;                        % this tells Matlab we want to add more stuff later
plot(t,yht,'r-');               % plot regression line
text(1.9,.9,['y = ',num2str(b(1)),' + ',num2str(b(2)),'x'],'Color','r'); % show equation
hold off;                       % done plotting
title('Raw Data');
xlabel('x values');
ylabel('y values');
axis([1.2 2.8 .5 3.2]);         % set x-min, x-max, y-min, y-max
set(gca,'XTick',(1.2:.2:2.8));  % show these tick marks
set(gca,'YTick',(.5:.5:3));

subplot(2,1,2);
plot(z(:,1),z(:,2),'b.'); hold on;  % plot z-scores
plot(t2,yht2,'r-');                 % plot correlation as a regression line
text(.5,-2.1,['r = ',num2str(r(2))],'Color','r');   % show correlation coefficient
hold off;
title('Normalized Data');
xlabel('z-score of x');
ylabel('z-score of y');
axis([-2.5 2.7 -3.0 3]);
set(gca,'XTick',(-2.5:1:2.5));
set(gca,'YTick',(-2.5:1:2.5));

set(gcf,'PaperPosition',[0,0,8.5,11]);  % prepare for saving plot to file
saveas(gcf,'scatterplot','pdf');        % save as a pdf
