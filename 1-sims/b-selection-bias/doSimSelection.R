

###
### simulation to test Branson complete randomization approach

##
## Notation: instrument Z, exposure X, covariates C and outcome Y



# nc: the number of covariates included as candidates
# ncs: the number of covariates that affect selection
# corrC: correlation between covariates
doSimSelection <- function(nc, ncs, corrC, totalEffectSelection, iv, ivEffect, covarsIncluded, seed) {

 
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
  simdata = generateSimData(n=n, nc=nc, ncs=ncs, corrC=corrC, totalEffectSelection=totalEffectSelection, ivEffect=ivEffect, ivType=iv, seed=seed)


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
  
  t = as.numeric(getMD3CatsCorr(simdata$dfC, simdata$z, invCovDFC))


  ###
  ### independent tests regressing X on Z

  individualPvalues = c()
  for (i in 1:ncInc) {

    sumx = summary(lm(simdata$dfC[,i] ~ simdata$z))

    pvalue = sumx$coefficients['simdata$z','Pr(>|t|)']
    print(paste0('i: ', pvalue, ', adjusted:', pvalue*ncInc))

    individualPvalues = c(individualPvalues, pvalue)

  }

  bonfReject = (min(individualPvalues)*ncInc)<0.05


  ## Reject using actual number of independent tests (from correlation)


  #numIndepTests = 1+(ncInc-1)*(1-corrC)
  #pThresh = 0.05/numIndepTests
  #indtReject = min(individualPvalues)<pThresh

  

  source('numIndependentTests.R')

  corrDFC = as.data.frame(cor(simdata$dfC))
  indepTestNums = numIndependentTests(corrDFC)

  print(paste0('indepMain: ', indepTestNums$indepMain))
  print(paste0('indepLi: ', indepTestNums$indepLi))

  pThreshIndMain = 0.05/indepTestNums$indepMain
  indtRejectMain = min(individualPvalues)<pThreshIndMain

  pThreshIndLi = 0.05/indepTestNums$indepLi
  indtRejectLi = min(individualPvalues)<pThreshIndLi


  ###
  ### permutation testing

  print('### Permutation testing ###')
  
  # distribution of test statistics generated under the null of complete randomization
  permTestStats = c()
  nPerms = 5000

  for (i in 1:nPerms) {
    
    # randomly permute z
    zperm = sample(simdata$z, length(simdata$z), replace=FALSE)
    
    # calculate test statistic on permuted data
    testStatPerm = getMD3CatsCorr(simdata$dfC, zperm, covX.inv=invCovDFC)
    
    # add test stat of permutated data to our empirial distribution of test statistics
    permTestStats = c(permTestStats, testStatPerm)

    if (i%%100==0) print(i)

  }
  
  
  ###
  ### summarise permutation testing null distribution of test statistics
  
  print(paste0('True test statistic: ', t))
  
  print('Summary of null distribution of test statistics (generated with permutation testing):')
  summary(permTestStats)
  
  # generate p value
  pvalue = length(which(permTestStats>=t))/nPerms
  print(paste0("Permutation P value: ", pvalue))
  
  return(c(pvalue, individualPvalues, bonfReject, indtRejectMain, indtRejectLi))

}

getMD3Cats <- function(covars, z, covX.inv) {

	# mean difference across three ordinal categories - treat as continuous
	meanDiffs = rep(NA,ncol(covars))
	for (i in 1: ncol(covars)) {
		covar = covars[,i]
		fit = lm(z ~ covar)
		sumx = summary(fit)
		beta = sumx$coefficients["covar","Estimate"]
		meanDiffs[i] = beta
	}

	md = t(meanDiffs) %*% covX.inv %*% meanDiffs

	return(md)

}


getMD3CatsCorr <- function(covars, z, covX.inv) {

	# mean difference across three ordinal categories - treat as continuous
	meanDiffs = rep(NA,ncol(covars))
	for (i in 1: ncol(covars)) {
		covar = covars[,i]

		meanDiffs[i] = cor(z, covar)*(sd(covar)/sd(z))
	}

	md = t(meanDiffs) %*% covX.inv %*% meanDiffs

	return(md)

}

