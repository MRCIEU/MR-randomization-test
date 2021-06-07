


simStats <- function(params) {

  ncs = params$ncs
  ncNOTs = params$ncNotS
  corrC = params$rCovars
  totalEffect = params$rSelection

  resDir=Sys.getenv('RES_DIR')

  print('-------------------')
  print(paste0("Number of covariates that affect selection: ", ncs))
  print(paste0("Number of covariates that do not affect selection: ", ncNOTs))
  print(paste0("Correlation between covariates: ", corrC))
  print(paste0("Total effect of covariates on selection: ", totalEffect))
  print('-------------------')


  ###
  ### load results files

  seed=1
  filename=paste0(resDir, "/sims/sim-out-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, "_", seed, ".txt")

  # check if results exist yet
  if (file.exists(filename)) {
    simRes = read.table(filename, sep=',', header=1)
  }
  else {
    # no results files yet for this param combination
    print("NO RESULTS FOR THIS PARAM COMBINATION")
    return(list(numRes=NA, powerBranson=NA, mcseBranson=NA, powerBon=NA, mcseBon=NA, powerInd=NA, mcseInd=NA))
  }

  for (seed in 2:10) {

    filename=paste0(resDir, "/sims/sim-out-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, "_", seed, ".txt")

    if (file.exists(filename)) {
      simResPart = read.table(filename, sep=',', header=1)
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
  numIndepReject = length(which(simRes$indtReject == 1))
  powerIndep = numIndepReject/numRes

  mcseIndep = (powerIndep*(1-powerIndep)/numRes)^0.5




  return(list(numRes=numRes, powerBranson=powerBranson, mcseBranson=mcseBranson, powerBon=powerBon, mcseBon=mcseBon, powerInd=powerIndep, mcseInd=mcseIndep))

}

indepCheck <- function(rowVec, pCols, pThresh) {

  # for a particular sim iteration, count the number of tests with a pvalue less than pThresh
  numBelow = length(which(rowVec[pCols]<pThresh))

  # return a boolean - whether at least 1 of the p values is below pThresh
  return(numBelow>0)

}
