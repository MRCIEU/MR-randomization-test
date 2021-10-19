
source('../../../1-sims/generic-functions/numIndependentTests.R')



dataDir=Sys.getenv('PROJECT_DATA')
resDir=Sys.getenv('RES_DIR')


## get covars

covars = read.table(paste0(dataDir, '/phenotypes/derived/phenos-hp.csv'), header=1, sep=',')


## full set

print("Covariate set will all covariates")

corx = cor(covars[,c("age", "male","smoke","neurot_score","hasDepression","eduyears", "townsend")], use="pairwise.complete.obs")
corx = as.data.frame(corx)

nx = numIndependentTests(corx)
print(nx)



## age sex only

print("Covariate set with age and sex only")

corx = cor(covars[,c("age", "male")], use="pairwise.complete.obs")
corx = as.data.frame(corx)

nx = numIndependentTests(corx)
print(nx)
