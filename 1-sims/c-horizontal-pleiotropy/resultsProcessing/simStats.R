


simStats <- function(params) {

  ncHP = params$ncHP
  ncNOTHP = params$ncNotHP
  nc = ncHP + ncNOTHP
  corrC = params$rCovars
  numSNPsHP = params$numSNPsHP
  numSNPsNOTHP = params$numSNPsNOTHP

  resDir=Sys.getenv('RES_DIR')

  print('-------------------')
  print(paste0("Number of HP covariates: ", ncHP))
  print(paste0("Number of non HP covariates: ", ncNOTHP))
  print(paste0("Correlation between covariates: ", corrC))
  print(paste0("Number of HP SNPs: ", numSNPsHP))
  print(paste0("Number of non HP SNPs: ", numSNPsNOTHP))
  print('-------------------')


  ###
  ### load results files

  seed=1
  filename=paste0(resDir, "/sims/hp/sim-out-", ncHP, "-", ncNOTHP, "-", corrC, "-numHP",numSNPsHP, "-", numSNPsNOTHP, "-ivdosage0.05-all_", seed, ".txt")
  print(filename)

  # check if results exist yet
  if (file.exists(filename)) {

    simRes = read.table(filename, sep=',', header=1)

  } else {
    # no results files yet for this param combination
    print("NO RESULTS FOR THIS PARAM COMBINATION")
    return(list(numRes=NA, powerBranson=NA, mcseBranson=NA, powerBon=NA, mcseBon=NA, powerInd=NA, mcseInd=NA, powerIndLi=NA, mcseIndLi=NA))
  }

  for (seed in 2:10) {

    filename=paste0(resDir, "/sims/hp/sim-out-", ncHP, "-", ncNOTHP, "-", corrC, "-numHP",numSNPsHP, "-", numSNPsNOTHP, "-ivdosage0.05-all_", seed, ".txt")
    if (file.exists(filename)) {

      simResPart = read.table(filename, sep=',', header=1)
      simRes = rbind(simRes, simResPart)
    }
  }

  numRes = nrow(simRes)
  print(paste0('number of simulation results: ', numRes))
#  if (numRes!=500) {
#    stop(paste0('number of results not 500: ', numRes))
#  }

  ######
  ###### OVERALL TEST ACROSS ALL SNPS

  ###
  ### calculate power and MCSE for branson test

  numBransReject = length(which(simRes$pvalueMD<0.05))
  powerBranson = numBransReject/numRes

  mcseBranson = (powerBranson*(1-powerBranson)/numRes)^0.5


  ###
  ### calculate power and MCSE for bonferoni correction approach

  numBonfReject = length(which(simRes$bonfRejectAll == 1))
  powerBon = numBonfReject/numRes

  mcseBon = (powerBon*(1-powerBon)/numRes)^0.5


  ###
  ### calculate power and MCSE for number of independent tests correction

  # calculated power/mcse
  numIndepReject = length(which(simRes$indtRejectMainAll == 1))
  powerIndep = numIndepReject/numRes

  mcseIndep = (powerIndep*(1-powerIndep)/numRes)^0.5


  # calculated power/mcse
  numIndepRejectLi = length(which(simRes$indtRejectLiAll == 1))
  powerIndepLi = numIndepRejectLi/numRes

  mcseIndepLi = (powerIndepLi*(1-powerIndepLi)/numRes)^0.5



  ######
  ###### proportion of hp snps where h0 rejected, across all sim interations

  hpzcols = paste0("pvalueMDz", 1:numSNPsHP)
  nresAcrossSNPs = length(hpzcols)*nrow(simRes)

  simRes$numSnpsFoundRand = apply(simRes[,hpzcols, drop=FALSE], 1, numFound)
  powerBranPerSnp = sum(simRes$numSnpsFoundRand)/nresAcrossSNPs
  mcseBranPerSnp = (powerBranPerSnp*(1-powerBranPerSnp)/nresAcrossSNPs)^0.5

  hpzcols = paste0("bonfRejectPerZ", 1:numSNPsHP)
  simRes$numSnpsFoundBonf = apply(simRes[,hpzcols, drop=FALSE], 1, numFoundReject)
  powerBonfPerSnp = sum(simRes$numSnpsFoundBonf)/nresAcrossSNPs
  mcseBonfPerSnp = (powerBonfPerSnp*(1-powerBonfPerSnp)/nresAcrossSNPs)^0.5

  hpzcols = paste0("indtRejectMainPerZ", 1:numSNPsHP)
  simRes$numSnpsFoundIndM = apply(simRes[,hpzcols, drop=FALSE], 1, numFoundReject)
  powerIndMPerSnp = sum(simRes$numSnpsFoundIndM)/nresAcrossSNPs
  mcseIndMPerSnp = (powerIndMPerSnp*(1-powerIndMPerSnp)/nresAcrossSNPs)^0.5

  hpzcols = paste0("indtRejectLiPerZ", 1:numSNPsHP)
  simRes$numSnpsFoundIndL = apply(simRes[,hpzcols, drop=FALSE], 1, numFoundReject)
  powerIndLPerSnp = sum(simRes$numSnpsFoundIndL)/nresAcrossSNPs
  mcseIndLPerSnp = (powerIndLPerSnp*(1-powerIndLPerSnp)/nresAcrossSNPs)^0.5


  return(list(numRes=numRes, powerBranson=powerBranson, mcseBranson=mcseBranson, 
		powerBon=powerBon, mcseBon=mcseBon, powerInd=powerIndep, mcseInd=mcseIndep, 
		powerIndLi=powerIndepLi, mcseIndLi=mcseIndepLi,
		powerBranPerSnp=powerBranPerSnp, mcseBranPerSnp=mcseBranPerSnp,
		powerBonfPerSnp=powerBonfPerSnp, mcseBonfPerSnp=mcseBonfPerSnp,
		powerIndMPerSnp=powerIndMPerSnp, mcseIndMPerSnp=mcseIndMPerSnp,
		powerIndLPerSnp=powerIndLPerSnp, mcseIndLPerSnp=mcseIndLPerSnp))
}

indepCheck <- function(rowVec, pCols, pThresh) {

  # for a particular sim iteration, count the number of tests with a pvalue less than pThresh
  numBelow = length(which(rowVec[pCols]<pThresh))

  # return a boolean - whether at least 1 of the p values is below pThresh
  return(numBelow>0)

}


# find all p values less than 0.05
numFound <- function(rowVec) {
	return(length(which(rowVec<0.05)))
}

# find all those with a 1, indicating this test rejected the null hypothesis
numFoundReject <- function(rowVec) {
        return(length(which(rowVec==1)))
}


