
resDir=getenv('RES_DIR');


for i=0:0.1:0.9

  allx = dataset('file', strcat(resDir, '/sims/mdtest',num2str(i),'.csv'), 'delimiter', ',');

  h=figure('DefaultAxesFontSize',14);
  plot(allx.mymd, allx.md, '.')

  % set axis labels
  ylabel('md');
  xlabel('mymd');

  % save to file
  saveas(h, strcat(resDir, '/sims/plottest',num2str(i),'.pdf'));



  h=figure('DefaultAxesFontSize',14);
  plot(allx.mymd, allx.mymdcor, '.')

  % set axis labels
  ylabel('mymdcor');
  xlabel('mymd');

  % save to file
  saveas(h, strcat(resDir, '/sims/plottest4',num2str(i),'.pdf'));


  h=figure('DefaultAxesFontSize',14);
  plot(allx.md, allx.mymdcor, '.')

  % set axis labels
  ylabel('mymdcor');
  xlabel('md');

  % save to file
  saveas(h, strcat(resDir, '/sims/plottest5',num2str(i),'.pdf'));


end
