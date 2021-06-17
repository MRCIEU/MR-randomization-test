

###
### simulation to test Branson complete randomization approach

##
## Notation: instrument Z, exposure X, covariates C and outcome Y



# nc: the number of covariates included as candidates
# ncs: the number of covariates that affect selection
# corrC: correlation between covariates
doSimSelection <- function(nc, ncs, corrC, totalEffectSelection, iv, ivEffect) {

 
  print('-------------------')
  print(paste0("Number of covariates that affect selection: ", ncs, " of ", nc))
  print(paste0("Correlation between covariates: ", corrC))


  ##
  ## generate sim data

  ## z is a snp dosage IV with 3 levels
  ## x is a binary exposure
  ## y is a continuous outcome

  # number in sample
  n = 350000
  source('generateSimData.R')
  simdata = generateSimData(n=n, nc=nc, ncs=ncs, corrC=corrC, totalEffectSelection=totalEffectSelection, ivEffect=ivEffect, ivType=iv)
    
  
  ###
  ### calculate test statistic - Mahalanobis distance

  # computationally efficient to generate once rather than for each permutation
  covDFC = solve(as.matrix(stats::cov(simdata$dfC)))
  
  t = as.numeric(getMD3CatsCorr(simdata$dfC, simdata$z, covDFC))



  ###
  ### independent tests regressing X on Z

  individualPvalues = c()
  for (i in 1:nc) {

    sumx = summary(lm(simdata$dfC[,i] ~ simdata$z))

    pvalue = sumx$coefficients['simdata$z','Pr(>|t|)']
    print(paste0('i: ', pvalue, ', adjusted:', pvalue*nc))

    individualPvalues = c(individualPvalues, pvalue)

  }

  bonfReject = (min(individualPvalues)*nc)<0.05


  ## Reject using actual number of independent tests (from correlation)
  numIndepTests = 1+(nc-1)*(1-corrC)
  pThresh = 0.05/numIndepTests
  indtReject = min(individualPvalues)<pThresh

  




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
    testStatPerm = getMD3CatsCorr(simdata$dfC, zperm, covX.inv=covDFC)
    
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
  
  return(c(pvalue, individualPvalues, bonfReject, indtReject))

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

