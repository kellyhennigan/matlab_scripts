function h=dti_plotCorr(fgMeasure,cmap_vals,cmap_range)
%% use Jason's AFQ_plot script to plot fiber group correlation w/tci scores

% test correlation between behavioral measures and pathway measures


%%  define directories, files, params, etc. for correlation test

nNodes=size(fgMeasure,2);
nFibers = size(fgMeasure,1);

interpN=200;

cmap_interp = interp1(1:nNodes,cmap_vals,linspace(1,nNodes,interpN));

% Set the colormap
c = jet(256);
lm = linspace(cmap_range(1), cmap_range(2),256);

% Compute the apropriate color for each point on the tract profile
for k = 1:length(cmap_interp)
    d = [];
    d = abs(cmap_interp(k) - lm);
    [tmp, mcolor(k)] = min(d);
end

%% plot fg measures

% for f = 1:length(fgMeasures)

    figure; hold on;
    for ii = 1 : nFibers
        h(ii) = plot(fgMeasure(ii,:)','-','Color',[.5 .5 .5],'linewidth',2);
    end
    meanTP = mean(fgMeasure);
    meanTP_interp = interp1(1:nNodes,meanTP,linspace(1,nNodes,interpN));
    x = linspace(1,nNodes,interpN);
    % Plot each point on the tract profile a circle of the apropriate color
    for k = 1:interpN
        plot(x(k),meanTP_interp(k),'.','Color',c(mcolor(k),:),'markersize',40);
    end

      set(gcf,'Color','w');
 
    xlim([1,nNodes])
    yL = ylim;
     cbar_vals = linspace(cmap_range(1),cmap_range(2),7);
    cb = colorbar('location','EastOutside')
           set(cb,'YTickLabel',cbar_vals(2:7));
%     cb = colorbar('location','NorthOutside') 
% set(cb,'XTickLabel',cbar_vals(2:7));
 xlabel('pathway node (habenula - ventralDC)')
        set(gca,'fontName','Helvetica','fontSize',14)
%     axis(axisScale);

    % plot an * over significant nodes

%             for k = 1:length(p_indx)
%                 text(p_indx(k),yL(2)-.05,'*','FontSize',24,'HorizontalAlignment','center');
%             end
            
    hold off



% %% Save figures if an output directory is defined
% if saveFigs==1
%     cd(outDir)
%     
%     for ff=1:gcf
%         figure(ff);
%         set(gcf,'Color','w','InvertHardCopy','off','PaperPositionMode','auto');
%         saveas(gcf,[target_roi,RorL,'_',fgMLabels{ff},'_',scaleToTest,'_corr_cmap',],'png');
%     end
% end
