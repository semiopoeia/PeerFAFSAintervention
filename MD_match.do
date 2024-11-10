*using MDwork
use "D:\peerforward\MDwork.dta",clear
gen Alg1_MetExceed= 1-[(Level1ctAlg1/TestedCountAlg1)+(Level2ctAlg1/TestedCountAlg1)+(Level3ctAlg1/TestedCountAlg1)]
gen ELA10_MetExceed= 1- [(Level1ctELA10/TestedCountELA10)+ (Level2ctELA10/TestedCountELA10)+(Level3ctELA10/TestedCountELA10)]
egen Pull=rowmean(Alg1_MetExceed ELA10_MetExceed)
egen PriorAcadAch=std(Pull)
gen BlackHisp=BLBlack + HIHispanic
duplicates tag SchoolNumber, generate(dupe)
duplicates drop SchoolNumber, force
drop if PF==.
gen ID=_n
keep PF Seniors17 ID SchoolNumber LEAName City SchoolSchoolNumber Alg1_MetExceed ELA10_MetExceed PriorAcadAch BlackHisp
recast float SchoolNumber
gen NN1=.
gen NN2=.
gen NN3=.
mahapick (PriorAcadAch BlackHisp Seniors17), idvar(ID) treated(PF) pickids(NN1 NN2 NN3) genfile(NN_MD) replace nummatches(3)

*merge in NN_MD
merge 1:m ID using "D:\PeerForward_Match3to1_17_18\NN_MD.dta"
keep if _merge==3
tab PF
rename _prime_id PF_SchoolId
rename _matchnum NN
label define nn 0"PF matched school" 1"1st Nearest Neighbor" 2"2nd Nearest Neighbor" 3"3rd Nearest Neighbor"
label value NN nn
sort PF_SchoolId NN
save "D:\PeerForward_Match3to1_17_18\MD_NN_simple.dta",replace
*Export to Excel
export excel using "D:\PeerForward_Match3to1_17_18\MD_matchedSimple.xls", firstrow(variables) replace

*Multilevel model: are these schools significantly different on outcomes; did matching work well
local cov "PriorAcadAch Alg1_MetExceed ELA10_MetExceed BlackHisp Seniors17"
foreach x of local cov{
mixed `x' PF||PF_SchoolId:
}

use "D:\peerforward\MDwork.dta",clear
*rematch with just achievement variables
gen Alg1_MetExceed= 1-[(Level1ctAlg1/TestedCountAlg1)+(Level2ctAlg1/TestedCountAlg1)+(Level3ctAlg1/TestedCountAlg1)]
gen ELA10_MetExceed= 1- [(Level1ctELA10/TestedCountELA10)+ (Level2ctELA10/TestedCountELA10)+(Level3ctELA10/TestedCountELA10)]
egen Pull=rowmean(Alg1_MetExceed ELA10_MetExceed)
egen PriorAcadAch=std(Pull)
gen BlackHisp=BLBlack + HIHispanic
duplicates tag SchoolNumber, generate(dupe)
duplicates drop SchoolNumber, force
drop if PF==.
gen ID=_n
keep PF Seniors17 ID SchoolNumber LEAName City SchoolSchoolNumber Alg1_MetExceed ELA10_MetExceed PriorAcadAch BlackHisp
recast float SchoolNumber
gen NN1=.
gen NN2=.
gen NN3=.
mahapick (Alg1_MetExceed ELA10_MetExceed), idvar(ID) treated(PF) pickids(NN1 NN2 NN3) genfile(NN_MD) nummatches(3) replace

*merge in NN_MD
merge 1:m ID using "D:\PeerForward_Match3to1_17_18\NN_MD.dta"
keep if _merge==3
tab PF
rename _prime_id PF_SchoolId
rename _matchnum NN
label define nn 0"PF matched school" 1"1st Nearest Neighbor" 2"2nd Nearest Neighbor" 3"3rd Nearest Neighbor"
label value NN nn
sort PF_SchoolId NN
save "D:\PeerForward_Match3to1_17_18\MD_NN_simple.dta",replace
*Export to Excel
export excel using "D:\PeerForward_Match3to1_17_18\MD_matchedSimple.xls", firstrow(variables) replace
local cov "PriorAcadAch Alg1_MetExceed ELA10_MetExceed BlackHisp Seniors17"
foreach x of local cov{
mixed `x' PF||PF_SchoolId:
}

*NN match for only those with Prior Academic Achievement below +1SD above the average
use "D:\peerforward\MDwork.dta",clear
gen Alg1_MetExceed= 1-[(Level1ctAlg1/TestedCountAlg1)+(Level2ctAlg1/TestedCountAlg1)+(Level3ctAlg1/TestedCountAlg1)]
gen ELA10_MetExceed= 1- [(Level1ctELA10/TestedCountELA10)+ (Level2ctELA10/TestedCountELA10)+(Level3ctELA10/TestedCountELA10)]
egen Pull=rowmean(Alg1_MetExceed ELA10_MetExceed)
egen PriorAcadAch=std(Pull)
drop if PriorAcadAch>1
gen BlackHisp=BLBlack + HIHispanic
duplicates tag SchoolNumber, generate(dupe)
duplicates drop SchoolNumber, force
drop if PF==.
gen ID=_n
keep PF Seniors17 ID SchoolNumber LEAName City SchoolSchoolNumber Alg1_MetExceed ELA10_MetExceed PriorAcadAch BlackHisp
recast float SchoolNumber
gen NN1=.
gen NN2=.
gen NN3=.
mahapick (PriorAcadAch BlackHisp Seniors17), idvar(ID) treated(PF) pickids(NN1 NN2 NN3) genfile(NN_MD) replace nummatches(3)

