



# nc: the number of covariates included as candidates
# ncs: the number of covariates that affect selection
# corrC: correlation between covariates
generateSimData <- function(n, nc, ncs, corrC, totalEffectCovarsSelection) {

  ###
  ### load packages

  # use MASS for mvrnorm and polyr functions
  library('MASS')

  # lmtest for coeftest
  #library('lmtest')

  # ivmodel for Branson Mahalanobis distance test
  #library('ivmodel')



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
  covC = cor2cov(corrCMat, 1)
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=covC, empirical=FALSE)
  dfC = as.data.frame(dfC)
  
  ## generate a IV with 3 categories
  ## use p(A1)=0.8, p(A2)=0.2, dosage probs assuming HWE = (0.8^2, 2*0.8*0.2, 0.2^2) = (0.64,0.32,0.04) 
  z = sample(1:3, n, replace=TRUE, prob=c(0.64, 0.32, 0.04))
  

  ###
  ### calculate effects of covariates on X and Y, fixing the total effect of C_s and C_nots respectively.

  betaCs_onX = log(2^(1/ncs))
  betaCnots_onX = log(2^(1/(nc-ncs)))


  ###
  ### generate exposure x

  logitPart = z + rowSums(betaCs_onX*dfC[,1:ncs, drop=FALSE]) + rowSums(betaCnots_onX*dfC[,(ncs+1):nc, drop=FALSE]) 
  pX = exp(logitPart)/(1+exp(logitPart))
  x = rep(0, 1, n)
  x[runif(n) <= pX] = 1
  

  ###
  ### generate continuous outcome y

  # C AND X ARE DETERMINANTS OF Y
  dataY = generateContinuousY(dfC, x, ncs)
  y = dataY$y


  ###
  ### generate selection variable s

  # beta is set so that the total effect across all covariates affect d is constant
  betaC = log(totalEffectCovarsSelection^(1/ncs))

  # X AND (A SUBSET OF) C ARE DETERMINANTS OF SELECTION
  logitPart = log(2)*x + rowSums(dfC[,1:ncs, drop=FALSE]*betaC) 
  pS = exp(logitPart)/(1+exp(logitPart))
  s = rep(0, 1, n)
  s[runif(n) <= pS] = 1



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

