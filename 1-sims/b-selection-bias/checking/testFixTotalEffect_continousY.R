###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

source('../generateContinuousY.R')

library('MASS')

# number in sample
n = 350000
  
# number of covariates
nc = 20


for (corrC in c(0, 0.1)) {

print('')
print('#############################')
print(paste0('Correlation: ', corrC))
print('')

##
## generate covariates

corrCMat = diag(nc)
corrCMat[which(corrCMat == 0)] = corrC
dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
dfC = as.data.frame(dfC)

x = rnorm(n, 0, 1)

  
for (ncs in 1:9) {

  print('################')  
  print(paste0('number of covars affecting selection:', ncs))
      
  dataY = generateContinuousY(dfC, x, ncs)

  ##
  ## check total effect remains constant

  #print("COMBINED MODEL WITH ALL COVARS")
  sumxAll = summary(lm(dataY$y ~ x + ., data = dfC))
  print(paste0('R sq of covars on y: ', sumxAll$r.squared))

  #print("MODEL WITH THE TWO INTERMEDIATE VARIABLES")
  sumxAll = summary(lm(dataY$y ~ dataY$tmpCS + dataY$tmpCNOTS + x))
  print(paste0('R sq of 2 intermediate variables on y: ', sumxAll$r.squared))
  
}

}