*merge in NN_MD
merge 1:m ID using "D:\PeerForward_Match3to1_17_18\NN_MD.dta"
keep if _merge==3
tab PF
rename _prime_id PF_SchoolId
rename _matchnum NN
label define nn 0"PF matched school" 1"1st Nearest Neighbor" 2"2nd Nearest Neighbor" 3"3rd Nearest Neighbor"
label value NN nn
sort PF_SchoolId NN
save "D:\PeerForward_Match3to1_17_18\MD_NN_simple.dta",replace
*Export to Excel
export excel using "D:\PeerForward_Match3to1_17_18\MD_matchedSimple.xls", firstrow(variables) replace

*Multilevel model: are these schools significantly different on outcomes; did matching work well
local cov "PriorAcadAch Alg1_MetExceed ELA10_MetExceed BlackHisp Seniors17"
foreach x of local cov{
mixed `x' PF||PF_SchoolId:
}


*NN match for only those with Prior Academic Achievement above in range of PF -1.25<Ach<2.6
use "D:\peerforward\MDwork.dta",clear
gen Alg1_MetExceed= 1-[(Level1ctAlg1/TestedCountAlg1)+(Level2ctAlg1/TestedCountAlg1)+(Level3ctAlg1/TestedCountAlg1)]
gen ELA10_MetExceed= 1- [(Level1ctELA10/TestedCountELA10)+ (Level2ctELA10/TestedCountELA)+(Level3ctELA10/TestedCountELA10)]
egen Pull=rowmean(Alg1_MetExceed ELA10_MetExceed)
egen PriorAcadAch=std(Pull)
drop if PriorAcadAch<-1.25 
drop if PriorAcadAch>2.6
gen BlackHisp=BLBlack + HIHispanic
duplicates tag SchoolNumber, generate(dupe)
duplicates drop SchoolNumber, force
drop if PF==.
gen ID=_n
keep PF Seniors17 ID SchoolNumber LEAName City SchoolSchoolNumber Alg1_MetExceed ELA10_MetExceed PriorAcadAch BlackHisp
recast float SchoolNumber
gen NN1=.
gen NN2=.
gen NN3=.
mahapick (PriorAcadAch BlackHisp Seniors17), idvar(ID) treated(PF) pickids(NN1 NN2 NN3) genfile(NN_MD) replace nummatches(3)

*merge in NN_MD
merge 1:m ID using "D:\PeerForward_Match3to1_17_18\NN_MD.dta"
keep if _merge==3
tab PF
rename _prime_id PF_SchoolId
rename _matchnum NN
label define nn 0"PF matched school" 1"1st Nearest Neighbor" 2"2nd Nearest Neighbor" 3"3rd Nearest Neighbor"
label value NN nn
sort PF_SchoolId NN
save "D:\PeerForward_Match3to1_17_18\MD_NN_simple.dta",replace
*Export to Excel
export excel using "D:\PeerForward_Match3to1_17_18\MD_matchedSimple.xls", firstrow(variables) replace

*Multilevel model: are these schools significantly different on outcomes; did matching work well
local cov "PriorAcadAch Alg1_MetExceed ELA10_MetExceed BlackHisp Seniors17"
foreach x of local cov{
mixed `x' PF||PF_SchoolId:
}

*NN match for only those with Prior Academic Achievement above -1SD below the average
use "D:\peerforward\MDwork.dta",clear
gen Alg1_MetExceed= 1-[(Level1ctAlg1/TestedCountAlg1)+(Level2ctAlg1/TestedCountAlg1)+(Level3ctAlg1/TestedCountAlg1)]
gen ELA10_MetExceed= 1- [(Level1ctELA10/TestedCountELA10)+ (Level2ctELA10/TestedCountELA)+(Level3ctELA10/TestedCountELA10)]
egen Pull=rowmean(Alg1_MetExceed ELA10_MetExceed)
egen PriorAcadAch=std(Pull)
drop if PriorAcadAch<-1
gen BlackHisp=BLBlack + HIHispanic
duplicates tag SchoolNumber, generate(dupe)
duplicates drop SchoolNumber, force
drop if PF==.
gen ID=_n
keep PF Seniors17 ID SchoolNumber LEAName City SchoolSchoolNumber Alg1_MetExceed ELA10_MetExceed PriorAcadAch BlackHisp
recast float SchoolNumber
gen NN1=.
gen NN2=.
gen NN3=.
mahapick (PriorAcadAch BlackHisp Seniors17), idvar(ID) treated(PF) pickids(NN1 NN2 NN3) genfile(NN_MD) replace nummatches(3)

*merge in NN_MD
merge 1:m ID using "D:\PeerForward_Match3to1_17_18\NN_MD.dta"
keep if _merge==3
tab PF
rename _prime_id PF_SchoolId
rename _matchnum NN
label define nn 0"PF matched school" 1"1st Nearest Neighbor" 2"2nd Nearest Neighbor" 3"3rd Nearest Neighbor"
label value NN nn
sort PF_SchoolId NN
save "D:\PeerForward_Match3to1_17_18\MD_NN_simple.dta",replace
*Export to Excel
export excel using "D:\PeerForward_Match3to1_17_18\MD_matchedSimple.xls", firstrow(variables) replace

*Multilevel model: are these schools significantly different on outcomes; did matching work well
local cov "PriorAcadAch Alg1_MetExceed ELA10_MetExceed BlackHisp Seniors17"
foreach x of local cov{
mixed `x' PF||PF_SchoolId:
}

