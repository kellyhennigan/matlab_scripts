% % %%%%% notes on eigenvectors and eigenvalues % % based on the useful pca
% tutorial found here: %
% www.cs.otago.ac.nz/cosc453/student_tutorials/principal_components.pdf
% 
% 
%%%%%%%%%%%%%%%%%%%%% eigenvectors
% 
% - can only be found for square matrices
% 
% - not every square matrix has an eigenvector
% 
% - if a n x n matrix does have an eigenvector, it has n of them
% 
% - when an eigenvector of a matrix and that matrix are multipled, the
% resulting vector is a scaled version of that eigenvector
% 
% - all eigenvectors of a transformation matrix are perpendicular to each
% other (i.e., orthogonal)
% 
% - this means that the data can be expressed in terms of these
% eigenvectors, rather than x, y, etc. axes
% 
% 
%%%%%%%%%%%%%%%%%%%%% eigenvalues
% 
% - when an eigenvector of a matrix and that matrix are multipled, the
% resulting vector is a scaled version of that eigenvector. The amount by
% which it is scaled is the eigenvalue


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

% consider the matrix: 
A = [ 2 3; 2 1]

% remember for matrix multiplication,  
%  m x n matrix * n * p matrix = m x p matrix
 
% multiply A by some vector that's not its eigenvector: 
some_v = [1;3]

A*some_v

% now mulitply it by an eigenvector of the transformation matrix A:
ev = [3;2]; 

out_v = A*ev

% note that when a matrix is multiplied by its eigenvector, the resulting
% vector is a scaled version of the eigenvector. The scale factor, which is
% 4 for this example, is the eigenvalue for this eigenvector.
isequal(ev*4,out_v)

% by convention and for the sake of standardization, eigenvectors are
% usually scaled to have a distance equal to 1. To do this with the
% eigenvector in this example, first find the distance of the vector and
% divide it by that amount:

distance = sqrt(ev(1).^2+ev(2).^2) % which equals sqrt(13)

ev_scaled = ev./distance; % so that it equals 1

% Note that scaling the eigenvector doesn't change its corresponding
% eigenvalue:
out_v2 = A*ev_scaled
isequal(ev_scaled*4,out_v2)

% not every square matrix (n x n) has an eigenvector. But for those that
% do, they have n eigenvectors and corresponding eigenvalues. 

% you can get the eigenvectors and values for matrices using this matlab
% command: 

[V,D]=eig(A)

% each column of V is an eigenvector of A, and its corresponding eigenvalue
% is in the corresponding column of D. 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PCA example

%%%%% STEP 1: get some data 

% define some sample data: 
d = [2.5    2.4    2.2
    0.5    0.7    0.4
    2.2    2.9    1.0
    1.9    2.2    2.7
    3.1    3.0    1.2
    2.3    2.7    1.2
    2.0    1.6    0.2
    1.0    1.1    3.7
    1.5    1.6    1.9
    1.1    0.9    3.1];

% or do: 
d = randn(100,3);
d(:,2) = d(:,1)+randn(100,1)./2;


[m,n] = size(d);  % m is # of observations & n is # of dimensions


corr(d)


%%%%% STEP 2: subtract the mean of the data so that the mean=0. This is
%%%%% necessary for PCA to work properly.

d = d - repmat(mean(d),m,1);


%%%%% STEP 3: calculate the covariance matrix for the data

cov_mat = cov(d) % gives square matrix with each dimension's variance on the diagonals


%%%%% STEP 4: calculate eigenvectors and eigenvalues of the cov matrix

[V,D]= eig(cov_mat)


%%%%% STEP 5: choose componenets and form a feature vector

% the eigenvalues tell you how much variance is explained by its
% corresponding eigenvector. So the eigenvector with the highest eigenvalue
% is the principle componenet of the data, and so on. 

% sort eigenvectors by their corresponding eigenvalues (largest - smallest)

[D,idx]=sort(diag(D),'descend') % sorted eigenvalues 
V = V(:,idx) % sorted eigenvectors 

% see the cumulative variance explained by the feature components:
cumsum(D)./sum(D)


% A feature vector is a matrix of the eigenvectors in columns that you wish
% to keep, sorted by eigenvalue size. 

% for dimensionality reduction, you can choose to leave out the
% eigenvectors with the smallest eigenvalues. Threshold for cut off is
% subjective. Here, since the first 2 components explain > 98% of the
% variance in the data, let's drop the last component:
feature_vector = V(:,1:2);


%%%%% STEP 6: derive a new data set in terms of the components in the
%%%%% feature vector

% to do this, matrix multiply data by the feature vector
d_rot = d * feature_vector;


%%%%%%%%%%%%%%%%%% COMPARISON WITH MATLAB'S BUILT-IN PCA FUNCTIONS

%%%%% note that the eigenvectors and eigenvalues above are the same as the
%%%%% coeff & latent output variables using matlab's pca functions: 

[pc,score,latent]=pca(d); % or princomp() gives same output

% pc gives the eigenvectors, sorted by eigenvalue size
% score equals the new data 
% latent gives sorted eigenvalues

%% plot it 

figure
scSize = get(0,'ScreenSize')
setfigurepos([scSize(3)-500 scSize(4)-300 500 300]);

subplot(1,2,1); hold on;
plot(d(:,1),d(:,2),'.');
axis equal;
h1 = drawarrow([0 0],V(:,1)','k-',[],10,'LineWidth',2);
h2 = drawarrow([0 0],V(:,2)','b-',[],10,'LineWidth',2);
legend([h1 h2],{'PC 1' 'PC 2'});
xlabel('Dimension 1');
ylabel('Dimension 2');

subplot(1,2,2); hold on;
plot(d_rot(:,1),d_rot(:,2),'.');
axis equal;
h1 = drawarrow([0 0],[1 0],'k-',[],10,'LineWidth',2);
h2 = drawarrow([0 0],[0 1],'b-',[],10,'LineWidth',2);
legend([h1 h2],{'PC 1' 'PC 2'});
xlabel('Projection onto PC 1');
ylabel('Projection onto PC 2');




