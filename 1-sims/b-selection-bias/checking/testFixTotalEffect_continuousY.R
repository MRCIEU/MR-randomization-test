###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

sink('out-testFixTotalEffect_continousY.txt')

source('../generateContinuousY.R')
source('../generateBinaryX.R')

library('MASS')

# number in sample
n = 350000
  
# number of covariates
for (nc in c(20, 40)) {

print(paste0('####### NC: ', nc))


for (corrC in c(0, 0.1)) {

for (ncs in c(1,3,6,9)) {

  print('################')  
  print(paste0('Correlation: ', corrC, ', number of covars affecting selection:', ncs))


  ##
  ## generate covariates, instrument Z, exposure X and outcome Y

  corrCMat = diag(nc)
  corrCMat[which(corrCMat == 0)] = corrC
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
  dfC = as.data.frame(dfC)

  z = sample(1:3, n, replace=TRUE, prob=c(0.64, 0.32, 0.04))

  dataX = generateBinaryX(dfC, z, ncs)
      
  dataY = generateContinuousY(dfC, dataX$x, ncs)


  ##
  ## check total effect remains constant

  #print("COMBINED MODEL WITH ALL COVARS")
  sumxAll = summary(lm(dataY$y ~ dataX$x + ., data = dfC))
  print(paste0('R sq of covars on y: ', sumxAll$r.squared))

  #print("MODEL WITH THE TWO INTERMEDIATE VARIABLES")
  sumxAll = summary(lm(dataY$y ~ dataY$tmpCS + dataY$tmpCNOTS + dataX$x))
  print(paste0('R sq of 2 intermediate variables on y: ', sumxAll$r.squared))
  
}

}

}

sink()
