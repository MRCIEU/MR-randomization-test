###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

#sink('out-testFixTotalEffect_continousY.txt')

source('../generateContinuousY2.R')
source('../generateContinuousX2.R')
source('../combineDeterminants.R')
source('../combineDeterminants2.R')

library('MASS')

  


checkContinuousY <- function(zType, nc, ncs, corrC) {

  # number in sample
  n = 350000

  for (i in 1:10) {

  print('################')  
  print(paste0('Correlation: ', corrC, ', number of covars affecting selection:', ncs))


  ##
  ## generate covariates, instrument Z, exposure X and outcome Y

  corrCMat = diag(nc)
  corrCMat[which(corrCMat == 0)] = corrC
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
  dfC = as.data.frame(dfC)

  if(zType=="dosage") {
    z = sample(1:3, n, replace=TRUE, prob=c(0.64, 0.32, 0.04))
  } else {
    z = rnorm(n)
  }

  dataX = generateContinuousX2(dfC, z, ncs)
  
  dataY = generateContinuousY2(dfC, dataX$x, ncs)

  print(paste0('y: mean=', mean(dataY$y), ', sd=', sd(dataY$y)))


  ##
  ## check total effect remains constant

  sumxAll = summary(lm(dataY$y ~ dataX$x + ., data = dfC))
  rsq = sumxAll$r.squared
  print(paste0('R sqy: ', rsq))


  print(quantile(dataY$y))
  ks=ks.test(dataY$y, 'pnorm')
  print(paste0('KS test for normality: ', ks$statistic, ', p=', ks$p.value))


  # check var explained by x
  mylinear <- lm(dataY$y ~ dataX$x)
  sumx = summary(mylinear)
  rsq_x = sumx$r.squared
  print (paste0('xxxx ', rsq_x))


  mylinear <- lm(dataY$y ~ dataX$x + dataY$tmps)
  sumx = summary(mylinear)
  rsq_xtmp = sumx$r.squared
  print(paste0('xxxx tmps ', rsq_xtmp))
  print(sumx)

  write(paste(i, zType, nc, ncs, corrC, rsq, rsq_x, sep=','), file='out/outY2.txt', append=TRUE)

  }
  
}


write('i,zType,nc,ncs,corr,rsq, rsq_x', file='out/outY2.txt', append=FALSE)

params <- expand.grid(
  zType=c("grs", "dosage"),
  nc = c(10, 20),
  corrC = c(0,0.4,0.8),
  ncs=c(1,3,6,9)
)

apply(params, 1, function(x) checkContinuousY(zType=x['zType'], nc=as.numeric(x['nc']), ncs=as.numeric(x['ncs']), corrC=as.numeric(x['corrC'])))




#sink()
