resDir=getenv('RES_DIR');

resx = readtable(strcat(resDir,'/results-hp-mr.csv'));

resx.estimate = exp(1.6*resx.estimate);
resx.lower = exp(1.6*resx.lower);
resx.upper = exp(1.6*resx.upper);


colx = '[0.7 0 0.7]';
mcol = 'black';


h=figure; 


plot([1 3.5], [1 1], '--'); hold on;

%% full GRS
ix = find(strcmp(resx.test,'grs')==1);
i=1;
plot([i i], [resx.lower(ix) resx.upper(ix)], '-', 'color', colx, 'LineWidth', 5); hold on;
h1=plot(i, resx.estimate(ix), 'o', 'color', mcol, 'markersize', 10, 'MarkerFaceColor', mcol); hold on;


%% 0.05 threshold
ix = find(strcmp(resx.test,'grs0_05_hp')==1);
i=2;
plot([i i], [resx.lower(ix) resx.upper(ix)], '-', 'color', colx, 'LineWidth', 5); hold on;
h1=plot(i, resx.estimate(ix), 'o', 'color', mcol, 'markersize', 10, 'MarkerFaceColor', mcol); hold on;

ix = find(strcmp(resx.test,'grs0_05_nonhp')==1);
i=2.3;
plot([i i], [resx.lower(ix) resx.upper(ix)], '-', 'color', colx, 'LineWidth', 5); hold on;
h1=plot(i, resx.estimate(ix), 'o', 'color', mcol, 'markersize', 10, 'MarkerFaceColor', mcol); hold on;


%% 0.001 threshold
ix = find(strcmp(resx.test,'grs0_001_hp')==1);
i=3;
plot([i i], [resx.lower(ix) resx.upper(ix)], '-', 'color', colx, 'LineWidth', 5); hold on;
h1=plot(i, resx.estimate(ix), 'o', 'color', mcol, 'markersize', 10, 'MarkerFaceColor', mcol); hold on;

ix = find(strcmp(resx.test,'grs0_001_nonhp')==1);
i=3.3;
plot([i i], [resx.lower(ix) resx.upper(ix)], '-', 'color', colx, 'LineWidth', 5); hold on;
h1=plot(i, resx.estimate(ix), 'o', 'color', mcol, 'markersize', 10, 'MarkerFaceColor', mcol); hold on;



xlabel('Genetic risk score');
ylabel('Odds ratio');


set(gca, 'XTick',[1 2.0 2.3 3.0 3.3]);
set(gca,'XTickLabel',{'Full', 'GRS 0.05 HP', 'GRS 0.05 non-HP', 'GRS 0.001 HP', 'GRS 0.001 non-HP'});
xtickangle(40);

saveas(h, strcat(resDir,'/results-crp-hp.pdf'));


