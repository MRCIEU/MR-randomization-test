

###
### simulation to test Branson complete randomization approach

##
## we use the same (non standard!) notation as in the Branson paper:
## instrument Z, exposure D, covariates X and outcome Y

#### If one x affect z, does it matter how many other x's are considered
#### e.g. does including more x's reduce the power to detect that the IV is 
#### not completely randomized


doSim <- function(nCovarsX=10, corrX=0) {

  ###
  ### load packages

  # use MASS for mvrnorm and polyr functions
  library('MASS')

  # lmtest for coeftest
  library('lmtest')

  # ivmodel for Branson Mahalanobis distance test
  library('ivmodel')



  ## z is a snp dosage IV with 3 levels
  ## d is a binary exposure
  ## y is a continuous outcome

  ### is the p value correct when there are dependencies between the covariates

  # number in sample
  n = 10000

  
  print('-------------------')
  print(paste0("Number of covariates that affect IV z: ", numCovarsX))
  print(paste0("Correlation between covariates: ", corrX))
  
  # number of covariates that affect z
  nXAffectZ = 1

  ###
  ### generate data
  
  ## generate covariates x with particular correlation corrX
  
  
  corrXMat = diag(numCovarsX)
  corrXMat[which(corrXMat == 0)] = corrX
  dfX = mvrnorm(n=n, mu=rep(0, numCovarsX), Sigma=corrXMat, empirical=FALSE)
  
  dfX = as.data.frame(dfX)
  
  ## generate a IV with 3 categories, where nXAffectZ covariates X affect z
  
  # assignment mechanism of z: random assignment with effects from m covariates
  #z = sample(1:3, n, replace=TRUE, prob=c(0.6, 0.3, 0.1))
  zCont = rnorm(n, 0,1)
  for (i in 1:nXAffectZ) {
    zCont = zCont + 0.1*dfX[,paste0("V",i)]
  }
  z = rep(0, 1, n)
  z[zCont < quantile(zCont, 0.8) & zCont >= quantile(zCont, 0.5)] = 1
  z[zCont >= quantile(zCont, 0.8)] = 2
  
  
  # check assoc of z with covariates
#  fit <- polr(as.factor(z) ~ ., data=dfX, Hess=TRUE)
#  ct = coeftest(fit)
#  regPvalue = ct[,"Pr(>|t|)"]
#  print("P values of ordered logistic regression parameters:")
#  print(regPvalue)
  
  ### generate exposure d and outcome y
  
  # binary exposure d
  logitPart = rowSums(dfX*0.1) + rnorm(n, 0, 1)
  pD = exp(logitPart)/(1+exp(logitPart))
  d = rep(0, 1, n)
  d[runif(n) <= pD] = 1
  
  # continuous outcome y
  y = rowSums(0.1*dfX) + 1*d + rnorm(n, 0,1)
  
  
  
  ###
  ### calculate test statistic - Mahalanobis distance
  
  t = as.numeric(getMD(dfX, z))

  
  ###
  ### permutation testing
  
  # distribution of test statistics generated under the null of complete randomization
  permTestStats = c()
  nPerms = 5000
  for (i in 1:nPerms) {
    
    # randomly permute z
    zperm = sample(z, length(z), replace=FALSE)
    
    # calculate test statistic on permuted data
    testStatPerm = getMD(dfX, zperm)
    
    # add test stat of permutated data to our empirial distribution of test statistics
    permTestStats = c(permTestStats, testStatPerm)
  }
  
  ###
  ### summarise permutation testing null distribution of test statistics
  
  print(paste0('True test statistic: ', t))
  
  print('Summary of null distribution of test statistics (generated with permutation testing):')
  summary(permTestStats)
  
  print(paste0("0.95 quantile: ", quantile(permTestStats, 0.95) ))
  print(paste0("max perm value: ", max(permTestStats) ))
  
  # generate p value
  pvalue = length(which(permTestStats>=t))/nPerms
  print(paste0("Permutation P value: ", pvalue))
  

  return(pvalue)

}




