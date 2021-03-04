

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
  
  # assignment mechanism of z: random assignment with effects from m covariates
  z = sample(1:3, n, replace=TRUE, prob=c(0.6, 0.3, 0.1))
  
  
  # check assoc of z with covariates
#  fit <- polr(as.factor(z) ~ ., data=dfX, Hess=TRUE)
#  ct = coeftest(fit)
#  regPvalue = ct[,"Pr(>|t|)"]
#  print("P values of ordered logistic regression parameters:")
#  print(regPvalue)
  
  ### generate exposure d, outcome y and selection variable s

  # binary exposure x
  #### C AND Z ARE DETERMINANTS OF X
  betaCOnZY = log(5^(1/nc))

  logitPart = z + rowSums(0.1*dfC) + rnorm(n, 0, 1)
  pX = exp(logitPart)/(1+exp(logitPart))
  x = rep(0, 1, n)
  x[runif(n) <= pX] = 1
  
  # continuous outcome y
  # C AND X ARE DETERMINANTS OF Y
  y = rowSums(betaCOnZY*dfC) + 1*x + rnorm(n, 0, 1)
  
  # selection variable s and reduce to selected sample

  # beta is set so that the total effect across all covariates affect d is 10
  betaC = log(totalEffectCovarsSelection^(1/ncs))

  # X AND (A SUBSET OF) C ARE DETERMINANTS OF SELECTION
  logitPart = log(2)*x + rowSums(dfC[,1:ncs]*betaC) + 0.1*rnorm(n,0,1)
  pS = exp(logitPart)/(1+exp(logitPart))
  s = rep(0, 1, n)
  s[runif(n) <= pS] = 1

  # check variance of selection explained by Xs
  mylogit <- glm(s ~ ., data=dfC[,1:ncs], family="binomial")
  #sumx = summary(mylogit)
  #print(summary(lm(s ~ ., data=dfX[,1:nXAffectZ])))
  #print(summary(glm(s ~ d, family="binomial")))

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

	# split into the 3 categories
	data = data.frame(covars, indicator = z)
	data1 = subset(data, indicator == 1)
	data2 = subset(data, indicator == 2)
	data3 = subset(data, indicator == 3)

	# remove indicator column
	data1 = subset(data1, select = -c(indicator))
	data2 = subset(data2, select = -c(indicator))
	data3 = subset(data3, select = -c(indicator))

	# numbers with each allele dosage
	n1 = nrow(data1)
	n2 = nrow(data2)
	n3 = nrow(data3)

	# mean difference across three ordinal categories
	covMeanDiffs1vs2 = colMeans(data1) - colMeans(data2)
	covMeanDiffs2vs3 = colMeans(data2) - colMeans(data3)
	
	# weight each diff by number of comparisons 
	# 1vs2 has n1*n2 comparisons between each persons with allele dose 1 and 2
	# 1vs2 has n2*n3 comparisons between each persons with allele dose 2 and 3
	# (both these have *n2 so this is ignored)
	covMeanDiffs = (n1*covMeanDiffs1vs2 + n3*covMeanDiffs2vs3)/(n1+n3)
	
	md = t(covMeanDiffs) %*% covX.inv %*% covMeanDiffs

	return(md)

}


