###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')


generateY <- function(dfC, x, ncs) {

  # number of covariates
  nc = ncol(dfC)
  n = nrow(dfC)

  ##
  ## generate intermediate outcomes

  # combine the variables in CS and CNOTS INTO COMBINED VARIABLES, RESPECTIVELY.
  yTmp1 = rowSums(dfC[,1:ncs, drop=FALSE]) 
  yTmp2 = rowSums(dfC[,(ncs+1):nc, drop=FALSE]) 

  # standardise so we can use corr in place of covariance below
  yTmp1 = as.vector(scale(yTmp1))
  yTmp2 = as.vector(scale(yTmp2))

  ##
  ## continuous outcome y

  # find correlation between the two intermediate variables and use that to decide on the right
  # beta such that the total effect of CS and CNOTS combined is constant
  corrTmps = cor(yTmp1, yTmp2)
  numTraits=2
  betaY = sqrt(0.8/(numTraits*(1+2*corrTmps)))

  y = betaY*yTmp1 + betaY*yTmp2 + rnorm(n,0,0.1)

#  print(paste0("BETA: ", betaY))

#  print("COMBINED MODEL WITH ALL COVARS")
  sumxAll = summary(lm(y ~ ., data = dfC))

 # print(sumxAll)

#  print("MODEL WITH THE TWO INTERMEDIATE VARIABLES")
  sumxAll = summary(lm(y ~ yTmp1 + yTmp2))
  print(paste0('R sq of 2 intermediate variables on y: ', sumxAll$r.squared))


  return(y)

}
