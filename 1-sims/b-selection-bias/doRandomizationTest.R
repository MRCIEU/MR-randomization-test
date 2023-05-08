

doRandomizationTest <- function(dfC, z, invCovDFC) {

  ncInc = ncol(dfC)

  ## generate MD stat for this dfC and z combination  
  t = as.numeric(getMD3CatsCorr(dfC, z, invCovDFC))
  print(t)

  rsq = max(abs(cor(dfC, z, use = "pairwise.complete.obs")))

  ###
  ### independent tests regressing X on Z

  individualPvalues = c()
  for (i in 1:ncInc) {

    sumx = summary(lm(dfC[,i] ~ z))

    pvalue = sumx$coefficients['z','Pr(>|t|)']
    print(paste0('i: ', pvalue, ', adjusted:', pvalue*ncInc))

    individualPvalues = c(individualPvalues, pvalue)

  }

  ## bonf reject boolean, using bonferroni threshold
  bonfP = min(individualPvalues)*ncInc
  bonfReject = bonfP<0.05


  ## Reject using equivalent number of independent tests (from correlation)


  #numIndepTests = 1+(ncInc-1)*(1-corrC)
  #pThresh = 0.05/numIndepTests
  #indtReject = min(individualPvalues)<pThresh

  

#  source('../generic-functions/numIndependentTests.R')

  ## gen equivalent number of independent tests across all the covariates
  corrDFC = as.data.frame(cor(dfC), use="pairwise.complete.obs")
  indepTestNums = numIndependentTests(corrDFC)

  print(paste0('indepMain: ', indepTestNums$indepMain))
  print(paste0('indepLi: ', indepTestNums$indepLi))

  ## Overall independent reject, using num indep tests across all z assumes z's are independent
  # main version
  pThreshIndMain = 0.05/indepTestNums$indepMain
  indtRejectMain = min(individualPvalues)<pThreshIndMain
  indtMainP = min(individualPvalues) * indepTestNums$indepMain

  # Li version
  pThreshIndLi = 0.05/indepTestNums$indepLi
  indtRejectLi = min(individualPvalues)<pThreshIndLi
  indtLiP = min(individualPvalues) * indepTestNums$indepLi


  ###
  ### permutation testing

  print('### Permutation testing ###')
  
  # distribution of test statistics generated under the null of complete randomization
  permTestStats = c()
  permTestStatsRsq = c()
  nPerms = 5000

  for (i in 1:nPerms) {
    
    # randomly permute z
    zperm = sample(z, length(z), replace=FALSE)
    
    # calculate test statistic on permuted data
    testStatPerm = getMD3CatsCorr(dfC, zperm, covX.inv=invCovDFC)
    
    # add test stat of permutated data to our empirial distribution of test statistics
    permTestStats = c(permTestStats, testStatPerm)


    rsqPerm = max(abs(cor(dfC, zperm, use = "pairwise.complete.obs")))
    permTestStatsRsq = c(permTestStatsRsq, rsqPerm)


    if (i%%100==0) print(i)

  }
  
  
  ###
  ### summarise permutation testing null distribution of test statistics
  
  print(paste0('True test statistic: ', t))
  
  print('Summary of null distribution of test statistics (generated with permutation testing):')
  summary(permTestStats)
  
  # generate p value
  pvalue = length(which(permTestStats>=t))/nPerms
  print(paste0("Permutation P value: ", pvalue))


  # generate rsq permutation p value
  print(paste0("max absolute RSQ: ", rsq))
  pvalueRsq = length(which(permTestStatsRsq>=rsq))/nPerms
  print(paste0("RSQ permutation p value:", pvalueRsq))

#  write.table(permTestStatsRsq, 'testRSQ.txt', sep=',', col.names=FALSE)
#  write.table(permTestStats, 'testMD.txt', sep=',',	col.names=FALSE) 

  
  return(list(pvalue=pvalue, individualPvalues=individualPvalues, bonfReject=bonfReject, indtRejectMain=indtRejectMain, indtRejectLi=indtRejectLi, pvalueRsq=pvalueRsq, indepNumTestsMain=indepTestNums$indepMain, indepNumTestsLi=indepTestNums$indepLi, bonfP=bonfP, indtMainP=indtMainP, indtLiP=indtLiP))
}

