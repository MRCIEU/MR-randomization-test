

resDir=getenv('RES_DIR');


% basic graph options
colorx = {'[0.8 0.2 0.2]';'blue';'[0.2 0.8 0.2]';'[0.5 1 0.5]';'[0.9 0.85 0.2]'};
facecolorx = {'white';'white';'white';'white';'white'};
markersx = {'s';'^';'o';'v';'d'};
markersizex = 11;


%%%%
%%%% 10 covariates affect selection

allx = dataset('file', strcat(resDir, '/sims/selection/sim-resFIX-poisson.csv'), 'delimiter', ',');


% sim params
all_ncs=[2,10,50];
all_ncNOTs=[2,10,50];
all_rCovars=[0,0.2,0.4,0.8,-1];
all_rSelection=[0.05, 0.1, 0.2];
all_ivEffect=[0.05];
all_covarsIncluded=[1];

for m=1:length(all_ncs)

for k=1:length(all_rSelection)

for e=1:length(all_ivEffect)

for c=1:length(all_covarsIncluded)

h=figure('DefaultAxesFontSize',14);

% plot results for each ncnots and corr combination
for i=1:length(all_ncNOTs)
	for j=1:length(all_rCovars)

		ncs = all_ncs(m)
		rSel = all_rSelection(k)
		ncNOTs=all_ncNOTs(i)
		rCovars=all_rCovars(j)
		ivEffect=all_ivEffect(e)
		covarsIncluded=all_covarsIncluded(c);

		posx=i+(j-1)*0.17;

		ix = find(allx.ncs==ncs & allx.ncNotS == ncNOTs & allx.rCovars ==rCovars & allx.rSelection == rSel & allx.ivEffect == ivEffect & allx.covarsIncluded == covarsIncluded & allx.covar == "all");

		length(ix)
		if (length(ix)>0)

		% branson
		lower=allx.mean(ix) - 1.96*allx.sd(ix);
		upper=allx.mean(ix) + 1.96*allx.sd(ix);
		hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', colorx{1}, 'linewidth', 3);
		hold on; h1=plot(posx, allx.mean(ix), markersx{j}, 'MarkerFaceColor', facecolorx{1}, 'MarkerEdgeColor', colorx{1}, 'MarkerSize', markersizex);

		hx(j) = h1;

		end

	end
end

% set xaxis values
labelx = all_ncNOTs;
set(gca,'XTickLabel', labelx);
set(gca,'XTick', [1.5;2.5;3.5]);


set(gcf, 'unit', 'inches');
figure_size =  get(gcf, 'position');


% set axis labels
xlabel('Number of covariates not affecting selection', 'FontSize', 14);
ylabel('Beta (log risk ratio)');

ylim([-0.4 0.1]);




lx=legend([hx], {'corr=0';'corr=0.2';'corr=0.4';'corr=0.8';'corr=normal'}','Location','NorthEastOutside');
% stop figure becoming narrower when legend is outside plot, by changing overall size to the original figure size plus the legend size
set(lx, 'unit', 'inches');
legend_size = get(lx, 'position');
figure_size(3) = figure_size(3) + legend_size(3);
set(gcf, 'position', figure_size);



pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

% save to file
filename=strcat(resDir, '/sims/selection/fig-sim-selection-poisson',num2str(ncs),'-rSel',num2str(rSel),'-ivEffect',num2str(ivEffect),'-covars',num2str(covarsIncluded),'.pdf')
saveas(h, filename);


end

end

end

end
