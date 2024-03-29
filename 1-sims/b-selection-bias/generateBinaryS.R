###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')

generateBinaryS <- function(dfC, x, ncs, rsqSelection) {

  # number of covariates
  nc = ncol(dfC)
  n = nrow(dfC)

  ##
  ## generate intermediate outcomes

  # combine the variables in CS INTO COMBINED VARIABLES

  tmpCS = combineDeterminants(dfC[,1:ncs, drop=FALSE])
  print(paste0('tmpCS: mean=', mean(tmpCS), ', sd=', sd(tmpCS)))

  ##
  ## generate intermediate continuous variable sCont

  # use variance and covariances of intermed variables to find right beta such that
  # the total effect of CS and X combined is constant

  sCont = combineDeterminants(data.frame(tmpCS=tmpCS, x=x))

  print(paste0('s intermed: mean=', mean(sCont), ', sd=', sd(sCont)))

  ## shift sCont to have mean zero so we can fix the distribution using the intercept below
  sCont = sCont - mean(sCont)


  ##
  ## binary outcome S

  if (rsqSelection==0.05) {
    logitPart = log(2.885)*sCont - 3.316
  } else if (rsqSelection==0.1) {
    logitPart = log(5.38)*sCont - 3.925
  } else if (rsqSelection==0.2) {
    logitPart = log(63)*sCont - 7.23

  }

  pS = exp(logitPart)/(1+exp(logitPart))
  s = rep(0, 1, n)
  s[runif(n) <= pS] = 1
  

  return(list(s=s, tmpCS=tmpCS))

}
