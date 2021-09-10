



# nc: the number of covariates included as candidates
# ncs: the number of covariates that affect selection
# corrC: correlation between covariates
generateSimData <- function(n, nc, ncs, corrC, totalEffectSelection, ivEffect, ivType="dosage", all=FALSE, covarsIncluded=covarsIncluded, seed, resDir) {

  ###
  ### load packages

  # use MASS for mvrnorm and polyr functions
  library('MASS')

  source('../generic-functions/generateContinuousY2.R')
  source('generateContinuousX2.R')
  source('../generic-functions/combineDeterminants.R')
  source('../generic-functions/combineDeterminants2.R')
  source('generateBinaryS.R')
  source('generateCovariates.R')
  source('../generic-functions/generateIV.R')

  ## z is a snp dosage IV with 3 levels
  ## x is a binary exposure
  ## y is a continuous outcome

  ### is the p value correct when there are dependencies between the covariates

  # number in sample
  n = 920000

  
  print('-------------------')
  print(paste0("Number of covariates that affect selection: ", ncs, " of ", nc))
  print(paste0("Correlation between covariates: ", corrC))
  

  ###
  ### generate IV z

  z = generateIV(ivType, n, numSnps)
  

  ###
  ### generate covariates with specific correlation

  if (corrC>=0) {
    dfC = generateCovariatesWithCorrelation(n, nc, corrC)
  }
  else {
    dfC = generateCovariatesWithCorrelationDistribution(n, nc, corrC, seed=seed)
  }

  

  ###
  ### calculate effects of covariates on X and Y, fixing the total effect of C_s and C_nots respectively.


  ###
  ### generate binary exposure x

  # C AND Z ARE DETERMINANTS OF X
  dataX = generateContinuousX2(dfC, z, ncs, ivEffect)
  x = dataX$x


  ###
  ### generate continuous outcome y

  # C AND X ARE DETERMINANTS OF Y
  dataY = generateContinuousY2(dfC, x, ncs)
  y = dataY$y


  ###
  ### generate binary selection variable s

  # CS AND X ARE DETERMINANTS OF S
  dataS = generateBinaryS(dfC, x, ncs, totalEffectSelection)
  s = dataS$s




  ##
  ##  combine into a dataframe


  ###
  ### select subsample

  if (all == TRUE) {
    simdata = list(x=x, y=y, z=z, dfC=dfC, s=s)
  }
  else {
    simdata = list(x = x[which(s == 1)], y = y[which(s == 1)], z = z[which(s == 1)], dfC=dfC[which(s==1),])
  }

  return(simdata)
  
}


