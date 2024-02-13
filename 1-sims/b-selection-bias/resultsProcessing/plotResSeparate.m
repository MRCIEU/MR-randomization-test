

% resFileName is a parameter for this set of results
resFileName
testName

resDir=getenv('RES_DIR');


% basic graph options
%colorx = {'[0.8 0.2 0.2]';'blue';'[0.2 0.8 0.2]';'[0.5 1 0.5]';'[0.9 0.85 0.2]'};
facecolorx = {'white';'white';'white';'white';'white'};
markersx = {'s';'^';'o';'v';'d'};
markersizex = 11;


%%%%
%%%% 10 covariates affect selection

allx = dataset('file', strcat(resDir, '/sims/selection-rSelection0.05_OK/', resFileName, '.csv'), 'delimiter', ',');



% sim params

all_ncs=[2,10,50];
all_covarsIncluded=[1,2];
all_ivEffect=[0.05,0.1];
all_rSelection=[0.05, 0.1, 0.2];

all_ncNOTs=[2,10,50];
all_rCovars=[0,0.2,0.4,0.8,-1];





for m=1:length(all_ncs)

for k=1:length(all_rSelection)

for e=1:length(all_ivEffect)

for c=1:length(all_covarsIncluded)

h=figure('DefaultAxesFontSize',14);
plot([1 4], [0.05 0.05]); hold on;

% plot results for each ncnots and corr combination
for i=1:length(all_ncNOTs)
	for j=1:length(all_rCovars)

		ncs = all_ncs(m)
		rSel = all_rSelection(k)
		ncNOTs=all_ncNOTs(i)
		rCovars=all_rCovars(j)
		ivEffect=all_ivEffect(e)
		covarsIncluded=all_covarsIncluded(c)

		posx=i+(j-1)*0.17;

		ix = find(allx.ncs==ncs & allx.ncNotS == ncNOTs & allx.rCovars ==rCovars & allx.rSelection == rSel & allx.ivEffect == ivEffect & allx.covarsIncluded == covarsIncluded);
		length(ix)
		if (length(ix)>0)

		if (testName == 'bran')
		% branson
		lower=allx.powerBranson(ix) - 1.96*allx.mcseBranson(ix);
		upper=allx.powerBranson(ix) + 1.96*allx.mcseBranson(ix);
		hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', 'blue', 'linewidth', 3);
		hold on; h1=plot(posx, allx.powerBranson(ix), markersx{j}, 'MarkerFaceColor', facecolorx{1}, 'MarkerEdgeColor', 'blue', 'MarkerSize', markersizex);

%		hxBran(j) = h1;
		end

		if (testName ==	'bonf')
		% bonferroni
%		posx = posx+0.03;
		lower=allx.powerBon(ix) - 1.96*allx.mcseBon(ix);
                upper=allx.powerBon(ix) + 1.96*allx.mcseBon(ix);
		hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', 'blue', 'linewidth', 3);
                hold on; h1=plot(posx, allx.powerBon(ix), markersx{j}, 'MarkerFaceColor', facecolorx{2}, 'MarkerEdgeColor', 'blue', 'MarkerSize', markersizex);

%		hxBon(j) = h1;
		end

		if (testName ==	'indl')
		% number of independent tests based on correlation
%                posx = posx+0.03;
                lower=allx.powerIndLi(ix) - 1.96*allx.mcseIndLi(ix);
                upper=allx.powerIndLi(ix) + 1.96*allx.mcseIndLi(ix);
                hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', 'blue', 'linewidth', 3);
                hold on; h1=plot(posx, allx.powerIndLi(ix), markersx{j}, 'MarkerFaceColor', facecolorx{4}, 'MarkerEdgeColor', 'blue', 'MarkerSize', markersizex);

                hxIndLi(j) = h1;
		end


		if (testName == 'indr')
		% number of independent tests based on correlation
%                posx = posx+0.03;
                lower=allx.powerRsq(ix) - 1.96*allx.mcseRsq(ix);
                upper=allx.powerRsq(ix) + 1.96*allx.mcseRsq(ix);
                hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', 'blue', 'linewidth', 3);
                hold on; h1=plot(posx, allx.powerRsq(ix), markersx{j}, 'MarkerFaceColor', facecolorx{5}, 'MarkerEdgeColor', 'blue', 'MarkerSize', markersizex);
		end
		

		end

	end
end

% set xaxis values
labelx = all_ncNOTs;
set(gca,'XTickLabel', labelx);
set(gca,'XTick', [1.5;2.5;3.5]);


set(gcf, 'unit', 'inches');
figure_size =  get(gcf, 'position');

% set legend box
%lx=legend([hxBran,hxBon,hxIndLi], {'GRT corr=0';'GRT corr=0.2';'GRT corr=0.4';'GRT corr=0.8';'GRT corr=normal';'Bonf corr=0';'Bonf corr=0.2';'Bonf corr=0.4';'Bonf corr=0.8';'Bonf corr=normal';'Indep corr=0';'Indep corr=0.2';'Indep corr=0.4';'Indep corr=0.8';'Indep corr=normal';},'Location','NorthEastOutside');

%lx.FontSize = 12;

% set axis labels
xlabel('Number of covariates not affecting selection', 'FontSize', 14);
ylabel('Statistical power (Monte Carlo SE)');

ylim([0 1]);


% stop figure becoming narrower when legend is outside plot, by changing overall size to the original figure size plus the legend size
%set(lx, 'unit', 'inches');
%legend_size = get(lx, 'position');
%figure_size(3) = figure_size(3) + legend_size(3);
%set(gcf, 'position', figure_size);

pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

% save to file
filename=strcat(resDir, '/sims/selection/fig-sim-selection-',testName,'-',resFileName,num2str(ncs),'-rSel',num2str(rSel),'-ivEffect',num2str(ivEffect),'-covars',num2str(covarsIncluded),'.pdf')
saveas(h, filename);


end

end

end

end




%% make legend

h=figure('DefaultAxesFontSize',14);
h1=plot(1,1,markersx{1}, 'MarkerFaceColor', facecolorx{1}, 'MarkerEdgeColor', 'blue', 'MarkerSize', markersizex);
hold on;
h2=plot(2,1,markersx{2}, 'MarkerFaceColor', facecolorx{2}, 'MarkerEdgeColor', 'blue', 'MarkerSize', markersizex);  
hold on;
h3=plot(3,1,markersx{3}, 'MarkerFaceColor', facecolorx{3}, 'MarkerEdgeColor', 'blue', 'MarkerSize', markersizex);
hold on;
h4=plot(4,1,markersx{4}, 'MarkerFaceColor', facecolorx{4}, 'MarkerEdgeColor', 'blue', 'MarkerSize', markersizex);
hold on;
h5=plot(5,1,markersx{5}, 'MarkerFaceColor', facecolorx{5}, 'MarkerEdgeColor', 'blue', 'MarkerSize', markersizex);
hold on;
xlim([0 5]);
ylim([0 5]);

lx=legend([h1,h2,h3,h4,h5], {'Correlation 0.0';'Correlation 0.2';'Correlation 0.4';'Correlations 0.8';'Correlation normal';},'Location','NorthEastOutside');    
set(lx, 'unit', 'inches');


set(gcf, 'unit', 'inches');
figure_size =  get(gcf, 'position');

legend_size = get(lx, 'position');
figure_size(3) = figure_size(3) + legend_size(3);
set(gcf, 'position', figure_size);
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
 

filename=strcat(resDir, '/sims/selection/fig-legend.pdf')
saveas(h, filename);
