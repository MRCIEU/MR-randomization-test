# use MASS for mvrnorm
library('MASS')

# number in sample
n = 350000
  
# number of covariates
nc = 10


# generate covariates
dfC = data.frame(c1 = rnorm(n, 0, 1))
for (i in 2:nc) {
  dfC[,paste0('c', i)] = rnorm(n, 0, 1)
}
  
  
  
for (ncs in 1:5) {
  
  print(paste0('number of covars affecting selection:', ncs))
      
  # the total effect of the two sets of covariates (those that affect selection and those that do not) are held fixed
  betaCs_onY = 2/ncs
  betaCnots_onY = 2/(nc-ncs)

  # continuous outcome y
  y = rowSums(betaCs_onY*dfC[,1:ncs, drop=FALSE]) + rowSums(betaCnots_onY*dfC[,(ncs+1):nc, drop=FALSE]) + rnorm(n,0,1)

  print(summary(lm(y ~ ., data = dfC)))
  
}


