
source('../../../1-sims/generic-functions/numIndependentTests.R')



dataDir=Sys.getenv('PROJECT_DATA')
resDir=Sys.getenv('RES_DIR')


## get covars

covars = read.table(paste0(dataDir, '/phenotypes/derived/phenos-hp.csv'), header=1, sep=',')

corx = cor(covars[,c("smok_pack_years", "bmi", "weight", "leuk_count", "albumin", "apolip_a", "apolip_b", "chol", "glucose", "chol_hdl", "lipo_a", "sbp", "dbp", "waisthip")], use="pairwise.complete.obs")
corx = as.data.frame(corx)


## calculate equivalent number of covariates using spd 
nx = numIndependentTests(corx)
print(nx)
