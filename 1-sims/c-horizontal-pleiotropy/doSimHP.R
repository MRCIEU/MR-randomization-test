

###
### simulation to test Branson complete randomization approach

##
## Notation: instrument Z, exposure X, covariates C and outcome Y



# nc: the number of covariates included as candidates
# ncHP: the number of covariates that are affected by HP SNPs
# corrC: correlation between covariates
# iv = "dosage" or "grs"
# ivEffect: rsq of effect of each snp on exposure
# covarsIncluded: "all" or "half", the number of covars included in randomization test
# numSnps: number of SNPs to use as IVs
# numHPSnps: number of horizontally pleiotropic snps

doSimHP <- function(nc, ncHP, corrC, iv, ivEffect, covarsIncluded, numSnps, numHPSnps, seed) {


  source('../generic-functions/getMahalanobisDist.R')
  source('doHPRandomizationTest.R') 
  source('../generic-functions/numIndependentTests.R')

  print('-------------------')
  print(paste0("Number of covariates that are affected by snps: ", ncHP, " of ", nc))
  print(paste0("Number of snps that affect covariates: ", numHPSnps, " of ", numSnps))
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

  source('generateHPSimData.R')
  simdata = generateHPSimData(nc=nc, ncHP=ncHP, corrC=corrC, ivEffect=ivEffect, ivType=iv, numHPSnps=numHPSnps, numSnps=numSnps, seed=seed)

  print(paste0('number of all covariates:', ncol(simdata$dfC)))
  if (covarsIncluded=="half") {

    dfCHP = simdata$dfC[,1:ncHP, drop=FALSE]
    dfCnotHP = simdata$dfC[,(ncHP+1):nc, drop=FALSE]

    # half the number of covariates are included in tests
    ncHPInc = floor(ncHP/2)
    ncnotHPInc = floor((nc-ncHP)/2)
    ncInc = ncHPInc + ncnotHPInc

    dfCHP = dfCs[,1:ncHPInc, drop=FALSE]
    dfCnotHP = dfCnots[,1:ncnotHPInc, drop=FALSE]

    # combine covars back into data frame
    simdata$dfC = cbind(dfCHP, dfCnotHP)
  }
  else {
    # all covars included in tests
    ncInc = nc
    ncHPInc = ncHP
  }

  print(paste0('number of covariates included in test:', ncol(simdata$dfC)))
  

  ###
  ### calculate test statistic - Mahalanobis distance

  # computationally efficient to generate once rather than for each permutation
  invCovDFC = solve(as.matrix(stats::cov(simdata$dfC)))
  print('inv cov done')

  errorx = FALSE

},
  error=function(cond) {
    print('could not generate inverse covariance matrix from df so trying again')
    print(cond)
  }
)
}

  print('trycatch finished')
  


  results = doHPRandomizationTest(simdata$dfC, simdata$z, invCovDFC)
   
  return(results)

}

