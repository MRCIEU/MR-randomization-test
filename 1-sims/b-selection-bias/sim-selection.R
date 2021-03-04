

###
### simulation to test Branson complete randomization approach

## instrument Z, exposure X, covariates C and outcome Y


#source('doSimSelection.R')

set.seed(123456)

resDir=Sys.getenv('RES_DIR')



args = commandArgs(trailingOnly=TRUE)

# ncs: number of covariates affecting selection
# ncNOTs: number of covariates not affecting selection
# corrC: correlation between covariates C
ncs = as.numeric(args[1])
ncNOTs = as.numeric(args[2])
nc = ncs + ncNOTs
corrC = as.numeric(args[3])

print('-------------------')
print(paste0("Number of covariates that affect selection: ", ncs))
print(paste0("Number of covariates that do not affect selection: ", ncNOTs))
print(paste0("Correlation between covariates: ", corrC))
print('-------------------')


library(parallel)
cl <- makeCluster(10)
clusterSetRNGStream(cl, iseed = 42)
y <- parLapply(cl, 1:10, function(seed, nc, ncs, corrC, ncNOTs, resDir) {

  source('doSimSelection.R')

  filename=paste0("/sims/sim-out-", ncs, "-", ncNOTs, "-", corrC, "_", seed, ".txt")

  cat(paste0("i,p,", paste(paste0('p', 1:nc), collapse=','), ',indep_bonf_reject'), file=paste0(resDir, filename), sep="\n", append=FALSE)

  for (i in 1:50) {
  
    pvalue = doSimSelection(nc, ncs, corrC)
  
    cat(paste0(i, ",",paste(pvalue, collapse=',')), file=paste0(resDir, filename), sep="\n", append=TRUE)
  
}


}, nc=nc, ncs=ncs, corrC=corrC, ncNOTs=ncNOTs, resDir=resDir)
stopCluster(cl)


