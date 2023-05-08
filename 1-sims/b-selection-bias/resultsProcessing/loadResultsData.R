


loadResultsData <- function(params) {

  ncs = params$ncs
  ncNOTs = params$ncNotS
  nc = ncs + ncNOTs
  corrC = params$rCovars
  totalEffect = params$rSelection
  ivEffect = params$ivEffect
  iv=params$iv
  covarsIncluded=params$covarsIncluded
  allParticipants = params$allParticipants

  resDir=Sys.getenv('RES_DIR')

  print('-------------------')
  print(paste0("Number of covariates that affect selection: ", ncs))
  print(paste0("Number of covariates that do not affect selection: ", ncNOTs))
  print(paste0("Correlation between covariates: ", corrC))
  print(paste0("Total effect of covariates on selection: ", totalEffect))
  print(paste0("Effect of IV on X: ", ivEffect))
  
  print('-------------')


  ###
  ### load results files

  seed=1

  filename=paste0(resDir, "/sims/selection/sim-outFIX-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, "-iv", iv, ivEffect, "-", covarsIncluded, "-", allParticipants, "_", seed, ".txt")
  print(filename)


  # check if results exist yet
  if (file.exists(filename)) {

    simRes = read.table(filename, sep=',', header=1)

    print(nrow(simRes))

  }
  else {
    # no results files yet for this param combination
    print("NO RESULTS FOR THIS PARAM COMBINATION")
    return(NULL)
  }

  for (seed in 2:10) {

    filename=paste0(resDir, "/sims/selection/sim-outFIX-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, "-iv", iv, ivEffect, "-", covarsIncluded, "-", allParticipants, "_", seed, ".txt")
    print(filename)

    if (file.exists(filename)) {

      simResPart = read.table(filename, sep=',', header=1)

      print(nrow(simResPart))

      simRes = rbind(simRes, simResPart)
    }
}

#  numRes = nrow(simRes)
#  print(paste0('number of simulation results: ', numRes))
#  if (numRes!=500) {
#    stop(paste0('number of results not 500: ', numRes))
#  }




ix = which(colnames(simRes) == "pvalue")
if (length(ix) == 0) {

  ix = which(colnames(simRes) == "p")
  colnames(simRes)[ix] = "pvalue"

  ix = which(colnames(simRes) == "bonf_reject")
  colnames(simRes)[ix] = "pvalue"

  ix = which(colnames(simRes) == "pRsq")
  colnames(simRes)[ix] = "pvalueRsq"

  simRes$lowestP = apply(simRes[,paste0('p', 1:nc)], 1, min)
  simRes$indtMainP = simRes$lowestP*simRes$indepNumTestsMain  
  simRes$indtLiP = simRes$lowestP*simRes$indepNumTestsLi


}



  return(simRes)

}
