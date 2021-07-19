



# nc: the number of covariates included as candidates
# ncs: the number of covariates that affect selection
# corrC: correlation between covariates
generateSimData <- function(n, nc, ncs, corrC, totalEffectSelection, ivEffect, ivType="dosage", seed=seed) {

  ###
  ### load packages

  # use MASS for mvrnorm and polyr functions
  library('MASS')

  source('generateContinuousY2.R')
  source('generateContinuousX2.R')
  source('combineDeterminants.R')
  source('combineDeterminants2.R')
  source('generateBinaryS.R')
  source('generateCovariates.R')

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
  ### generate data
  
  if (corrC>=0) {
    dfC = generateCovariatesWithCorrelation(n, nc, corrC)
  }
  else {
    dfC = generateCovariatesWithCorrelationDistribution(n, nc, corrC, seed=seed)
  }

  
  ## generate a IV with 3 categories
  ## use p(A1)=0.8, p(A2)=0.2, dosage probs assuming HWE = (0.8^2, 2*0.8*0.2, 0.2^2) = (0.64,0.32,0.04) 
  if(ivType=="dosage") {
    print('generate dosage IV')
    z = sample(1:3, n, replace=TRUE, prob=c(0.64, 0.32, 0.04))
  } else if (ivType=="grs") {
    print('generate grs IV')
    z = rnorm(n)
  }  
  else {
    stop("ivType not grs or dosage")
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
  
  simdata = list(x = x[which(s == 1)], y = y[which(s == 1)], z = z[which(s == 1)], dfC=dfC[which(s==1),])
  

  return(simdata)
  
}


cor2cov <- function(R, S) {
 sweep(sweep(R, 1, S, "*"), 2, S, "*")
 }

