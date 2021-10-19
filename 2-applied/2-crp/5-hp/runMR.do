local dataDir: env PROJECT_DATA
local resDir : env RES_DIR

insheet using "`dataDir'/genetic/hp-data.csv"



replace crp = "" if crp == "NA"
destring crp, replace

ivprobit cad age male pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 (crp = crp_grs), first

ivprobit cad age male pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 (crp = crp_grs_hp), first



tempname memhold
postfile `memhold' str60 test estimate lower upper  using "`resDir'/results-hp-mr.dta", replace



gen logcrp = log(crp)

ivprobit cad age male pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 (logcrp = crp_grs), first
local beta = _b[logcrp]
local se = _se[logcrp]
local ciL _b[logcrp] - 1.96 * _se[logcrp]
local ciU _b[logcrp] + 1.96 * _se[logcrp]
post `memhold' ("grs") (`beta') (`ciL') (`ciU')


ivprobit cad age male pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 (logcrp = crp_grs_hp), first
local beta = _b[logcrp]
local se = _se[logcrp]
local ciL _b[logcrp] - 1.96 * _se[logcrp]
local ciU _b[logcrp] + 1.96 * _se[logcrp]
post `memhold' ("grs0_05_nonhp") (`beta') (`ciL') (`ciU')


ivprobit cad age male pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 (logcrp = crp_grs_withhp), first
local beta = _b[logcrp]
local se = _se[logcrp]
local ciL _b[logcrp] - 1.96 * _se[logcrp]
local ciU _b[logcrp] + 1.96 * _se[logcrp]
post `memhold' ("grs0_05_hp") (`beta') (`ciL') (`ciU')


ivprobit cad age male pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 (logcrp = crp_grs_0_001_hp), first
local beta = _b[logcrp]
local se = _se[logcrp]
local ciL _b[logcrp] - 1.96 * _se[logcrp]
local ciU _b[logcrp] + 1.96 * _se[logcrp]
post `memhold' ("grs0_001_hp") (`beta') (`ciL') (`ciU')


ivprobit cad age male pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 (logcrp = crp_grs_0_001), first
local beta = _b[logcrp]
local se = _se[logcrp]
local ciL _b[logcrp] - 1.96 * _se[logcrp]
local ciU _b[logcrp] + 1.96 * _se[logcrp]
post `memhold' ("grs0_001_nonhp") (`beta') (`ciL') (`ciU')



postclose `memhold' 

use "`resDir'/results-hp-mr.dta", clear
outsheet using "`resDir'/results-hp-mr.csv", comma replace

