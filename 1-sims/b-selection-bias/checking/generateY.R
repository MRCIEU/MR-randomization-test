###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')


generateY <- function(dfC, x, ncs) {

  print(x)
  print(ncs)

  # number of covariates
  nc = ncol(dfC)
  n = nrow(dfC)

  ##
  ## generate intermediate outcomes

  # combine the variables in CS and CNOTS INTO COMBINED VARIABLES, RESPECTIVELY.
  yTmp1 = rowSums(dfC[,1:ncs, drop=FALSE]) 
  yTmp2 = rowSums(dfC[,(ncs+1):nc, drop=FALSE]) 


  var1 = var(yTmp1)
  var2 = var(yTmp2)
  intermedCov = cov(yTmp1, yTmp2)

  ##
  ## continuous outcome y

  # find correlation between the two intermediate variables and use that to decide on the right
  # beta such that the total effect of CS and CNOTS combined is constant

  var1 = var(yTmp1)
  var2 = var(yTmp2)
  intermedCov = cov(yTmp1, yTmp2)
  betaY = sqrt(0.8/(var1+var2+2*intermedCov))

  y = betaY*yTmp1 + betaY*yTmp2 + rnorm(n,0,1)

  print("COMBINED MODEL WITH ALL COVARS")
  sumxAll = summary(lm(y ~ ., data = dfC))
  print(sumxAll$r.squared)

  print("MODEL WITH THE TWO INTERMEDIATE VARIABLES")
  sumxAll = summary(lm(y ~ yTmp1 + yTmp2))
  print(paste0('R sq of 2 intermediate variables on y: ', sumxAll$r.squared))


  return(y)

}
