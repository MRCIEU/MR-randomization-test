
resDir=getenv('RES_DIR');


ntests = 1:100;
bonf = 0.05./ntests;

h=figure;
plot(ntests, bonf);
hold on;

for cor = [0.1 0.2 0.4 0.8]

  numIndepTests = 1+(ntests-1)*(1-cor);
  pThresh = 0.05./numIndepTests;

  plot(ntests, pThresh);
  hold on;

end



legend({'cor=0 /bonf';'cor=0.1';'cor=0.2';'cor=0.4';'cor=0.8'}); 
xlabel('Number of covariates');
ylabel('P value threshold');

saveas(h, strcat(resDir, '/sims/thresholdIllust.pdf'));
