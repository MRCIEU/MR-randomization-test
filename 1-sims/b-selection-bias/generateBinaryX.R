###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')

# rsq package for calculating rsq for binary outcome
library('rsq')

generateBinaryX <- function(dfC, z, ncs, r) {

  # number of covariates
  nc = ncol(dfC)
  n = nrow(dfC)

  ##
  ## generate intermediate outcomes

  # combine the variables in CS and CNOTS INTO COMBINED VARIABLES, RESPECTIVELY.

  # for the covariates they all have variance 1 so correlation = covariance
  
  if ((nc-ncs) == 1) {
    betaCS = 1
  }
  else {
    betaCS = sqrt(1/(ncs + 2*factorial(ncs-1)*r))
  }
  tmpCS = betaCS*rowSums(dfC[,1:ncs, drop=FALSE]) 

  if ((nc-ncs) == 1) {
    betaCNOTS = 1
  } 
  else {
    betaCNOTS = sqrt(1/((nc-ncs) + 2*factorial(nc-ncs-1)*r))
  }
  tmpCNOTS = betaCNOTS*rowSums(dfC[,(ncs+1):nc, drop=FALSE]) 


  ##
  ## generate intermediate continuous variable xCont

  varCS = var(tmpCS)
  varCNOTS = var(tmpCNOTS)
  varZ = var(z)
  intermedCov_CS_Z = cov(tmpCS, z)
  intermedCov_CNOTS_Z = cov(tmpCNOTS, z)
  intermedCov_CS_CNOTS = cov(tmpCS, tmpCNOTS)

  betaXCont = sqrt(1/(varCS + varCNOTS + varZ + 2*(intermedCov_CS_Z + intermedCov_CNOTS_Z + intermedCov_CS_CNOTS) ))
  xCont = betaXCont*tmpCS + betaXCont*tmpCNOTS + betaXCont*z



  print(paste0('x intermed: mean=', mean(xCont), ', sd=', sd(xCont)))

  ## shift xCont to have mean zero so we can fix the distribution using the intercept below
  xCont = xCont - mean(xCont)

  ##
  ## binary outcome x

  # find correlation between the two intermediate variables and use that to decide on the right
  # beta such that the total effect of CS and CNOTS combined is constant

  logitPart = log(4.73)*xCont - 3.0
  pX = exp(logitPart)/(1+exp(logitPart))
  x = rep(0, 1, n)
  x[runif(n) <= pX] = 1
  

  return(list(x=x, tmpCS=tmpCNOTS, tmpCNOTS=tmpCNOTS))

}
