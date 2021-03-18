


resDir=Sys.getenv('RES_DIR')

## compare with ivmodel package and binary IV

library('ivmodel')
library('MASS')

source('../doSimSelection.R')
source('getMDTest.R')

n=10000
nc=10

z = sample(0:1, n, replace=TRUE, prob=c(0.6, 0.3))


for (corrC in seq(0,0.9, by=0.1)) {
  
  # make covariates
  corrCMat = diag(nc)
  corrCMat[which(corrCMat == 0)] = corrC
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
  dfC = as.data.frame(dfC)
  covinvDFC = solve(as.matrix(stats::cov(dfC)))

  outfile = paste0(resDir, '/sims/mdtest', corrC, '.csv')
  cat('mymd,mymd2,md,mymdcor\n', file=outfile, append=FALSE)

  for (i in 1:200) {

    # permute z
    zperm = sample(z, length(z), replace=FALSE)

    # get md using our approach and function in ivmodel package (Branson approach)

    time1 <- Sys.time()
    myMD = getMD3Cats(dfC, zperm, covinvDFC)
    time2 <- Sys.time()
    diffT = time2-time1
    print(paste0('regression: ', diffT))

    md = getMD(dfC, zperm, covinvDFC)
    myMD2 = getMDTest(dfC, zperm, covinvDFC)

    time1 <- Sys.time()
    myMD3Cor = getMD3CatsCorr(dfC, zperm, covinvDFC)
    time2 <- Sys.time()
    diffT = time2-time1
    print(paste0('cor: ', diffT))

    # save mds to file
    cat(paste0(myMD, ',', myMD2, ',', md, ',', myMD3Cor, '\n'), file=outfile, append=TRUE)

  }

}


