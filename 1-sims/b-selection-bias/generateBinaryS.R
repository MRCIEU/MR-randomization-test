###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')

# rsq package for calculating rsq for binary outcome
library('rsq')

generateBinaryS <- function(dfC, x, ncs, r, corr) {

  # number of covariates
  nc = ncol(dfC)
  n = nrow(dfC)

  ##
  ## generate intermediate outcomes

  # combine the variables in CS INTO COMBINED VARIABLES
  #tmpCS = rowSums(dfC[,1:ncs, drop=FALSE]) 

  if ((nc-ncs) == 1) {
    betaCS = 1
  }
  else {
    betaCS = sqrt(1/(ncs + 2*factorial(ncs-1)*corr))
  }
  tmpCS = betaCS*rowSums(dfC[,1:ncs, drop=FALSE])

  print(paste0('tmpCS: mean=', mean(tmpCS), ', sd=', sd(tmpCS)))

  ##
  ## generate intermediate continuous variable sCont

  # use variance and covariances of intermed variables to find right beta such that
  # the total effect of CS and X combined is constant

  varCS = var(tmpCS)
  varX = var(x)
  intermedCov_CS_X = cov(tmpCS, x)
  betaSCont = sqrt(1/(varCS + varX + 2*intermedCov_CS_X))
  sCont = betaSCont*tmpCS + betaSCont*x

  print(paste0('s intermed: mean=', mean(sCont), ', sd=', sd(sCont)))

  ## shift sCont to have mean zero so we can fix the distribution using the intercept below
  sCont = sCont - mean(sCont)


  ##
  ## binary outcome x

if (r==0.2) {
#  logitPart = log(5.6)*sCont - 3.9900
logitPart = log(4.9)*sCont - 3.900
}
else if (r==0.4) {
#  logitPart = log(18)*sCont - 5.500
  logitPart = log(13)*sCont - 5.150
}
else if (r==0.6) {
#  logitPart = log(107)*sCont - 8.138
  logitPart = log(64)*sCont - 7.500
}

  pS = exp(logitPart)/(1+exp(logitPart))
  s = rep(0, 1, n)
  s[runif(n) <= pS] = 1
  

  return(list(s=s, tmpCS=tmpCS))

}
