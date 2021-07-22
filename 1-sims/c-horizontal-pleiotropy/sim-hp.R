

###
### simulation to test Branson complete randomization approach

## instrument Z, exposure X, covariates C and outcome Y

set.seed(123456)

resDir=Sys.getenv('RES_DIR')


args = commandArgs(trailingOnly=TRUE)

# ncHP: number of covariates affected by the HP snps
# ncNotHP: number of covariates not affected by the HP snps
# corrC: correlation between covariates C
ncHP = as.numeric(args[1])
ncNotHP = as.numeric(args[2])
nc = ncHP + ncNotHP

# >=0: all covariates generated assuming we are sampling from a population with that correlation
# -1: generated with a normal distributions N~(0,0.1)
corrC = as.numeric(args[3])

numHPSnps = as.numeric(args[4])
numNotHPSnps = as.numeric(args[5])
numSnps = numHPSnps + numNotHPSnps

ivEffect = as.numeric(args[6])
iv=args[7]

# half: generate the data as normal but only include half the covariates in C_HP and C_notHP in the tested covariates set
covarsIncluded = args[8]



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
print(paste0("Number of covariates: ", nc))
print(paste0("Number of covariates that are affected by snps: ", ncHP))
print(paste0("Correlation between covariates (r2): ", corrC))
print(paste0("Effect of IV on X (r2):", ivEffect))
print(paste0("IV type (either 'dosage' or 'grs'):", iv))
print(paste0("Covariates included in tested covariate set:", covarsIncluded))
print(paste0("Num SNPs:", numSnps))
print(paste0("Num HP SNPs:", numHPSnps))
print('-------------------')


library(parallel)
cl <- makeCluster(10)
clusterSetRNGStream(cl, iseed = 42)
y <- parLapply(cl, 1:10, function(seed, nc, ncHP, corrC, iv, ivEffect, covarsIncluded, numSnps, numHPSnps, resDir) {

  ncNotHP = nc - ncHP
  numNotHPSnps = numSnps - numHPSnps

  sink(paste0(resDir, "/sims/hp/sim-out-", ncHP, "-", ncNotHP, "-", corrC, "-numHP", numHPSnps, "-", numNotHPSnps, "-iv", iv, ivEffect, '-', covarsIncluded, "_", seed, ".log"))

  source('doSimHP.R')

  filename=paste0("/sims/hp/sim-out-", ncHP, "-", ncNotHP, "-", corrC, "-numHP", numHPSnps, "-", numNotHPSnps, "-iv", iv, ivEffect, '-', covarsIncluded, "_", seed, ".txt")

  cat(paste0("i,p,", paste(paste0('p', 1:nc), collapse=','), ',bonf_reject,indtRejectMain,indtRejectLi'), file=paste0(resDir, filename), sep="\n", append=FALSE)

  for (i in 1:50) {
  
    pvalue = doSimHP(nc=nc, ncHP=ncHP, corrC=corrC, iv=iv, ivEffect=ivEffect, covarsIncluded=covarsIncluded, numSnps=numSnps, numHPSnps=numHPSnps, seed=seed)

    cat(paste0(i, ",",paste(pvalue, collapse=',')), file=paste0(resDir, filename), sep="\n", append=TRUE)
  
  }

  sink()

}, nc=nc, ncHP=ncHP, corrC=corrC, iv=iv, ivEffect=ivEffect, covarsIncluded=covarsIncluded, numSnps=numSnps, numHPSnps=numHPSnps, resDir=resDir)
stopCluster(cl)


