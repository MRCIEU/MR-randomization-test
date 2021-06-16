

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
corrC = as.numeric(args[3])
totalEffect = as.numeric(args[4])
ivEffect = as.numeric(args[5])
iv=args[6]


# set default settings
if (is.null(iv)) {
  iv="grs"
}

if (is.na(ivEffect))
  ivEffect = 0.1

print('-------------------')
print(paste0("Number of covariates that affect selection: ", ncs))
print(paste0("Number of covariates that do not affect selection: ", ncNOTs))
print(paste0("Correlation between covariates (r2): ", corrC))
print(paste0("Total effect of covariates on selection (r2): ", totalEffect))
print(paste0("Effect of IV on X (r2):", ivEffect))
print(paste0("IV type (either "dosage" or "grs"):", iv))
print('-------------------')


library(parallel)
cl <- makeCluster(10)
clusterSetRNGStream(cl, iseed = 42)
y <- parLapply(cl, 1:10, function(seed, nc, ncs, corrC, ncNOTs, totalEffect, iv, ivEffect, resDir) {

  source('doSimSelection.R')

  filename=paste0("/sims/sim-out-", ncs, "-", ncNOTs, "-", corrC, "-", totalEffect, '-iv', iv, , ivEffect, "_", seed, ".txt")

  cat(paste0("i,p,", paste(paste0('p', 1:nc), collapse=','), ',bonf_reject,indtReject'), file=paste0(resDir, filename), sep="\n", append=FALSE)

  for (i in 1:50) {
  
    pvalue = doSimSelection(nc, ncs, corrC, totalEffect, iv, ivEffect)
  
    cat(paste0(i, ",",paste(pvalue, collapse=',')), file=paste0(resDir, filename), sep="\n", append=TRUE)
  
}


}, nc=nc, ncs=ncs, corrC=corrC, ncNOTs=ncNOTs, totalEffect=totalEffect, iv=iv, ivEffect=ivEffect, resDir=resDir)
stopCluster(cl)


