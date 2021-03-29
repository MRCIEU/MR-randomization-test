###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates

### we assume the covariates are independent (correlation = 0)

# number in sample
n = 350000
  
# number of covariates
nc = 10


# generate covariates
dfC = data.frame(c1 = rnorm(n, 0, 1))
for (i in 2:nc) {
  dfC[,paste0('c', i)] = rnorm(n, 0, 1)
}
  
  
print("combined,affectingS,notaffectingS")
  
for (ncs in 1:5) {

  print('################')  
  print(paste0('number of covars affecting selection:', ncs))
      
  # the total effect of the two sets of covariates (those that affect selection and those that do not) are held fixed
  betaCs_onY = sqrt(2^2/ncs)
  betaCnots_onY = sqrt(2^2/(nc-ncs))


  # continuous outcome y
  y = rowSums(betaCs_onY*dfC[,1:ncs, drop=FALSE]) + rowSums(betaCnots_onY*dfC[,(ncs+1):nc, drop=FALSE]) + rnorm(n,0,1)


  sumxAll = summary(lm(y ~ ., data = dfC))

  # separate regressions
  sumx1 = summary(lm(y ~ ., data = dfC[,1:ncs, drop=FALSE]))
  sumx2 = summary(lm(y ~ ., data = dfC[,(ncs+1):nc, drop=FALSE]))

  print(paste0(sumxAll$adj.r.squared, ', ', sumx1$adj.r.squared, ', ',sumx2$adj.r.squared))
  
}


