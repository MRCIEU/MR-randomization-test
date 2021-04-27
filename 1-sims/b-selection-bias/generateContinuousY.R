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

  # doesn't matter that they have different variance because we account for their variance in the next step
  print(paste0('s intermed: mean=', mean(tmpCS), ', sd=', sd(tmpCS)))
  print(paste0('s intermed: mean=', mean(tmpCNOTS), ', sd=', sd(tmpCNOTS)))


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

  # variance explained by CS, CNOTS and X
  varExpl = 0.5

  betaY = sqrt(varExpl/(varCS + varCNOTS + varX + 2*(intermedCov_CS_CNOTS + intermedCov_CS_X + intermedCov_CNOTS_X) ))

  # total variance explained is 1 so variance explained by the error term is the remainder
  betaE = sqrt((1-varExpl))

  y = betaY*tmpCS + betaY*tmpCNOTS + betaY*x+ betaE*rnorm(n,0,1)

  return(list(y=y, tmpCS=tmpCS, tmpCNOTS=tmpCNOTS))

}
