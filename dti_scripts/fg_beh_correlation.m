% test correlation between behavioral measures and pathway measures

% plot the most significant correlation
% plot individual subject fiber group measures

%%  define directories, files, params, etc. for correlation test

clear all
close all

omitSubs = {}; % different scan sequence used for sa07 or sa11

scaleToTest = 'NS2';

target_roi1 = 'DA';
target_roi2 = 'nacc';
nNodes = 20;
RorL = 'R'; % options are R, L, or RL
fgMeasureToTest = 'MD'; % options are FA, MD, AD, or RD
fgMeasureToPlot = 'FA';

alpha = .05; % significance threshold
mc_correct = 0; % 1 to correct for multiple comparisons, 0 to leave uncorrected
cmap_val = 'r'; % either p or r for value to use for colormap

subjects = getSASubjects('dti');
% alphaFWE = .0009; % alphaFWE for testing FA and MD values of the three pathways

%% plot params and labels

saveFig =0;   % 1 to save figs to outDir otherwise 0
outDir = '/home/kelly/ShockAwe/figs/fg_tci_corr';




%% get tci data

cd ~/ShockAwe/data/tci_scores

load('tci_scores.mat');
tci_scores(18,:)=nanmean(tci_scores);
% indx = ~isnan(tci_scores(:,2));
indx =ismember(tci_subjects,subjects);
% indx = logical(double(indx).*double(omitIndx));
tci_subjects = tci_subjects(indx);
tci_scores = tci_scores(indx,:);

scoreIndx = strmatch(scaleToTest,tci_scaleLabels,'exact');
scores = tci_scores(:,scoreIndx);
zscores = zscore(scores);

%%  get fiber group measures

cd ~/ShockAwe/data/fgMeasures

load([target_roi1,'_',target_roi2,'_',num2str(nNodes),'nodes',RorL,'.mat']);

subIndx = ismember(subjects',tci_subjects);
subjects = subjects(subIndx);
nSubs = length(subjects);

for f = 1:length(fgMeasures)
    fgMeasures{f} = fgMeasures{f}(subIndx,:);
end
fgTestIndx = strmatch(fgMeasureToTest,fgMLabels,'exact');
thisMeasure = fgMeasures{fgTestIndx};

fgPlotIndx = strmatch(fgMeasureToPlot,fgMLabels,'exact');
thisMeasurePlot = fgMeasures{fgPlotIndx};


%% correlation tests

for n = 1:nNodes
    [r(n),p(n)] = corr(thisMeasure(:,n),scores);
end

% find the strongest correlation
[best_p,best_node] = min(p)
p_indx = find(p<=alpha);
bestMeasure = thisMeasure(:,best_node);

% correct for multiple comparisons
if(mc_correct==1)
[alphaFWE statFWE clusterFWE stats] = AFQ_MultiCompCorrection_kh(thisMeasure,scores,alpha,[]);
mc_sig = best_p<=alphaFWE;
fig_text = sprintf('node %d; r = %3.2f; p = %3.4f (uncorrected), alphaFWE = %3.4f',...
    best_node,r(best_node),best_p,alphaFWE);
else
    fig_text = sprintf('node %d; r = %3.2f; p = %3.4f (uncorrected),',...
    best_node,r(best_node),best_p);

end
%% plot strongest correlation

fig(1)=figure; hold on;

plot(zscores,zscore(bestMeasure),'.','MarkerSize',20,'color','k')
x = [min(zscores)+.25, max(zscores)-.25];
xlim([x(1)-.5 x(end)+.5])
y = x.*r(best_node);
plot(x,y,'LineWidth',2.5,'color','k')

set(gcf,'Color','w');
xlabel([scaleToTest, ' z-scores'],'fontName','Helvetica','fontSize',14)
ylabel([fgMeasureToTest, ' z-scores'],'fontName','Helvetica','fontSize',14)
title(fig_text,'fontName','Helvetica','fontSize',14)
set(gca,'fontName','Helvetica','fontSize',14)
hold off


%% plot fa values and mean diffusivity values
% 
colors=solarizedColors(nSubs);

% sort subject order by personality scores for plotting
[sortedScores,sortIndx] = sort(scores);

titleStr = [target_roi1,'-',target_roi2,' fiber group measures'];
for f = 1:length(fgMeasures)
% for f = 1:2
    fig(f+1) = figure;
    hold on;
    set(gcf,'Color','w');
    for k = 1:nSubs
        s=plot(1:nNodes,fgMeasures{f}(sortIndx(k),:),'color',colors(k,:),'Linewidth',2.5);
    end
    title(titleStr)
    xlabel('fiber group nodes')
    ylabel(fgMLabels{f})
    xlim([.5,nNodes+.5])
    yL = ylim;
    if f==fgTestIndx
        for k = 1:length(p_indx)
            text(p_indx(k),yL(2)-.05,'*','FontSize',24,'HorizontalAlignment','center');
        end
    end
    legend(subjects(sortIndx))
    hold off
end


%% 

cmap_vals = r;
cmap_range = [-.5 .5];
h=dti_plotCorr(thisMeasure,cmap_vals,cmap_range);

%% save figs

if saveFig==1   % then save correlation figure
    cd(outDir)
    
    %     for ff=1:length(fig)
    figure(1);
    set(gcf,'Color','w','InvertHardCopy','off','PaperPositionMode','auto');
    saveas(gcf,[target_roi1,'-',target_roi2,RorL,'_',fgMeasureToTest,'_',scaleToTest,'_corr'],'epsc');
      saveas(gcf,[target_roi1,'-',target_roi2,RorL,'_',fgMeasureToTest,'_',scaleToTest,'_corr'],'png');
  
    %     end

  figure(4)
  ylabel('Mean diffusivity')
    set(gcf,'Color','w','InvertHardCopy','off','PaperPositionMode','auto');
    saveas(gcf,[target_roi1,'-',target_roi2,RorL,'_',fgMeasureToTest,'_',scaleToTest,'_corr_cmap'],'epsc');
   saveas(gcf,[target_roi1,'-',target_roi2,RorL,'_',fgMeasureToTest,'_',scaleToTest,'_corr_cmap'],'png');
   end
% % % get md values for each subject at the fiber group peak in FA
% [fa_vals,peak_indx] = max(allFa(:,6:11),[],2)
% peak_indx = peak_indx+5
%
% md_faPeak = allMd(peak_indx);
% [r_peak,p_peak]=corr(scores,md_faPeak)
%
%
%

