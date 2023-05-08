


simStats <- function(params, pthreshold=0.05) {

  ncHP = params$ncHP
  ncNOTHP = params$ncNotHP
  nc = ncHP + ncNOTHP
  corrC = params$rCovars
  numSNPsHP = params$numSNPsHP
  numSNPsNOTHP = params$numSNPsNOTHP
  hpEffect = params$hpEffect

  resDir=Sys.getenv('RES_DIR')

  print('-------------------')
  print(paste0("Number of HP covariates: ", ncHP))
  print(paste0("Number of non HP covariates: ", ncNOTHP))
  print(paste0("Correlation between covariates: ", corrC))
  print(paste0("Number of HP SNPs: ", numSNPsHP))
  print(paste0("Number of non HP SNPs: ", numSNPsNOTHP))
  print(paste0("Effect of HP SNP on covariates: ", hpEffect))
  print('-------------------')


  ###
  ### load results files

  seed=1
  filename=paste0(resDir, "/sims/hp/sim-out-", ncHP, "-", ncNOTHP, "-", corrC, "-numHP",numSNPsHP, "-", numSNPsNOTHP, "-ivdosage0.05-all-",hpEffect,"_", seed, ".txt")
  print(filename)

  # check if results exist yet
  if (file.exists(filename)) {

    simRes = read.table(filename, sep=',', header=1)

  } else {
    # no results files yet for this param combination
    print("NO RESULTS FOR THIS PARAM COMBINATION")
    return(list(numRes=NA, powerBranson=NA, mcseBranson=NA, powerBon=NA, mcseBon=NA, powerInd=NA, mcseInd=NA, powerIndLi=NA, mcseIndLi=NA))
  }

  for (seed in 2:50) {

    filename=paste0(resDir, "/sims/hp/sim-out-", ncHP, "-", ncNOTHP, "-", corrC, "-numHP",numSNPsHP, "-", numSNPsNOTHP, "-ivdosage0.05-all-",hpEffect,"_", seed, ".txt")
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

  numBransReject = length(which(simRes$resultsHP.pvalue<pthreshold))
  powerBranson = numBransReject/numRes

  mcseBranson = (powerBranson*(1-powerBranson)/numRes)^0.5


  ###
  ### calculate power and MCSE for rsq randomization test

  numRsqReject = length(which(simRes$resultsHP.pvalueRsq<pthreshold))
  powerRsq = numRsqReject/numRes

  mcseRsq = (powerRsq*(1-powerRsq)/numRes)^0.5



  ###
  ### calculate power and MCSE for bonferoni correction approach

  numBonfReject = length(which(simRes$resultsHP.bonfP <= pthreshold))
  powerBon = numBonfReject/numRes

  mcseBon = (powerBon*(1-powerBon)/numRes)^0.5


  ###
  ### calculate power and MCSE for number of independent tests correction

  # calculated power/mcse
  numIndepReject = length(which(simRes$resultsHP.indtMainP< pthreshold))
  powerIndep = numIndepReject/numRes

  mcseIndep = (powerIndep*(1-powerIndep)/numRes)^0.5


  # calculated power/mcse
  numIndepRejectLi = length(which(simRes$resultsHP.indtLiP < pthreshold))
  powerIndepLi = numIndepRejectLi/numRes

  mcseIndepLi = (powerIndepLi*(1-powerIndepLi)/numRes)^0.5




  ###
  ### calculate power and MCSE for branson test

  numBransRejectX = length(which(simRes$resultsNotHP.pvalue<pthreshold))
  powerBransonX = numBransRejectX/numRes

  mcseBransonX = (powerBransonX*(1-powerBransonX)/numRes)^0.5


  ###
  ### calculate power and MCSE for rsq randomization test

  numRsqRejectX = length(which(simRes$resultsNotHP.pvalueRsq<pthreshold))
  powerRsqX = numRsqRejectX/numRes

  mcseRsqX = (powerRsqX*(1-powerRsqX)/numRes)^0.5



  ###
  ### calculate power and MCSE for bonferoni correction approach

#  numBonfRejectX = length(which(simRes$resultsNotHP.bonfReject == 1))
  numBonfRejectX = length(which(simRes$resultsNotHP.bonfP <= pthreshold))
  powerBonX = numBonfRejectX/numRes

  mcseBonX = (powerBonX*(1-powerBonX)/numRes)^0.5


  ###
  ### calculate power and MCSE for number of independent tests correction

  # calculated power/mcse
#  numIndepRejectX = length(which(simRes$resultsNotHP.indtRejectMain == 1))
  numIndepRejectX = length(which(simRes$resultsNotHP.indtMainP< pthreshold))
  powerIndepX = numIndepRejectX/numRes

  mcseIndepX = (powerIndepX*(1-powerIndepX)/numRes)^0.5


  # calculated power/mcse
#  numIndepRejectLiX = length(which(simRes$resultsNotHP.indtRejectLi == 1))
  numIndepRejectLiX = length(which(simRes$resultsNotHP.indtLiP < pthreshold))
  powerIndepLiX = numIndepRejectLiX/numRes

  mcseIndepLiX = (powerIndepLiX*(1-powerIndepLiX)/numRes)^0.5






  return(list(numRes=numRes, powerBranson=powerBranson, mcseBranson=mcseBranson, 
		powerBon=powerBon, mcseBon=mcseBon, powerInd=powerIndep, mcseInd=mcseIndep, 
		powerIndLi=powerIndepLi, mcseIndLi=mcseIndepLi, powerRsq=powerRsq, mcseRsq=mcseRsq,
		powerBransonNot=powerBransonX, mcseBransonNot=mcseBransonX,
                powerBonNot=powerBonX, mcseBonNot=mcseBonX, powerIndNot=powerIndepX, mcseIndNot=mcseIndepX,
                powerIndLiNot=powerIndepLiX, mcseIndLiNot=mcseIndepLiX, powerRsqNot=powerRsqX, mcseRsqNot=mcseRsqX
))
}

indepCheck <- function(rowVec, pCols, pThresh) {

  # for a particular sim iteration, count the number of tests with a pvalue less than pThresh
  numBelow = length(which(rowVec[pCols]<pThresh))

  # return a boolean - whether at least 1 of the p values is below pThresh
  return(numBelow>0)

}



