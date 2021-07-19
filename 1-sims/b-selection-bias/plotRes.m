
resDir=getenv('RES_DIR');


% basic graph options
colorx = {'[0.8 0.2 0.2]';'blue';'green'};
facecolorx = {'white';'white';'white'};
markerEdgecolorx = {'[0.8 0.2 0.2]';'[0.4 0.0 0.0]';'[0.4 0.0 0.2]'; '[1.0 0.5 0.5]'; '[0.1 0.1 0.6]'; '[0.5 0.8 0.0]'; 'magenta';'cyan'};
markersx = {'s';'^';'o';'v';'d'};
markersizex = 11;


%%%%
%%%% 10 covariates affect selection

allx = dataset('file', strcat(resDir, '/sims/sim-res.csv'), 'delimiter', ',');

% convert to numeric (needed because when not all sim results are there then NaN'a mean the columns are strings)
%allx.powerBranson = str2double(allx.powerBranson);
%allx.mcseBranson = str2double(allx.mcseBranson);
%allx.powerBon = str2double(allx.powerBon);
%allx.mcseBon = str2double(allx.mcseBon);
%allx.powerInd = str2double(allx.powerInd);
%allx.mcseInd = str2double(allx.mcseInd);


% sim params
all_ncs=[2,10,50];
all_ncNOTs=[2,10,50];
all_rCovars=[0,0.2,0.4,0.8,-1];
all_rSelection=[0.05, 0.1, 0.2];
all_ivEffect=[0.05,0.1];
all_covarsIncluded=[1,2];

for m=1:length(all_ncs)

for k=1:length(all_rSelection)

for e=1:length(all_ivEffect)

for c=1:length(all_covarsIncluded)

h=figure('DefaultAxesFontSize',14);

% plot results for each ncnots and corr combination
for i=1:length(all_ncNOTs)
	for j=1:length(all_rCovars)

		ncs = all_ncs(m);
		rSel = all_rSelection(k);
		ncNOTs=all_ncNOTs(i);
		rCovars=all_rCovars(j);
		ivEffect=all_ivEffect(e);
		covarsIncluded=all_covarsIncluded(c);

		posx=i+(j-1)*0.1;

		ix = find(allx.ncs==ncs & allx.ncNotS == ncNOTs & allx.rCovars ==rCovars & allx.rSelection == rSel & allx.ivEffect == ivEffect & allx.covarsIncluded == covarsIncluded);

		% branson
		lower=allx.powerBranson(ix) - 1.96*allx.mcseBranson(ix);
		upper=allx.powerBranson(ix) + 1.96*allx.mcseBranson(ix);
		hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', colorx{1}, 'linewidth', 3);
		hold on; h1=plot(posx, allx.powerBranson(ix), markersx{j}, 'MarkerFaceColor', facecolorx{1}, 'MarkerEdgeColor', colorx{1}, 'MarkerSize', markersizex);

		hxBran(j) = h1;

		% bonferroni
		posx = posx+0.02;
		lower=allx.powerBon(ix) - 1.96*allx.mcseBon(ix);
                upper=allx.powerBon(ix) + 1.96*allx.mcseBon(ix);
		hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', colorx{2}, 'linewidth', 3);
                hold on; h1=plot(posx, allx.powerBon(ix), markersx{j}, 'MarkerFaceColor', facecolorx{2}, 'MarkerEdgeColor', colorx{2}, 'MarkerSize', markersizex);

		hxBon(j) = h1;

		% number of independent tests based on correlation
		posx = posx+0.02;
		lower=allx.powerInd(ix) - 1.96*allx.mcseInd(ix);
		upper=allx.powerInd(ix) + 1.96*allx.mcseInd(ix);
		hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', colorx{3}, 'linewidth', 3);
		hold on; h1=plot(posx, allx.powerInd(ix), markersx{j}, 'MarkerFaceColor', facecolorx{3}, 'MarkerEdgeColor', colorx{3}, 'MarkerSize', markersizex);

		hxInd(j) = h1;

	end
end

% set xaxis values
labelx = all_ncNOTs;
set(gca,'XTickLabel', labelx);
set(gca,'XTick', [1.1;2.1;3.1]);

set(gcf, 'unit', 'inches');
figure_size =  get(gcf, 'position');

% set legend box
lx=legend([hxBran,hxBon,hxInd], {'Branson corr=0';'Branson corr=0.2';'Branson corr=0.4';'Branson corr=0.8';'Branson corr=normal';'Bonf corr=0';'Bonf corr=0.2';'Bonf corr=0.4';'Bonf corr=0.8';'Bonf corr=normal';'Indep corr=0';'Indep corr=0.2';'Indep corr=0.4';'Indep corr=0.8';'Indep corr=normal';},'Location','NorthEastOutside');

lx.FontSize = 12;

% set axis labels
xlabel('Number of covariates not affecting selection', 'FontSize', 14);
ylabel('Statistical power (Monte Carlo SE)');

ylim([0 1]);


% stop figure becoming narrower when legend is outside plot, by changing overall size to the original figure size plus the legend size
set(lx, 'unit', 'inches');
legend_size = get(lx, 'position');
figure_size(3) = figure_size(3) + legend_size(3);
set(gcf, 'position', figure_size);

pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

% save to file
filename=strcat(resDir, '/sims/fig-sim-selection-',num2str(ncs),'-rSel',num2str(rSel),'-ivEffect',num2str(ivEffect),'-covars',num2str(covarsIncluded),'.pdf')
saveas(h, filename);


end

end

end

end
