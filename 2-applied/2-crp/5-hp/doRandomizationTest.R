
dataDir=Sys.getenv('PROJECT_DATA')
resDir=Sys.getenv('RES_DIR')


## get covars

covars = read.table(paste0(dataDir, '/phenotypes/derived/phenos-hp.csv'), header=1, sep=',')


## get IV - CRP GRS

zDF = read.table(paste0(dataDir, '/genetic/crp-grs-with-phenoIDs-subset.csv'), header=1, sep=',')

# get IV and covar data for participants that exist in both, ordered the same
alldata = merge(covars, zDF, by='eid', all.x=F, all.y=F)

## run randomization test for each CRP snp

snps = c("rs75460349","rs2293476","rs1805096","rs469772","rs4129267","rs2794520","rs10925027","rs12995480","rs1260326","rs4246598","rs9284725","rs13409371","rs1441169","rs2352975","rs687339","rs1514895","X3.47431869_GTCT_G","rs17658229","rs9271608","rs12202641","rs1490384","rs9385532","rs1880241","rs2710804","rs13233571","rs7795281","rs4841132","rs1736060","rs2064009","rs2891677","rs643434","rs1051338","rs10832027","rs10838687","rs1582763","rs7121935","rs11108056","rs10778215","rs7310409","rs2239222","rs112635299","rs4774590","rs1189402","rs340005","rs10521222","rs1558902","rs178810","rs10512597","X17.58001690_GA_G","rs2852151","rs4092465","rs12960928","rs4420638","rs1800961","rs2315008","rs2836878","rs6001193","rs9611441")

#cat(paste0("snp,randP,", paste(colnames(covars), collapse=','), ",bonf_reject,indtRejectMain,indtRejectLi,pRsq"), file=paste0(resDir, filename), sep="\n", append=FALSE)

library(parallel)
cl <- makeCluster(length(snps))
clusterSetRNGStream(cl, iseed = 42)
y <- parLapply(cl, snps, function(snp, alldata, resDir) {

	source('../../../1-sims/b-selection-bias/doRandomizationTest.R')
	source('../../../1-sims/generic-functions/getMahalanobisDist.R')
	source('../../../1-sims/generic-functions/numIndependentTests.R')
	
	sink(paste0(resDir, '/crp-hp',snp,'.log'))

	covars = alldata[,c("smok_pack_years", "bmi", "weight", "height", "leuk_count", "albumin", "apolip_a", "apolip_b", "chol", "glucose", "chol_hdl", "lipo_a", "sbp", "dbp", "waisthip")]
	invCovDFC = solve(as.matrix(stats::cov(covars, use="pairwise.complete.obs")))

	filename=paste0("/crp-hp-results-",snp,".txt")

	print(snp)
	snpData = alldata[,snp]
	print('running randomization test')
	results = doRandomizationTest(covars, snpData, invCovDFC)
	print(results)

	cat(paste0(snp, ",", paste(results, collapse=',')), file=paste0(resDir, filename), sep="\n", append=TRUE)

	sink()

}, alldata=alldata, resDir)

stopCluster(cl)


