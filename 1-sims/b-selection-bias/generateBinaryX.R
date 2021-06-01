###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')

# rsq package for calculating rsq for binary outcome
library('rsq')

generateBinaryX <- function(dfC, z, ncs, corrC, n) {

  # number of covariates
  nc = ncol(dfC)

  ##
  ## generate intermediate outcomes

  # combine the variables in CS and CNOTS INTO COMBINED VARIABLES, RESPECTIVELY.
 
  tmpCS = combineDeterminants(dfC[,1:ncs, drop=FALSE])
  tmpCNOTS = combineDeterminants(dfC[,(ncs+1):nc, drop=FALSE])
 

  # generate intermediate continuous variable xCont

  xCont = combineDeterminants(data.frame(tmpCS=tmpCS, tmpCNOTS=tmpCNOTS, z=z))

  print(paste0('x intermed: mean=', mean(xCont), ', sd=', sd(xCont)))

  ## shift xCont to have mean zero so we can fix the distribution using the intercept below
  xCont = xCont - mean(xCont)

  print(paste0('x intermed: mean=', mean(xCont), ', sd=', sd(xCont)))

  ##
  ## binary outcome x

  # find correlation between the two intermediate variables and use that to decide on the right
  # beta such that the total effect of CS and CNOTS combined is constant

  logitPart = log(3.37)*xCont - 2.72
  pX = exp(logitPart)/(1+exp(logitPart))
  x = rep(0, 1, n)
  x[runif(n) <= pX] = 1


## generating the probabilities this way doesn't give a constant rsq/proportionX=1 as correlation changes
#  tmpCS = tmpCS - mean(tmpCS)
#  tmpCNOTS = tmpCNOTS - mean(tmpCNOTS)
#
#  beta=4.140
#  intercept=-0.20
#
#  logitPart = log(beta)*z + intercept
#  pZ = exp(logitPart)/(1+exp(logitPart))
#
#  logitPart = log(beta)*tmpCS + intercept
#  pCS = exp(logitPart)/(1+exp(logitPart))
#
#  logitPart = log(beta)*tmpCNOTS + intercept
#  pCnotS = exp(logitPart)/(1+exp(logitPart))
#
#  pX = pZ*pCS*pCnotS
#  x = rep(0, 1, n)
#  x[runif(n) <= pX] = 1

  return(list(x=x, xCont=xCont, tmpCS=tmpCS, tmpCNOTS=tmpCNOTS))

}
