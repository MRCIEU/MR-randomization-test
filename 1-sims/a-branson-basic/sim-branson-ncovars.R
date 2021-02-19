

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


cat("numCovars, i, permP", file=paste0(resDir, "/sims/branson-ncovars-out.txt"),sep="\n", append=FALSE)

# number of covariates that affect z
nXAffectZ = 1

# correlation between covariates
corrX = 0

# try different numbers of covariates, with always only one determinant of z
for (numCovarsX in c(1,2,3,4,5,10,20,30,40,50)) {
  
  print('-------------------')
  print(paste0("Number of covariates that affect IV z: ", numCovarsX))
  

  for (i in 1:500) {

    pvalue = doSim(numCovarsX, corrX)
    cat(paste0(numCovarsX,",", i, ",",pvalue), file=paste0(resDir, "/sims/branson-ncovars-out.txt"),sep="\n", append=TRUE)

  }
  
}




