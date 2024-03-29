
# generate covariates C with particular correlation corrC
generateCovariatesWithCorrelation <- function(n, nc, corr) {

  source('../generic-functions/cor2cov.R')

  corrCMat = diag(nc)
  corrCMat[which(corrCMat == 0)] = corr
  covC = cor2cov(corrCMat, 1)
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=covC, empirical=FALSE)
  dfC = as.data.frame(dfC)

  return(dfC)
}


generateCovariatesWithCorrelationDistribution <- function(n, nc, corr, seed) {

  source('../generic-functions/cor2cov.R')

  # normally distributed scenario
  if (corr==-1) {
  
    # generate matrix with 1s on descending diagonal
    corrCMat = diag(nc)
  
    # get number of correlations between covariates that we need to generate
    numCorrs = length(which(upper.tri(corrCMat)))

    # generate correlations using normal distribution
    corrCMat[which(upper.tri(corrCMat))] = rnorm(numCorrs, 0, 0.1)

    # turn into correlation matrix by making lower triangle equal upper triangle
    # need to transpose and grab the lower triangle since order of cells is by column without 
    # this the result isn't symmetric about the descending diagonal
    corrCMat[lower.tri(corrCMat)]<-t(corrCMat)[lower.tri(corrCMat)]

#    print(corrCMat)
#    resDir=Sys.getenv('RES_DIR')
#    filename=paste0(resDir, "/sims/corsim-out-", seed, ".txt")
#    write.table(corrCMat, filename, sep=',', row.names=FALSE, col.names=TRUE)
#    print('corr written to file')

    # get covariance matrix from correlation matrix (assume var=1 for covars)
    covC = cor2cov(corrCMat, 1)

    library(corpcor)
    if (!is.positive.definite(covC)) {
        print('Making cov matrix positive definite')
        covC = make.positive.definite(covC)
        print('done')
    }

    # generate covariates with this covariance
    print('generating covars with particular covariance matrix')
    dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=covC, empirical=FALSE)
    dfC = as.data.frame(dfC)
    print(dim(dfC))
    
    return(dfC)

  }

  return(null)

}
