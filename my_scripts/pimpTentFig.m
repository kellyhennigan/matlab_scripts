function h = pimpMyFig(h,roiStr,yp,p_vals)

% format a figure

%%%%%%%%%%%%%%%%

% fig colors
% colors=solarizedColors(nSubs);

% figure font
set(gca,'fontName','Helvetica','fontSize',14)

% title string
title([])
%     title('Estimated response of habenula ROI','FontName','Helvetica','FontSize',14)

% x & y-axes limits
xlim([.5,6.5])
yL = ylim;

% if pvals given as input, put in asterisks
  if ~isempty(p_vals)
            if(find(p_vals<=.001))
                idx=find(p_vals<.001);
                for i=1:length(idx)
                    text(idx(i),yp,'***','FontSize',20,'HorizontalAlignment','center');
                end
            end
            if(find(p_vals>.001 & p_vals<=.01))
                idx = find(p_vals>.001 & p_vals<=.01);
                for i=1:length(idx)
                    text(idx(i),yp,'**','FontSize',20,'HorizontalAlignment','center');
                end
            end
            if(find(p_vals>.01 & p_vals<=.05))
                idx = find(p_vals>.01 & p_vals<=.05);
                for i=1:length(idx)
                    text(idx(i),yp,'*','FontSize',20,'HorizontalAlignment','center');
                end
            end
        end

% xlabel
xlabel('time (sec) relative to stimulus onset','FontName','Helvetica','FontSize',14)
set(gca,'XTickLabel',{'0','2','4','6','8','10'})

% ylabel
ylabel('%\Delta BOLD','FontName','Helvetica','FontSize',14)


% legend
 legend('location','northeastoutside')
legend('boxoff')

hc = get(gca,'Children');

set(hc,'Linewidth',2);

set(gca,'box','off');
set(gcf,'Color','w','InvertHardCopy','off','PaperPositionMode','auto');

cd ~/ShockAwe/figs/tents

saveas(gcf,[roiStr,'_tents.eps'],'epsc');
saveas(gcf,[roiStr,'_tents.pdf'],'pdf');

% saveas(gcf,[roiStr,'_tents_no_ask'],'epsc');
% saveas(gcf,[roiStr,'_tents_no_ask'],'png');

%     axis(axisScale); % make axes scaled
%
% color bar?
%      cbar_vals = linspace(cmap_range(1),cmap_range(2),7);
%     cb = colorbar('location','EastOutside')
%            set(cb,'YTickLabel',cbar_vals(2:7));
% %     cb = colorbar('location','NorthOutside')
% set(cb,'XTickLabel',cbar_vals(2:7));


