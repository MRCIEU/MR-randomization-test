

###
### simulation to test Branson complete randomization approach

## instrument Z, exposure X, covariates C and outcome Y

set.seed(123456)

resDir=Sys.getenv('RES_DIR')


args = commandArgs(trailingOnly=TRUE)

# ncs: number of covariates affecting selection
# ncNOTs: number of covariates not affecting selection
# corrC: correlation between covariates C
ncs = as.numeric(args[1])
ncNOTs = as.numeric(args[2])
nc = ncs + ncNOTs

# >=0: all covariates generated assuming we are sampling from a population with that correlation
# -1: generated with a normal distributions N~(0,0.1)
corrC = as.numeric(args[3])

totalEffect = as.numeric(args[4])
ivEffect = as.numeric(args[5])
iv=args[6]

# half: generate the data as normal but only include half the covariates that affect and dont affect selection in the tested covariates set
covarsIncluded = args[7]

# allSample is boolean denoting whether to run in whole sample instead, to check no bias i.e. p~0.05 from Branson approach
allSample = as.numeric(args[8])
if (is.null(allSample) | is.na(allSample)) {
  allSample = 0
}


# set default settings
if (is.null(iv) | is.na(iv)) {
  iv="grs"
}

if (is.na(ivEffect)) {
  ivEffect = 0.1
}

if (is.null(covarsIncluded) | is.na(covarsIncluded)) {
  covarsIncluded = "all"
}


print('-------------------')
print(paste0("Number of covariates that affect selection: ", ncs))
print(paste0("Number of covariates that do not affect selection: ", ncNOTs))
print(paste0("Correlation between covariates (r2): ", corrC))
print(paste0("Total effect of covariates and X on selection (r2): ", totalEffect))
print(paste0("Effect of IV on X (r2):", ivEffect))
print(paste0("IV type (either 'dosage' or 'grs'):", iv))
print(paste0("Covariates included in tested covariate set:", covarsIncluded))
print(paste0("Run in whole sample rather than selected subsample:", allSample))
print('-------------------')


library(parallel)
cl <- makeCluster(10)
clusterSetRNGStream(cl, iseed = 42)
y <- parLapply(cl, 1:10, function(seed, nc, ncs, corrC, ncNOTs, totalEffect, iv, ivEffect, covarsIncluded, resDir, allSample) {

  # reset file storing poisson parameters
  filename=paste0("/sims/selection/sim-out-poissonFIX-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, "-iv", iv, ivEffect, '-', covarsIncluded, '-', allSample, "_", seed, ".txt")
  cat("", file=paste0(resDir, filename), sep="\n", append=FALSE)


  # start logging
  sink(paste0(resDir, "/sims/selection/sim-outFIX-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, "-iv", iv, ivEffect, '-', covarsIncluded, "-", allSample, "_", seed, ".log"))

  source('doSimSelection.R')

  # results file
  filename=paste0("/sims/selection/sim-outFIX-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, "-iv", iv, ivEffect, '-', covarsIncluded, '-', allSample, "_", seed, ".txt")


  for (i in 1:50) {

    print(paste0('ITER: ', i))
  
    pvalue = doSimSelection(nc=nc, ncs=ncs, corrC=corrC, totalEffectSelection=totalEffect, iv=iv, ivEffect=ivEffect, covarsIncluded=covarsIncluded, seed=seed, all=allSample, resDir=resDir, rep=i)

    if (i==1) {
      headernames = names(unlist(pvalue))
      cat(paste0("i,", paste0(names(unlist(pvalue)), collapse=',')), file=paste0(resDir, filename), sep="\n", append=FALSE)
    }

    cat(paste0(i, ",",paste(unlist(pvalue), collapse=',')), file=paste0(resDir, filename), sep="\n", append=TRUE)

    print("END ITER")  
  }

  print("END 50")

  sink()

}, nc=nc, ncs=ncs, corrC=corrC, ncNOTs=ncNOTs, totalEffect=totalEffect, iv=iv, ivEffect=ivEffect, covarsIncluded=covarsIncluded, resDir=resDir, allSample=allSample)
stopCluster(cl)


