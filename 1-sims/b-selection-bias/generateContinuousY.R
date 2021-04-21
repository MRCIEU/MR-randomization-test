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
  yTmp1 = rowSums(dfC[,1:ncs, drop=FALSE]) 
  yTmp2 = rowSums(dfC[,(ncs+1):nc, drop=FALSE]) 


  ##
  ## continuous outcome y

  # find correlation between the two intermediate variables and use that to decide on the right
  # beta such that the total effect of CS and CNOTS combined is constant

  # variance and covariances needed to calculate beta
  var1 = var(yTmp1)
  var2 = var(yTmp2)
  varX = var(x)
  intermedCovV1V2 = cov(yTmp1, yTmp2)
  intermedCovV1X = cov(yTmp1, x)
  intermedCovV2X = cov(yTmp2, x)

  betaY = sqrt(0.8/(var1 + var2 + varX + 2*(intermedCovV1V2 + intermedCovV1X + intermedCovV2X) ))

  y = betaY*yTmp1 + betaY*yTmp2 + betaY*x+ rnorm(n,0,1)

  return(list(y=y, yTmp1=yTmp1, yTmp2=yTmp2))

}
