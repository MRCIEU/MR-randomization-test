
# generate covariates C with particular correlation corrC
generateHPCovarsWithCorr <- function(n, nc, ncHP, corr, z, zCorr=0.001, numHPSnps) {


  library('faux')


  # init vars to contain the snps that are horizontally pleiotropic
  vars = data.frame(z[,1:numHPSnps, drop=FALSE])
  #print(head(vars))

  # generate covariate one at a time
  for (i in 1:nc) {

    # only the first ncHP covariates are affected by z
    if (i<=ncHP) {
      thisZCorr = zCorr
    }
    else {
      thisZCorr = 0
    }

    # generate next covariate with particular correlation with vars 
    # i.e. the HP snps and the already generated covariates
    rx = c(rep(thisZCorr,numHPSnps),rep(corr, (i-1)))
    covar = rnorm_pre(vars, r=rx, empirical=FALSE)
    
    # add new covar to covars
    vars = cbind(vars,covar)
    colnames(vars)[ncol(vars)] = paste0('c', ncol(vars)-1)
  }

  # remove z from covariate data frame
  vars = vars[,-(1:numHPSnps)]

  return(vars)
}


generateHPCovarsWithCorrDistribution <- function(n, nc, ncHP, corr, seed, z, zCorr=0.001, numHPSnps) {

  # normally distributed scenario
  if (corr!=-1) {
    return(NULL)
  }
  
  
  library('faux')

  # init vars to contain the snps that are horizontally pleiotropic
  vars = data.frame(z)
  vars = vars[,1:numHPSnps, drop=FALSE]
  
  impossibleCorrs=TRUE
  while(impossibleCorrs==TRUE) {
  out <- tryCatch({
    
  # generate covariate one at a time
  for (i in 1:nc) {

    # only the first ncHP covariates are affected by z
    if (i<=ncHP) {
      thisZCorr = zCorr
    }
    else {
      thisZCorr = 0
    }
    
    # generate next covariate with particular correlation with vars 
    # i.e. the HP snps and the already generated covariates
    # correlation with covars comes from a normal distribution
    corrCs = rnorm(i-1, 0, 0.1)
    covar = rnorm_pre(vars, r=c(rep(thisZCorr,numHPSnps),corrCs), empirical=FALSE)

    # add new covar to covars
    vars = cbind(vars,covar)
    colnames(vars)[ncol(vars)] = paste0('c', ncol(vars)-1)

    print(dim(vars))
      
  }
  
  impossibleCorrs=FALSE
      
  },
  error=function(cond) {
    print('could not generate covariates from correlation, trying again.')
  }
  )
  
  
        
  }

  # remove z from covariate data frame
  vars = vars[,-(1:numHPSnps)]

  print(cor(vars))

  return(vars)

}
