

###
### simulation to test Branson complete randomization approach

##
## Notation: instrument Z, exposure X, covariates C and outcome Y



# nc: the number of covariates included as candidates
# ncs: the number of covariates that affect selection
# corrC: correlation between covariates
doSimSelection <- function(nc, ncs, corrC, totalEffectSelection, iv, ivEffect, covarsIncluded, all=FALSE, seed, resDir) {

  source('../generic-functions/getMahalanobisDist.R')
  source('doRandomizationTest.R')
  source('../generic-functions/numIndependentTests.R')
  source('testPoisson.R')

  print('-------------------')
  print(paste0("Number of covariates that affect selection: ", ncs, " of ", nc))
  print(paste0("Correlation between covariates: ", corrC))


# Fix because sometimes generating inv cov matrix gave error so dealing with this by trying to generate new data
errorx=TRUE
while (errorx==TRUE) {
out <- tryCatch(
	{

  print('start trycatch')

  ##
  ## generate sim data

  ## z is a snp dosage IV with 3 levels
  ## x is a binary exposure
  ## y is a continuous outcome

  # number in sample
  n = 350000
  source('generateSimData.R')
  simdata = generateSimData(n=n, nc=nc, ncs=ncs, corrC=corrC, totalEffectSelection=totalEffectSelection, ivEffect=ivEffect, ivType=iv, all=all, covarsIncluded=covarsIncluded, seed=seed)

  if (all==TRUE) {
    print('all test interaction start')
    ncNOTs = nc - ncs
    filename=paste0("/sims/sim-out-poisson-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffectSelection, "-iv", iv, ivEffect, '-', covarsIncluded, '-', all, "_", seed, ".txt")
    print('a')
    testPoisson(simdata$s, simdata$x, simdata$dfC[,1:ncs, drop=FALSE], resDir, filename)
    print('b')
  }

  print(paste0('number of all covariates:', ncol(simdata$dfC)))
  if (covarsIncluded=="half") {

    dfCs = simdata$dfC[,1:ncs, drop=FALSE]
    dfCnots = simdata$dfC[,(ncs+1):nc, drop=FALSE]

    # half the number of covariates are included in tests
    ncsInc = floor(ncs/2)
    ncnotsInc = floor((nc-ncs)/2)
    ncInc = ncsInc + ncnotsInc

    dfCs = dfCs[,1:ncsInc, drop=FALSE]
    dfCnots = dfCnots[,1:ncnotsInc, drop=FALSE]

    # combine covars back into data frame
    simdata$dfC = cbind(dfCs, dfCnots)
  }
  else {
    # all covars included in tests
    ncInc = nc
    ncsInc = ncs    
  }

  print(paste0('number of covariates included in test:', ncol(simdata$dfC)))
  

#  ncNOTs = nc - ncs
#  resDir=Sys.getenv('RES_DIR')
#  filename=paste0(resDir, "/sims/dfsim-out-", seed, ".txt")
#  write.table(simdata$dfC, filename, sep=',', row.names=FALSE, col.names=TRUE)
#  print('df written to file')

  ###
  ### calculate test statistic - Mahalanobis distance

  # computationally efficient to generate once rather than for each permutation
  invCovDFC = solve(as.matrix(stats::cov(simdata$dfC)))
  print('inv cov done')

  errorx = FALSE

},
  error=function(cond) {
    print('could not generate inverse covariance matrix from df so trying again')
  }
)
}

  print('trycatch finished')


  
  results = doRandomizationTest(simdata$dfC, simdata$z, invCovDFC)

  return(results)

}

