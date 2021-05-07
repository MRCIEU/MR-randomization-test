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

  for (i in 1:10) {

  print('################')  
  print(paste0('Correlation: ', corrC, ', number of covars affecting selection:', ncs))


  ##
  ## generate covariates, instrument Z, exposure X and outcome Y

  corrCMat = diag(nc)
  corrCMat[which(corrCMat == 0)] = corrC
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
  dfC = as.data.frame(dfC)

  z = sample(1:3, n, replace=TRUE, prob=c(0.64, 0.32, 0.04))

  dataX = generateBinaryX(dfC, z, ncs, corrC)
      
  dataY = generateContinuousY(dfC, dataX$x, ncs)

  print(paste0('y: mean=', mean(dataY$y), ', sd=', sd(dataY$y)))


  ##
  ## check total effect remains constant

  sumxAll = summary(lm(dataY$y ~ dataX$x + ., data = dfC))
  print(paste0('R sqy: ', sumxAll$r.squared))



  }
  
}

}

}

sink()
