
dataDir=Sys.getenv('PROJECT_DATA')
resDir=Sys.getenv('RES_DIR')

source('../../../1-sims/b-selection-bias/doRandomizationTest.R')
source('../../../1-sims/generic-functions/getMahalanobisDist.R')
source('../../../1-sims/generic-functions/numIndependentTests.R')


args = commandArgs(trailingOnly=TRUE)

covarSet=args[1]


sink(paste0(resDir, '/crp-selection-',covarSet,'.log'))


## get covars

covars = read.table(paste0(dataDir, '/phenotypes/derived/phenos-selection.csv'), header=1, sep=',')

## get IV - CRP GRS

zDF = read.table(paste0(dataDir, '/genetic/crp-grs-with-phenoIDs-subset.csv'), header=1, sep=',')
#z = zDF[,"crp_grs",drop=FALSE]


# get IV and covar data for participants that exist in both, ordered the same
alldata = merge(covars, zDF, by='eid', all.x=F, all.y=F)

# for selection randomization test, z is a vector
z = alldata[,"crp_grs"]

if (covarSet == "agesex") {
  covars = alldata[,c("age", "male")]
} else if (covarSet == "all") {
  covars = alldata[,c("age", "male", "height", "northing", "easting", "eduyears", "townsend")]
} else {
  stop(paste0("covarSet arg not valid: ", covarSet))
}


# get inverse covariance matrix used for randomization test
invCovDFC = solve(as.matrix(stats::cov(covars, use="pairwise.complete.obs")))


## run randomization test

print("CRP GRS")
results = doRandomizationTest(covars, z, invCovDFC)
print(results)



zSNP = alldata[,"rs2794520"]
print("CRP CIS SNP rs2794520")
results = doRandomizationTest(covars, zSNP, invCovDFC)
print(results)


sink()

