
resDir=getenv('RES_DIR');


% basic graph options
colorx = {'[0.8 0.2 0.2]';'blue'};
facecolorx = {'white';'white'};
markerEdgecolorx = {'[0.8 0.2 0.2]';'[0.4 0.0 0.0]';'[0.4 0.0 0.2]'; '[1.0 0.5 0.5]'; '[0.1 0.1 0.6]'; '[0.5 0.8 0.0]'; 'magenta';'cyan'};
markersx = {'s';'^';'o';'v';'d'};
markersizex = 11;


%%%%
%%%% 10 covariates affect selection

allx = dataset('file', strcat(resDir, '/sims/sim-res.csv'), 'delimiter', ',');

% convert to numeric (needed because when not all sim results are there then NaN'a mean the columns are strings)
allx.powerBranson = str2double(allx.powerBranson);
allx.mcseBranson = str2double(allx.mcseBranson);
allx.powerBon = str2double(allx.powerBon);
allx.mcseBon = str2double(allx.mcseBon);

h=figure('DefaultAxesFontSize',14);
ncs = 10;

% sim params
all_ncNOTs=[1,5,10,20,40];
all_corr=[0,0.1,0.2,0.4,0.8];


% plot results for each ncnots and corr combination
for i=1:length(all_ncNOTs)
	for j=1:length(all_corr)

		ncNOTs=all_ncNOTs(i);
		corr=all_corr(j);

		posx=i+(j-1)*0.1;

		ix = find(allx.ncs==ncs & allx.ncNOTs == ncNOTs & allx.corrs ==corr);

		% branson
		lower=allx.powerBranson(ix) - allx.mcseBranson(ix);
		upper=allx.powerBranson(ix) + allx.mcseBranson(ix);
		hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', colorx{1}, 'linewidth', 3);
		hold on; h1=plot(posx, allx.powerBranson(ix), markersx{j}, 'MarkerFaceColor', facecolorx{1}, 'MarkerEdgeColor', colorx{1}, 'MarkerSize', markersizex);

		hxBran(j) = h1;

		% bonferroni
		posx = posx+0.02;
		lower=allx.powerBon(ix) - allx.mcseBon(ix);
                upper=allx.powerBon(ix) + allx.mcseBon(ix);
		hold on; h1=plot([posx,posx], [lower, upper], '-', 'color', colorx{2}, 'linewidth', 3);
                hold on; h1=plot(posx, allx.powerBon(ix), markersx{j}, 'MarkerFaceColor', facecolorx{2}, 'MarkerEdgeColor', colorx{2}, 'MarkerSize', markersizex);

		hxBon(j) = h1;

	end
end

% set xaxis values
labelx = {'1';'5';'10';'20';'40'};
set(gca,'XTickLabel', labelx);
set(gca,'XTick', [1.1;2.1;3.1;4.1;5.1]);

% set legend box
lx=legend([hxBran,hxBon], {'Branson corr=0';'Branson corr=0.1';'Branson corr=0.2';'Branson corr=0.4';'Branson corr=0.8';'Bonf corr=0';'Bonf corr=0.1';'Bonf corr=0.2';'Bonf corr=0.4';'Bonf corr=0.8'});
lx.FontSize = 12;

% set axis labels
xlabel('Number of covariates not affecting selection', 'FontSize', 14);
ylabel('Statistical power (Monte Carlo SE)');

% save to file
saveas(h, strcat(resDir, '/sims/fig-sim-selection-10.pdf'));
