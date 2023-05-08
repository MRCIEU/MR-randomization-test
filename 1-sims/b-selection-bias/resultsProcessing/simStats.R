


simStats <- function(simRes, pthreshold=0.05, numCovs) {

  print(head(simRes))

  print(paste0('numCovs: ', numCovs))

  if (is.null(simRes)) {
    return(list(numRes=NA, powerBranson=NA, mcseBranson=NA, powerBon=NA, mcseBon=NA, powerInd=NA, mcseInd=NA, powerIndLi=NA, mcseIndLi=NA, powerRsq=NA, mcseRsq=NA))
  }

  numRes = nrow(simRes)

  ###
  ### calculate power and MCSE for branson test

  numBransReject = length(which(simRes$pvalue<pthreshold))
  powerBranson = numBransReject/numRes

  mcseBranson = (powerBranson*(1-powerBranson)/numRes)^0.5



  ###
  ### calculate power and MCSE for rsq randomization test

  numRsqReject = length(which(simRes$pvalueRsq<pthreshold))
  powerRsq = numRsqReject/numRes

  mcseRsq = (powerRsq*(1-powerRsq)/numRes)^0.5



  ###
  ### calculate power and MCSE for bonferoni correction approach

  # compare with theshold
  numBonfReject = length(which(simRes$bonfP <= pthreshold))
  powerBon = numBonfReject/numRes

  mcseBon = (powerBon*(1-powerBon)/numRes)^0.5


  ###
  ### calculate power and MCSE for number of independent tests correction

  # calculated power/mcse
  numIndepReject = length(which(simRes$indtMainP< pthreshold))
  powerIndep = numIndepReject/numRes

  mcseIndep = (powerIndep*(1-powerIndep)/numRes)^0.5



  # calculated power/mcse
  numIndepRejectLi = length(which(simRes$indtLiP < pthreshold))
  powerIndepLi = numIndepRejectLi/numRes

  mcseIndepLi = (powerIndepLi*(1-powerIndepLi)/numRes)^0.5






  return(list(numRes=numRes, powerBranson=powerBranson, mcseBranson=mcseBranson, powerBon=powerBon, mcseBon=mcseBon, powerInd=powerIndep, mcseInd=mcseIndep, powerIndLi=powerIndepLi, mcseIndLi=mcseIndepLi, powerRsq=powerRsq, mcseRsq=mcseRsq))

}

indepCheck <- function(rowVec, pCols, pThresh) {

  # for a particular sim iteration, count the number of tests with a pvalue less than pThresh
  numBelow = length(which(rowVec[pCols]<pThresh))

  # return a boolean - whether at least 1 of the p values is below pThresh
  return(numBelow>0)

}
