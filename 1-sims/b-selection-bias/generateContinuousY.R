###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')


generateContinuousY <- function(dfC, x, ncs) {


  # number of covariates
  nc = ncol(dfC)
  n = nrow(dfC)

  ##
  ## generate intermediate outcomes

  # combine the variables in CS and CNOTS INTO COMBINED VARIABLES, RESPECTIVELY.
  tmpCS = rowSums(dfC[,1:ncs, drop=FALSE]) 
  tmpCNOTS = rowSums(dfC[,(ncs+1):nc, drop=FALSE]) 


  ##
  ## continuous outcome y

  # find correlation between the two intermediate variables and use that to decide on the right
  # beta such that the total effect of CS and CNOTS combined is constant

  # variance and covariances needed to calculate beta
  varCS = var(tmpCS)
  varCNOTS = var(tmpCNOTS)
  varX = var(x)
  intermedCov_CS_CNOTS = cov(tmpCS, tmpCNOTS)
  intermedCov_CS_X = cov(tmpCS, x)
  intermedCov_CNOTS_X = cov(tmpCNOTS, x)

  betaY = sqrt(0.8/(varCS + varNOTS + varX + 2*(intermedCov_CS_CNOTS + intermedCov_CS_X + intermedCov_CNOTS_X) ))

  y = betaY*tmpCS + betaY*tmpCNOTS + betaY*x+ rnorm(n,0,1)

  return(list(y=y, tmpCS=tmpCS, tmpCNOTS=tmpCNOTS))

}
