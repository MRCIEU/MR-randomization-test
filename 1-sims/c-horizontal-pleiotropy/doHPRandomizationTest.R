


doHPRandomizationTest <- function(dfC, z, invCovDFC) {
  
  numZ = ncol(z)
  ncInc = ncol(dfC)

  t = 0
  for (i in 1: ncol(z)) {
    thist = as.numeric(getMD3CatsCorr(dfC, z[,i], invCovDFC))
    t = t + thist
  }

  print('a')

  ###
  ### independent tests regressing X on Z

  individualPvalues = c()

  for (zi in 1:numZ) {
  for (i in 1:ncInc) {
    thisz = z[,zi]
    sumx = summary(lm(dfC[,i] ~ thisz))

    pvalue = sumx$coefficients['thisz','Pr(>|t|)']
    print(paste0(i, ': ', pvalue, ', adjusted:', pvalue*ncInc*numZ))

    individualPvalues = c(individualPvalues, pvalue)

  }
  }

  bonfReject = (min(individualPvalues)*ncInc*numZ)<0.05
  
  
  print('b')
  
  ## Reject using equivalent number of independent tests (from correlation)

#  source('numIndependentTests.R')

  corrDFC = as.data.frame(cor(dfC))
  indepTestNums = numIndependentTests(corrDFC)

  print(paste0('indepMain: ', indepTestNums$indepMain))
  print(paste0('indepLi: ', indepTestNums$indepLi))

  pThreshIndMain = 0.05/(indepTestNums$indepMain*numZ)
  indtRejectMain = min(individualPvalues)<pThreshIndMain

  pThreshIndLi = 0.05/(indepTestNums$indepLi*numZ)
  indtRejectLi = min(individualPvalues)<pThreshIndLi


  ###
  ### permutation testing

  print('### Permutation testing ###')
  
  # distribution of test statistics generated under the null of complete randomization
  permTestStats = c()
  nPerms = 5000

  for (i in 1:nPerms) {
    
    # randomly permute each column in z
    #zperm = sample(z, length(z), replace=FALSE)
    zperm = apply(z, 2, sample, replace=FALSE)
    
    # calculate test statistic on permuted data
    testStatPerm = 0
    for (zi in 1:numZ) {
      thist = as.numeric(getMD3CatsCorr(dfC, zperm[,zi], invCovDFC))
      testStatPerm = testStatPerm + thist
    }
        
    # add test stat of permutated data to our empirial distribution of test statistics
    permTestStats = c(permTestStats, testStatPerm)

    if (i%%100==0) print(i)

  }
  
  print('c')
  
  ###
  ### summarise permutation testing null distribution of test statistics
  
  print(paste0('True test statistic: ', t))
  
  print('Summary of null distribution of test statistics (generated with permutation testing):')
  summary(permTestStats)
  
  # generate p value
  pvalue = length(which(permTestStats>=t))/nPerms
  print(paste0("Permutation P value: ", pvalue))
  
  return(c(pvalue, individualPvalues, bonfReject, indtRejectMain, indtRejectLi))

}

