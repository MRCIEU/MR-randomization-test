

##
## make grid of parameter combinations, for params corrs, or and ncs


# versions with no selection i.e. all participants included
params <- expand.grid(

        rCovars=c(-1,0,0.2,0.4,0.8),
        rSelection=c(0.05, 0.1, 0.2),
        ncNotS=c(2,10,50),
        ncs=c(2,10,50),
        ivEffect=c(0.05),
        iv=c('grs'),
        covarsIncluded=c('all'),
        allParticipants=c(1)
)



##
## get simulation results for each permutation of parameters

source('loadSelectionPoissonResults.R')

resDir=Sys.getenv('RES_DIR')
resFile = paste0(resDir, '/sims/selection/sim-resFIX-poisson.csv')

# write output file header line
cat(paste0(paste(colnames(params), collapse=','), ",covar,n,mean,sd"), file=resFile, sep="\n", append=FALSE)


# generate summary stat for each param combination and save results to file
for (i in 1:nrow(params)) {

	# get all the poisson paramters across all of the simulation iterations
	x = loadSelectionPoissonResults(params[i,])

	if (!is.null(x)) {

	ncs = params$ncs[i]

	for (ic in 1:ncs) {

		# get all the interaction terms
		ix = which(grepl(paste0(":V",ic,'$'),x$V2))

	        print(paste0("Interactions for V",ic,": ", length(ix), ", ", mean(x$V3[ix]), " (", mean(x$V4[ix]), ")"))

		resLine = cbind(params[i,], paste0("V",ic), length(ix), mean(x$V3[ix]), mean(x$V4[ix]))
		cat(paste(resLine, collapse=','), file=resFile, append=TRUE, sep='\n' )

	}


	# get all the interaction terms
	ix = which(grepl(":",x$V2))

	print(paste0("All interactions and covariates: ", length(ix), ", ", mean(x$V3[ix]), " (", mean(x$V4[ix]), ")"))

	resLine = cbind(params[i,], "all", length(ix), mean(x$V3[ix]), mean(x$V4[ix]))
	cat(paste(resLine, collapse=','), file=resFile, append=TRUE, sep='\n' )
	
	
	}
}
