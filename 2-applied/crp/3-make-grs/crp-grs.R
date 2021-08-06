
dataDir=Sys.getenv('PROJECT_DATA')
mydata = read.table(paste0(dataDir, '/genetic/snp-data.txt'), header=1, sep=',')

mydata$crp_grs =  (2 - mydata$rs469772) * 0.031 +
mydata$rs12995480 * 0.031 +
mydata$rs4246598 * 0.022 +
(2 - mydata$rs9284725) * 0.027 +
(2 - mydata$rs1441169) * 0.025 +
mydata$rs2352975 * 0.025 +
mydata$rs17658229 * 0.056 +
mydata$rs9271608 * 0.042 +
(2 - mydata$rs12202641) * 0.023 + 
(2 - mydata$rs1490384) * 0.025 +
mydata$rs9385532 * 0.026 +
(2 - mydata$rs1880241) * 0.028 +
mydata$rs2710804 * 0.021 +
mydata$rs2064009 * 0.027 +
mydata$rs2891677 * 0.020 +
mydata$rs643434	* 0.023 +
mydata$rs1051338 * 0.024 +
mydata$rs10832027 * 0.026 +
(2 - mydata$rs10838687) * 0.031 +
(2 - mydata$rs1582763) * 0.022 +
(2 - mydata$rs7121935) * 0.022 + # NB: 3 alleles in snp, this one is dosage of A allele
(2 - mydata$rs11108056) * 0.028 +
mydata$rs2239222 * 0.035 +
(2 - mydata$rs4774590) * 0.022 +
mydata$rs1558902 * 0.034 +
mydata$rs178810	* 0.020 +
mydata$rs10512597 * 0.037 +
mydata$rs4092465 * 0.027 +
mydata$rs12960928 * 0.024 +
mydata$rs2315008 * 0.023 +
(2 - mydata$rs2836878) * 0.043 +
(2 - mydata$rs6001193) * 0.028 +
(2 - mydata$rs75460349) * 0.086 +
mydata$rs1514895 * 0.027 +
(2 - mydata$rs112635299) * 0.107 +
(2 - mydata$rs1189402) * 0.025 +
mydata[,"X3.47431869_GTCT_G"] * 0.024 +
(2 - mydata$rs687339) *	0.030 +
(2 - mydata$rs7795281) * 0.028 +
mydata$rs1736060 * 0.029 +
(2 - mydata[,"X17.58001690_GA_G"]) * 0.026 +
(2 - mydata$rs9611441) * 0.022 +
mydata$rs2293476 * 0.030 +
(2 - mydata$rs1805096) * 0.104 +
(2 - mydata$rs4129267) * 0.088 +
(2 - mydata$rs2794520) * 0.182 +
(2 - mydata$rs10925027) * 0.036 +
(2 - mydata$rs1260326) * 0.073 +
mydata$rs13409371 * 0.048 +
(2 - mydata$rs13233571) * 0.057 + 
mydata$rs4841132 * 0.065 +
(2 - mydata$rs10778215) * 0.033 + 
mydata$rs7310409 * 0.137 +
mydata$rs340005 * 0.030 +
(2 - mydata$rs10521222) * 0.104 +
mydata$rs2852151 * 0.025 +
(2 - mydata$rs4420638) * 0.229 +
(2 - mydata$rs1800961) * 0.112


write.table(mydata, paste0(dataDir, '/genetic/crp-grs.csv'), row.names=F, col.names=T, sep=',')
