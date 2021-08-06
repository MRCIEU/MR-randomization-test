
%%% num snps in file
numSnps = 58;



dataDir=getenv('PROJECT_DATA');

% load in snp data
dir=strcat(dataDir, '/genetic/');
x = dlmread(strcat(dir,'snps-all-dosage2.txt'));

% only one column prob because matrix is too big
fprintf('rows: %d, cols: %d \n', size(x,1), size(x,2));

% transpose the snp data so columns are snps and rows are people
x2 = reshape(x, [], numSnps);

fprintf('rows: %d, cols: %d \n', size(x2,1), size(x2,2));

dlmwrite(strcat(dir,'snps-all-dosage-transposed.txt'), x2, 'precision', 8);

exit

