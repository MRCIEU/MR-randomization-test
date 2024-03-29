###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates


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

  print('################')  
  print(paste0('number of covars affecting selection:', ncs))
      
  # the total effect of the two sets of covariates (those that affect selection and those that do not) are held fixed
  betaCs_onY = 2/ncs
  betaCnots_onY = 2/(nc-ncs)


  # continuous outcome y
  y = rowSums(betaCs_onY*dfC[,1:ncs, drop=FALSE]) + rowSums(betaCnots_onY*dfC[,(ncs+1):nc, drop=FALSE]) + rnorm(n,0,1)


  print("COMBINED MODEL WITH ALL COVARS")
  print(summary(lm(y ~ ., data = dfC)))


  # separate regressions
  print("MODEL WITH ONLY CS COVARS (THE SET THAT AFFECT SELECTION)")
  print(summary(lm(y ~ ., data = dfC[,1:ncs, drop=FALSE])))

  print("MODEL WITH ONLY C_NOTS COVARS (THE SET THAT DON'T AFFECT SELECTION)")
  print(summary(lm(y ~ ., data = dfC[,(ncs+1):nc, drop=FALSE])))
  
}


