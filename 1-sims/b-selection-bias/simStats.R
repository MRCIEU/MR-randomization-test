


simStats <- function(params) {

  ncs = params$ncs
  ncNOTs = params$ncNotS
  nc = ncs + ncNOTs
  corrC = params$rCovars
  totalEffect = params$rSelection
  ivEffect = params$ivEffect
  iv=params$iv
  covarsIncluded=params$covarsIncluded

  resDir=Sys.getenv('RES_DIR')

  print('-------------------')
  print(paste0("Number of covariates that affect selection: ", ncs))
  print(paste0("Number of covariates that do not affect selection: ", ncNOTs))
  print(paste0("Correlation between covariates: ", corrC))
  print(paste0("Total effect of covariates on selection: ", totalEffect))
  print(paste0("Effect of IV on X: ", ivEffect))
  print('-------------------')


  ###
  ### load results files

  seed=1
  filename=paste0(resDir, "/sims/sim-out-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, "-iv", iv, ivEffect, "-", covarsIncluded, "_", seed, ".txt")
  print(filename)


  # check if results exist yet
  if (file.exists(filename)) {

    if (covarsIncluded=="all") {
    simRes = read.table(filename, sep=',', header=1)
    }
    else {
      # temp fix for incorrect header (not half p's for 'half' covars included)
      simRes = read.table(filename, sep=',', header=0, skip=1)
      ncsInc = floor(ncs/2)
      ncnotsInc = floor((nc-ncs)/2)
      ncInc = ncsInc + ncnotsInc
      colnames(simRes) = c("i","p",paste0('p', 1:ncInc),"bonf_reject","indtRejectMain","indtRejectLi")
    }

  }
  else {
    # no results files yet for this param combination
    print("NO RESULTS FOR THIS PARAM COMBINATION")
    return(list(numRes=NA, powerBranson=NA, mcseBranson=NA, powerBon=NA, mcseBon=NA, powerInd=NA, mcseInd=NA, powerIndLi=NA, mcseIndLi=NA))
  }

  for (seed in 2:10) {

      filename=paste0(resDir, "/sims/sim-out-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, "-iv", iv, ivEffect, "-", covarsIncluded, "_", seed, ".txt")

    if (file.exists(filename)) {

    if (covarsIncluded=="all") {
      simResPart = read.table(filename, sep=',', header=1)
    }
    else {
      #	temp fix for incorrect header (not half	p's for	'half' covars included)
      simResPart = read.table(filename, sep=',', header=0, skip=1)
      ncsInc = floor(ncs/2)
      ncnotsInc = floor((nc-ncs)/2)
      ncInc = ncsInc + ncnotsInc
      colnames(simResPart) = c("i","p",paste0('p', 1:ncInc),"bonf_reject","indtRejectMain", "indtRejectLi")
    }


      simRes = rbind(simRes, simResPart)
    }
}

  numRes = nrow(simRes)
  print(paste0('number of simulation results: ', numRes))


  ###
  ### calculate power and MCSE for branson test

  numBransReject = length(which(simRes$p<0.05))
  powerBranson = numBransReject/numRes

  mcseBranson = (powerBranson*(1-powerBranson)/numRes)^0.5


  ###
  ### calculate power and MCSE for bonferoni correction approach

  numBonfReject = length(which(simRes$bonf_reject == 1))
  powerBon = numBonfReject/numRes

  mcseBon = (powerBon*(1-powerBon)/numRes)^0.5


  ###
  ### calculate power and MCSE for number of independent tests correction

  # calculated power/mcse
  numIndepReject = length(which(simRes$indtRejectMain == 1))
  powerIndep = numIndepReject/numRes

  mcseIndep = (powerIndep*(1-powerIndep)/numRes)^0.5


  # calculated power/mcse
  numIndepRejectLi = length(which(simRes$indtRejectLi == 1))
  powerIndepLi = numIndepRejectLi/numRes

  mcseIndepLi = (powerIndepLi*(1-powerIndepLi)/numRes)^0.5






  return(list(numRes=numRes, powerBranson=powerBranson, mcseBranson=mcseBranson, powerBon=powerBon, mcseBon=mcseBon, powerInd=powerIndep, mcseInd=mcseIndep, powerIndLi=powerIndepLi, mcseIndLi=mcseIndepLi))

}

indepCheck <- function(rowVec, pCols, pThresh) {

  # for a particular sim iteration, count the number of tests with a pvalue less than pThresh
  numBelow = length(which(rowVec[pCols]<pThresh))

  # return a boolean - whether at least 1 of the p values is below pThresh
  return(numBelow>0)

}
