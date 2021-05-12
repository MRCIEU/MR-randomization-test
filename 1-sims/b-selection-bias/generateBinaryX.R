###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')

# rsq package for calculating rsq for binary outcome
library('rsq')

generateBinaryX <- function(dfC, z, ncs, corrC) {

  # number of covariates
  nc = ncol(dfC)

  ##
  ## generate intermediate outcomes

  # combine the variables in CS and CNOTS INTO COMBINED VARIABLES, RESPECTIVELY.
 
  tmpCS = combineDeterminants(dfC[,1:ncs, drop=FALSE])
  tmpCNOTS = combineDeterminants(dfC[,(ncs+1):nc, drop=FALSE])
 

  # generate intermediate continuous variable xCont

#  xCont = combineDeterminants(data.frame(tmpCS=tmpCS, tmpCNOTS=tmpCNOTS, z=z))

#  print(paste0('x intermed: mean=', mean(xCont), ', sd=', sd(xCont)))

  ## shift xCont to have mean zero so we can fix the distribution using the intercept below
#  xCont = xCont - mean(xCont)

  ##
  ## binary outcome x

  # find correlation between the two intermediate variables and use that to decide on the right
  # beta such that the total effect of CS and CNOTS combined is constant

#  logitPart = log(4.73)*xCont - 3.0
#  pX = exp(logitPart)/(1+exp(logitPart))
#  x = rep(0, 1, n)
#  x[runif(n) <= pX] = 1

  ## 
  ## shift intermediates to have mean zero
  print(paste0('tmpCS: mean=', mean(tmpCS), ', sd=', sd(tmpCS)))
  print(paste0('tmpCNOTS: mean=', mean(tmpCNOTS), ', sd=', sd(tmpCNOTS)))

  tmpCS = tmpCS - mean(tmpCS)
  tmpCNOTS = tmpCNOTS - mean(tmpCNOTS)

  print(paste0('tmpCS: mean=', mean(tmpCS), ', sd=', sd(tmpCS)))
  print(paste0('tmpCNOTS: mean=', mean(tmpCNOTS), ', sd=', sd(tmpCNOTS)))



  logitPart = log(4.73)*z - 1.0
  pZ = exp(logitPart)/(1+exp(logitPart))

  logitPart = log(4.73)*tmpCS - 1.0
  pCS = exp(logitPart)/(1+exp(logitPart))

  logitPart = log(4.73)*tmpCNOTS - 1.0
  pCnotS = exp(logitPart)/(1+exp(logitPart))

  pX = pZ*pCS*pCnotS
  x = rep(0, 1, n)
  x[runif(n) <= pX] = 1


  return(list(x=x, tmpCS=tmpCS, tmpCNOTS=tmpCNOTS))

}
