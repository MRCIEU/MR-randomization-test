


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

  filename=paste0(resDir, "/sims/selection/sim-out-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, "-iv", iv, ivEffect, "-", covarsIncluded, "-", allParticipants, "_", seed, ".txt")
  print(filename)


  # check if results exist yet
  if (file.exists(filename)) {

    simRes = read.table(filename, sep=',', header=1)

  }
  else {
    # no results files yet for this param combination
    print("NO RESULTS FOR THIS PARAM COMBINATION")
    return(NULL)
  }

  for (seed in 2:10) {

    filename=paste0(resDir, "/sims/selection/sim-out-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, "-iv", iv, ivEffect, "-", covarsIncluded, "-", allParticipants, "_", seed, ".txt")

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

  return(simRes)

}
