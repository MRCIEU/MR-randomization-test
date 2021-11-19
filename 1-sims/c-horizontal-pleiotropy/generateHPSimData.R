



# nc: the number of covariates included as candidates
# ncHP: the number of covariates that are affected by the HP snps
# corrC: correlation between covariates
generateHPSimData <- function(nc, ncHP, corrC, ivEffect, ivType="dosage", numSnps=2, numHPSnps=1, zCorr=zCorr, seed=seed) {

  ###
  ### load packages

  # use MASS for mvrnorm and polyr functions
  library('MASS')

  source('../generic-functions/generateContinuousY2.R')
  source('generateContinuousX2_HP.R')
  source('../generic-functions/combineDeterminants.R')
  source('../generic-functions/combineDeterminants2.R')
  source('../generic-functions/generateIV.R')
  source('../generic-functions/cor2cov.R')
  source('generateHPCovariates.R')

  ## z is a snp dosage IV with 3 levels
  ## x is a binary exposure
  ## y is a continuous outcome

  ### is the p value correct when there are dependencies between the covariates

  # number in sample
  n = 500000

  
  print('-------------------')
  print(paste0("Number of covariates that are affected by SNPs: ", ncHP, " of ", nc))
  print(paste0("Correlation between covariates: ", corrC))
  

  ###
  ### generate data


  z = generateIV(ivType, n, numSnps)


  ## how to generate covariates with particular correlation and depending on Z *************************
  if (corrC>=0) {
    dfC = generateHPCovarsWithCorr(n=n, nc=nc, ncHP=ncHP, corr=corrC, z=z, numHPSnps=numHPSnps, zCorr=zCorr)
  }
  else {
    dfC = generateHPCovarsWithCorrDistribution(n=n, nc=nc, ncHP=ncHP, corr=corrC, seed=seed, z=z, numHPSnps=numHPSnps, zCorr=zCorr)
  }
  

  ###
  ### calculate effects of covariates on X and Y, fixing the total effect of C_hp and C_not_hp respectively.


  ###
  ### generate continuous exposure x

  # C AND Z ARE DETERMINANTS OF X
  dataX = generateContinuousX2_HP(dfC, z, ncHP, numHPSnps, ivEffect)
  x = dataX$x


  ###
  ### generate continuous outcome y

  # C AND X ARE DETERMINANTS OF Y
  dataY = generateContinuousY2(dfC, x, ncHP)
  y = dataY$y


  ##
  ##  combine into a dataframe


  ###
  ### select subsample
  
  simdata = list(x = x, y = y, z = z, dfC = dfC)  

  return(simdata)
  
}



