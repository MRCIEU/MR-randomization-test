

###
### simulation to test Branson complete randomization approach

##
## Notation: instrument Z, exposure X, covariates C and outcome Y



# nc: the number of covariates included as candidates
# ncs: the number of covariates that affect selection
# corrC: correlation between covariates
doSimSelection <- function(nc=100, ncs=100, corrC=0, totalEffectCovarsSelection=10) {

  ###
  ### load packages

  # use MASS for mvrnorm and polyr functions
  library('MASS')

  # lmtest for coeftest
  library('lmtest')

  # ivmodel for Branson Mahalanobis distance test
  library('ivmodel')



  ## z is a snp dosage IV with 3 levels
  ## x is a binary exposure
  ## y is a continuous outcome

  ### is the p value correct when there are dependencies between the covariates

  # number in sample
  n = 350000

  
  print('-------------------')
  print(paste0("Number of covariates that affect selection: ", ncs, " of ", nc))
  print(paste0("Correlation between covariates: ", corrC))
  

  ###
  ### generate data
  
  ## generate covariates C with particular correlation corrC  
  corrCMat = diag(nc)
  corrCMat[which(corrCMat == 0)] = corrC
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
  dfC = as.data.frame(dfC)
  
  ## generate a IV with 3 categories
  z = sample(1:3, n, replace=TRUE, prob=c(0.6, 0.3, 0.1))
  

  ###
  ### calculate effects of covariates on X and Y, fixing the total effect of C_s and C_nots respectively.

  betaCs_onXY = log(2^(1/ncs))
  betaCnots_onXY = log(2^(1/(nc-ncs)))


  ###
  ### generate exposure x

  # if there are covariates not affecting selection generate
  if (ncs!=nc) { 
    logitPart = z + rowSums(betaCs_onXY*dfC[,1:ncs, drop=FALSE]) + rowSums(betaCnots_onXY*dfC[,(ncs+1):nc, drop=FALSE]) 
  } else {
    logitPart = z + rowSums(betaCs_onXY*dfC[,1:ncs, drop=FALSE]) 
  }

  pX = exp(logitPart)/(1+exp(logitPart))
  x = rep(0, 1, n)
  x[runif(n) <= pX] = 1
  

  ###
  ### generate continuous outcome y
  # C AND X ARE DETERMINANTS OF Y

  if (ncs!=nc) {
    y = rowSums(betaCs_onXY*dfC[,1:ncs, drop=FALSE]) + rowSums(betaCnots_onXY*dfC[,(ncs+1):nc, drop=FALSE]) + 1*x + rnorm(n,0,1)
  } else {
    y = rowSums(betaCs_onXY*dfC[,1:ncs, drop=FALSE]) + 1*x + rnorm(n,0,1)
  }



  ###
  ### generate selection variable s

  # beta is set so that the total effect across all covariates affect d is constant
  betaC = log(totalEffectCovarsSelection^(1/ncs))

  # X AND (A SUBSET OF) C ARE DETERMINANTS OF SELECTION
  logitPart = log(2)*x + rowSums(dfC[,1:ncs, drop=FALSE]*betaC) 
  pS = exp(logitPart)/(1+exp(logitPart))
  s = rep(0, 1, n)
  s[runif(n) <= pS] = 1

  # check variance of selection explained by Xs
  #mylogit <- glm(s ~ ., data=dfC[,1:ncs], family="binomial")

  # check selection variable has same prop'n variance explained by C and same distribution
#  library('rsq')
#  rsq(mylogit)

#  table(s)
  summary(s)


  ###
  ### select subsample
  
  z = z[which(s ==1)]
  dfC = dfC[which(s==1),]



  
  
  ###
  ### calculate test statistic - Mahalanobis distance

  # computationally efficient to generate once rather than for each permutation
  covDFC = solve(as.matrix(stats::cov(dfC)))
  
  t = as.numeric(getMD3Cats(dfC, z, covDFC))



  ###
  ### independent tests regressing X on Z

  individualPvalues = c()
  for (i in 1:nc) {

    sumx = summary(lm(dfC[,i] ~ z))
#    print(sumx)

    pvalue = sumx$coefficients['z','Pr(>|t|)']
    print(paste0('i: ', pvalue, ', adjusted:', pvalue*nc))

    individualPvalues = c(individualPvalues, pvalue)

  }

  indtReject = (min(individualPvalues)*nc)<0.05


  ###
  ### permutation testing

  print('### Permutation testing ###')
  
  # distribution of test statistics generated under the null of complete randomization
  permTestStats = c()
  nPerms = 5000

  for (i in 1:nPerms) {
    
    # randomly permute z
    zperm = sample(z, length(z), replace=FALSE)
    
    # calculate test statistic on permuted data
    testStatPerm = getMD3Cats(dfC, zperm, covX.inv=covDFC)
    
    # add test stat of permutated data to our empirial distribution of test statistics
    permTestStats = c(permTestStats, testStatPerm)

    if (i%%100==0) print(i)

  }
  
  ###
  ### summarise permutation testing null distribution of test statistics
  
  print(paste0('True test statistic: ', t))
  
  print('Summary of null distribution of test statistics (generated with permutation testing):')
  summary(permTestStats)
  
 # print(paste0("0.95 quantile: ", quantile(permTestStats, 0.95) ))
 # print(paste0("max perm value: ", max(permTestStats) ))
  
  # generate p value
  pvalue = length(which(permTestStats>=t))/nPerms
  print(paste0("Permutation P value: ", pvalue))
  

  return(c(pvalue, individualPvalues, indtReject))

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


