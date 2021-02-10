

###
### simulation to test Branson complete randomization approach

##
## we use the same (non standard!) notation as in the Branson paper:
## instrument Z, exposure D, covariates X and outcome Y

#### If one x affect z, does it matter how many other x's are considered
#### e.g. does including more x's reduce the power to detect that the IV is 
#### not completely randomized

source('doSim.R')

set.seed(123456)

resDir=Sys.getenv('RES_DIR')


## z is a snp dosage IV with 3 levels
## d is a binary exposure
## y is a continuous outcome

### is the p value correct when there are dependencies between the covariates

# number in sample
numCovarsX=10

cat("corrX, i, permP", file=paste0(resDir, "/sims/branson-corr-out.txt"),sep="\n", append=FALSE)

# try different numbers of covariates, with always only one determinant of z
for (corrX in c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9)) {
  
  print('-------------------')
  print(paste0("Number of covariates that affect IV z: ", numCovarsX))
  print(paste0("Correlation between covariates: ", corrX))
  
  # number of covariates that affect z
  nXAffectZ = 1

  for (i in 1:500) {
  
    pvalue = doSim(numCovarsX, corrX)
  
    cat(paste0(corrX,",", i, ",",pvalue), file=paste0(resDir, "/sims/branson-corr-out.txt"),sep="\n", append=TRUE)
  
  }

}




