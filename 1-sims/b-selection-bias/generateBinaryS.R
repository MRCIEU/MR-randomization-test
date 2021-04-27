###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')

# rsq package for calculating rsq for binary outcome
library('rsq')

generateBinaryS <- function(dfC, x, ncs) {

  # number of covariates
  nc = ncol(dfC)
  n = nrow(dfC)

  ##
  ## generate intermediate outcomes

  # combine the variables in CS and CNOTS INTO COMBINED VARIABLES, RESPECTIVELY.
  tmpCS = rowSums(dfC[,1:ncs, drop=FALSE]) 



  ##
  ## generate intermediate continuous variable sCont

  varCS = var(tmpCS)
  varX = var(x)
  intermedCov_CS_X = cov(tmpCS, x)
  betaY = sqrt(1/(varCS + varX + 2*intermedCov_CS_X))
  sCont = betaY*tmpCS + betaY*x

  print(paste0('s intermed: mean=', mean(sCont), ', sd=', sd(sCont)))

  ##
  ## binary outcome x

  # find correlation between the two intermediate variables and use that to decide on the right
  # beta such that the total effect of CS and CNOTS combined is constant

  logitPart = log(10)*sCont - 4.900
  pS = exp(logitPart)/(1+exp(logitPart))
  s = rep(0, 1, n)
  s[runif(n) <= pS] = 1
  

  return(list(s=s, tmpCS=tmpCS))

}
