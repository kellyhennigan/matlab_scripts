%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % % % % % % % % % % % % % % % %
% C %%%%%%%% L %%%%%%%% R %%%%%%%%%
% %%%% O %%%%%%%% O %%%%%%%% S %%%%
% % % % % % % % % % % % % % % % % %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mycolors = gimmecolor(showGrayScale)

% find nice palettes here: http://www.colourlovers.com/web/palettes/search/new

if (~exist('showGrayScale','var') || isempty(showGrayScale))
    showGrayScale = 0;
end


%% check out some nice looking color schemes

mycolors = {};
% 
% % reds
% mycolors{1} = [
% 255, 245, 240
% 254, 224, 210
% 252, 224, 210
% 252, 146, 114
% 251, 106, 74
% 239, 59, 44
% 203, 24, 29
% 153, 0, 13]./255;
% 
% % purples
% mycolors{2} = [
% 252, 251, 253
% 239, 237, 245
% 218, 218, 235
% 188, 189, 220
% 158, 154, 200
% 128, 125, 186
% 106, 81, 163
% 74, 20, 134]./255;
% 
% % greens
% mycolors{3} = [
% 247, 252, 245
% 229, 245, 224
% 199, 233, 192
% 161, 217, 155
% 116, 196, 118
% 65, 171, 93
% 35, 139, 69
% 0, 90, 50]./255;

% Tyler
mycolors{end+1} = [
    56 17 36
    255 255 255
    167 196 0
    255 18 5
    5 5 5]./255

% blabla
mycolors{end+1} = [
    243 228 9
    242 246 249
    23 113 181
    16 77 124]./255;

% gunnar
mycolors{end+1} = [
    1 22 41
    247 248 30
    23 102 109
    205 251 249
    254 63 37]./255;

% red, orange, blue, greenish blue
mycolors{4} = [
    255 0 51
    9 68 242
    247 101 2
    50 163 181]./255;

% striatum colors?
mycolors{end+1} = [
    244 101 7
    249 197 20
    44 129 162]./255;

% 1: NAcc, 2: Caudate, 3: Putamen
mycolors{end+1} = [
    243 10 0
    249 197 20
    94 154 4]./255;

% dorsal / ventral tier colors?
mycolors{end+1} = [
    244 101 7
    44 129 162]./255;

mycolors{end+1} = [
    174 172 247
    88 84 168
    98 66 151
    217 88 207
    85 30 112
    155 40 191]./255;

% its like that y'all
mycolors{end+1} = [
    235, 231, 228 
    53, 230, 156
    153, 217, 15
    255, 87, 54
    49, 73, 94]./255;

mycolors{end+1} = [
    26, 25, 59
    29, 46, 69
    34, 99, 81
    167, 196, 0
    255, 98, 0]./255;

mycolors{end+1} = [
    56, 25, 49
    187, 33, 90
    204, 136, 10
    161, 177, 150
    70, 148, 126]./255;

mycolors{end+1} = [
     23 113 181
    16 77 124
    34, 99, 81
    70, 148, 126
    155 142 28
    242 173 10
    255, 98, 0
    223 62 44
    187, 33, 90
    136 22 112]./255;


%% plot colors

for i = 1:size(mycolors,2)
    theseColors = mycolors{i}; % colors to plot
    nColors = size(theseColors,1); % # of these colors
    w = 1 : nColors;
    if (showGrayScale)
        w(2,:) = w + nColors;    % also show colors grayscaled 
        theseColors = [theseColors; rgb2gray(theseColors)];
    end
    figure(i), clf;
    title(['mycolors{' num2str(i) '}'])
    colormap(theseColors)
    image(w)
    axis off
%     disp('Press any key to continue...')
%     waitforbuttonpress
end


%% density plot ideas
%
%     % use imagesc
%     z=peaks;  % demo data
%     figure(3)
%     clf;
%     niter=1;
%     method='bilinear';
%     y=interp2(z,niter,method);
%     imagesc(y);
%     cmap = summer(256)
%     figure(3)
%     clf;
%     colormap(cmap)
%     imagesc(y);
%
%     % scatter plot
%
%     % 3-d scatter plot??
%
%     for i = 1:length(fibersNAcc{1})
%         naccEnds(:,i) = fibersNAcc{1}{i}(:,1);
%     end
%
%     for i = 1:length(fibersPut{1})
%         putEnds(:,i) = fibersPut{1}{i}(:,1);
%     end
%
%
%     scatter3(naccEnds(1,:), naccEnds(2,:),naccEnds(3,:),'filled')
%     hold on
%     colormap(autumn)
%     scatter3(putEnds(1,:), putEnds(2,:),putEnds(3,:),'filled')
%
%

