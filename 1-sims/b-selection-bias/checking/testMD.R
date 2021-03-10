


resDir=Sys.getenv('RES_DIR')

## compare with ivmodel package and binary IV

library('ivmodel')
library('MASS')

source('doSimSelection.R')


n=10000
nc=10

z = sample(0:1, n, replace=TRUE, prob=c(0.6, 0.3))


for (corrC in seq(0,0.9, by=0.1)) {
  
  # make covariates
  corrCMat = diag(nc)
  corrCMat[which(corrCMat == 0)] = corrC
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
  dfC = as.data.frame(dfC)
  covDFC = solve(as.matrix(stats::cov(dfC)))

  outfile = paste0(resDir, '/sims/mdtest', corrC, '.csv')
  cat('mymd, md\n', file=outfile, append=FALSE)

  for (i in 1:200) {

    # permute z
    zperm = sample(z, length(z), replace=FALSE)

    # get md using our approach and function in ivmodel package (Branson approach)
    myMD = getMD3Cats(dfC, zperm, covDFC)
    md = getMD(dfC, zperm, covDFC)

    # save mds to file
    cat(paste0(myMD,',',md, '\n'), file=outfile, append=TRUE)

  }

}
