###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')

# number in sample
n = 350000
  
# number of covariates
nc = 10


for (corrC in c(0.1,0.3,0.6,0.9)) {

print('#############################')
print(paste0('Correlation: ', corrC))

# generate covariates
#corrC = 0.3
corrCMat = diag(nc)
corrCMat[which(corrCMat == 0)] = corrC
dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
dfC = as.data.frame(dfC)

  
for (ncs in 1:5) {

  print('################')  
  print(paste0('number of covars affecting selection:', ncs))
      
  # the total effect of the two sets of covariates (those that affect selection and those that do not) are held fixed
  betaCs_onTmp = sqrt(2^2/(ncs*(1+2*corrC)))
  betaCnots_onTmp = sqrt(2^2/((nc-ncs)*(1+2*corrC)))


  ##
  ## generate intermediate outcomes

  # combine the variables in CS and CNOTS INTO COMBINED VARIABLES, RESPECTIVELY.
  yTmp1 = rowSums(betaCs_onTmp*dfC[,1:ncs, drop=FALSE]) 
  yTmp2 = rowSums(betaCnots_onTmp*dfC[,(ncs+1):nc, drop=FALSE]) 

  # standardise so we can use corr in place of covariance below
  yTmp1 = as.vector(scale(yTmp1))
  yTmp2 = as.vector(scale(yTmp2))

  ##
  ## continuous outcome y

  # find correlation between the two intermediate variables and use that to decide on the right
  # beta such that the total effect of CS and CNOTS combined is constant
  corrTmps = cor(yTmp1, yTmp2)
  betaY = sqrt(2^2/(2+2*corrTmps))
  y = betaY*yTmp1 + betaY*yTmp2 + rnorm(n,0,1)


  print("COMBINED MODEL WITH ALL COVARS")
  sumxAll = summary(lm(y ~ ., data = dfC))

  print(sumxAll)

  print("MODEL WITH THE TWO INTERMEDIATE VARIABLES")
  sumxAll = summary(lm(y ~ yTmp1 + yTmp2))
  print(sumxAll)


  
}


}
