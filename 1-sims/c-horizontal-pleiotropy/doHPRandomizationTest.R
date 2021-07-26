


doHPRandomizationTest <- function(dfC, z, invCovDFC) {


  numZ = ncol(z)
  ncInc = ncol(dfC)

  ## generate vector of MD stats, one for each z
  mdT = c()
  for (i in 1: ncol(z)) {
    thist = as.numeric(getMD3CatsCorr(dfC, z[,i], invCovDFC))
    mdT = c(mdT, thist)
  }

  ## generate overall MD stat (across all z)
  tZall = sum(mdT)

  print('a')

  ###
  ### independent tests regressing X on each Z

  individualPvalues = matrix(NA, nrow=ncInc, ncol=numZ)

  for (zi in 1:numZ) {
  for (i in 1:ncInc) {
    thisz = z[,zi]
    sumx = summary(lm(dfC[,i] ~ thisz))

    pvalue = sumx$coefficients['thisz','Pr(>|t|)']
    print(paste0(i, ': ', pvalue, ', adjusted:', pvalue*ncInc*numZ))

    individualPvalues[i,zi] = pvalue

  }
  }

  ## overall bonf reject boolean, using bonferroni threshold across all z
  bonfRejectAll = (min(individualPvalues)*ncInc*numZ)<0.05

  ## vector of bonf reject booleans, using bonferroni threshold for each z
  bonfRejectPerZ = (apply(individualPvalues,2,min)*ncInc*numZ)<0.05
  
  print('b')

  ##  
  ## Reject using equivalent number of independent tests (from correlation)

  ## gen equivalent number of independent tests across all the covariates
  corrDFC = as.data.frame(cor(dfC))
  indepNumTestsPerZ = numIndependentTests(corrDFC)

  print(paste0('indepMain: ', indepNumTestsPerZ$indepMain))
  print(paste0('indepLi: ', indepNumTestsPerZ$indepLi))

  ## Overall independent reject, using num indep tests across all z assumes z's are independent
  # main version
  pThreshIndMainAll = 0.05/(indepNumTestsPerZ$indepMain*numZ)  
  indtRejectMainAll = min(individualPvalues)<pThreshIndMainAll
  
  ## Li version
  pThreshIndLiAll = 0.05/(indepNumTestsPerZ$indepLi*numZ)
  indtRejectLiAll = min(individualPvalues)<pThreshIndLiAll
  
  ## vector of independent rejects, using individual p values for each z, and number of independent tests
  indtRejectMainPerZ = apply(individualPvalues, 2, indtRejectMain, indepNumTestsPerZ)
  indtRejectLiPerZ = apply(individualPvalues, 2, indtRejectLi, indepNumTestsPerZ)

  print('c')


  ###
  ### permutation testing

  print('### Permutation testing ###')
  
  # distribution of test statistics generated under the null of complete randomization
  nPerms = 5000

  # rows are permutations, columns are z's
  permTestStats = matrix(NA, nrow=nPerms, ncol=numZ)

  for (i in 1:nPerms) {
    
    # randomly permute each column in z
    zperm = apply(z, 2, sample, replace=FALSE)
    
    # calculate test statistic on permuted data for each z
    for (zi in 1:numZ) {
      thist = as.numeric(getMD3CatsCorr(dfC, zperm[,zi], invCovDFC))
      
      # store t for this permutation and z
      permTestStats[i,zi] = thist
      
    }
        
    if (i%%100==0) print(i)

  }
  
  print('d')
  
  ###
  ### summarise permutation testing null distribution of test statistics
  
  print(paste0('True test statistic: ', t))
  
  print('Summary of null distribution of test statistics (generated with permutation testing):')
  summary(permTestStats)
  
  pvaluesMDZ = c()
  for (i in 1:numZ) {

   # get permutation p value for snp i
   thisZp = getZp(permTestStats[,i],mdT[i], nPerms)
   pvaluesMDZ = c(pvaluesMDZ, thisZp)
  }


  # generate overall p value
  pvalue = length(which(permTestStats>=t))/(numZ*nPerms)
  print(paste0("Permutation P value: ", pvalue))

  
  return(list(pvalueMD=pvalue, pvalueMDz = pvaluesMDZ, individualPvalues = individualPvalues, bonfRejectAll=bonfRejectAll, bonfRejectPerZ=bonfRejectPerZ, indtRejectMainAll=indtRejectMainAll, indtRejectLiAll=indtRejectLiAll, indtRejectMainPerZ=indtRejectMainPerZ, indtRejectLiPerZ=indtRejectLiPerZ))


}

# input array of perm test statistics
# outputs p value - the proportion of permTestStats >= t
getZp <-function(permTestStats, t, nPerms) {

  # higher MD -> higher assoc of covariates
  # p value is the 1-((#permT<t)/nPerms = (#permT>=t)/nPerms

  pvalue = length(which(permTestStats>=t))/nPerms
  return(pvalue)

}


## input individual pvalues (of associations of each covariate with a z)

indtRejectMain <- function(individualPvalues, indepNumTestsPerZ) {
  pThreshIndMain = 0.05/(indepNumTestsPerZ$indepMain)
  indtRejectMain = min(individualPvalues)<pThreshIndMain

  return(indtRejectMain)
}

indtRejectLi <- function(individualPvalues, indepNumTestsPerZ) {
  pThreshIndLi = 0.05/(indepNumTestsPerZ$indepLi)
  indtRejectLi = min(individualPvalues)<pThreshIndLi

  return(indtRejectLi)

}

