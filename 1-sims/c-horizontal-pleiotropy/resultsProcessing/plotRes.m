
resDir=getenv('RES_DIR');


% basic graph options
%colorx = {'[0.8 0.2 0.2]';'blue';'[0.2 0.8 0.2]';'[0.5 1 0.5]'};
colorx = {'[0.8 0.2 0.2]';'blue';'[0.2 0.8 0.2]';'[0.5 1 0.5]';'[0.9 0.85 0.2]'};
facecolorx = {'white';'white';'white';'white';'white'};
markerEdgecolorx = {'[0.8 0.2 0.2]';'[0.4 0.0 0.0]';'[0.4 0.0 0.2]'; '[1.0 0.5 0.5]'; '[0.1 0.1 0.6]'; '[0.5 0.8 0.0]'; 'magenta';'cyan'};
markersx = {'s';'^';'o';'v';'d'};
markersizex = 11;


%%%%
%%%% 10 covariates affect selection

allx = dataset('file', strcat(resDir, '/sims/hp/sim-res.csv'), 'delimiter', ',');


% sim params
all_nchp=[1,5];
all_ncNOThp=[1,5];
all_rCovars=[0,0.2,0.4,0.8,-1];
all_hpEffect=[0.001, 0.005, 0.01];

for a=1:length(all_hpEffect)

    hpEffect = all_hpEffect(a)

    numSNPsHP = 1;
    numSNPsNOTHP = 1;

    % one plot for each numSNPsHP, numSNPsNOTHP combination
    h=figure('DefaultAxesFontSize',14);

    for c=1:length(all_nchp)

      for d=1:length(all_ncNOThp)

	for e=1:length(all_rCovars)

		ncHP = all_nchp(c);
    		ncNotHP = all_ncNOThp(d);

		rCovars=all_rCovars(e);
		ivEffect=0.05;

		posx=2*c+(d-1)+(e-1)*0.1;

		ix = find(allx.ncHP==ncHP & allx.ncNotHP == ncNotHP & allx.numSNPsHP == numSNPsHP & allx.numSNPsNOTHP == numSNPsNOTHP & allx.rCovars == rCovars & allx.ivEffect == ivEffect & allx.hpEffect == hpEffect);

		if (length(ix) > 0) 

		% branson
		lower=allx.powerBranson(ix) - 1.96*allx.mcseBranson(ix);
		upper=allx.powerBranson(ix) + 1.96*allx.mcseBranson(ix);
		hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', colorx{1}, 'linewidth', 3);
		hold on; h1=plot(posx, allx.powerBranson(ix), markersx{e}, 'MarkerFaceColor', facecolorx{1}, 'MarkerEdgeColor', colorx{1}, 'MarkerSize', markersizex);

		hxBran(e) = h1;

		% bonferroni
		posx = posx+0.02;
		lower=allx.powerBon(ix) - 1.96*allx.mcseBon(ix);
                upper=allx.powerBon(ix) + 1.96*allx.mcseBon(ix);
		hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', colorx{2}, 'linewidth', 3);
                hold on; h1=plot(posx, allx.powerBon(ix), markersx{e}, 'MarkerFaceColor', facecolorx{2}, 'MarkerEdgeColor', colorx{2}, 'MarkerSize', markersizex);

		hxBon(e) = h1;

		% number of independent tests based on correlation
                posx = posx+0.02;
                lower=allx.powerIndLi(ix) - 1.96*allx.mcseIndLi(ix);
                upper=allx.powerIndLi(ix) + 1.96*allx.mcseIndLi(ix);
                hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', colorx{4}, 'linewidth', 3);
                hold on; h1=plot(posx, allx.powerIndLi(ix), markersx{e}, 'MarkerFaceColor', facecolorx{4}, 'MarkerEdgeColor', colorx{4}, 'MarkerSize', markersizex);

                hxIndLi(e) = h1;

		% number of independent tests based on correlation
                posx = posx+0.03;
                lower=allx.powerRsq(ix) - 1.96*allx.mcseRsq(ix);
                upper=allx.powerRsq(ix) + 1.96*allx.mcseRsq(ix);
                hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', colorx{5}, 'linewidth', 3);
                hold on; h1=plot(posx, allx.powerRsq(ix), markersx{e}, 'MarkerFaceColor', facecolorx{5}, 'MarkerEdgeColor', colorx{5}, 'MarkerSize', markersizex);

                hxRsq(e) = h1;


		end

	end
      end
    end

% set xaxis values
labelx = {'1,1', '1,5', '5,1', '5,5'};
set(gca,'XTickLabel', labelx);
set(gca,'XTick', [2.1;3.1;4.1;5.1]);


set(gcf, 'unit', 'inches');
figure_size =  get(gcf, 'position');

% set legend box
lx=legend([hxBran,hxBon,hxIndLi,hxRsq], {'Branson corr=0';'Branson corr=0.2';'Branson corr=0.4';'Branson corr=0.8';'Branson corr=normal';'Bonf corr=0';'Bonf corr=0.2';'Bonf corr=0.4';'Bonf corr=0.8';'Bonf corr=normal';'Indep corr=0';'Indep corr=0.2';'Indep corr=0.4';'Indep corr=0.8';'Indep corr=normal';'Rsq corr=0';'Rsq corr=0.2';'Rsq corr=0.4';'Rsq corr=0.8';'Rsq corr=normal';},'Location','NorthEastOutside');

lx.FontSize = 12;

% set axis labels
xlabel('Num HP covars, num non HP covars', 'FontSize', 14);
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
filename=strcat(resDir, '/sims/hp/fig-sim-hp-hpsnp',num2str(numSNPsHP),'-notHPsnp',num2str(numSNPsNOTHP),'-', num2str(hpEffect),'.pdf')
saveas(h, filename);



end

