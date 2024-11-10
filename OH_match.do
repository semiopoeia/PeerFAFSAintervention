*using OH_work
use "D:\peerforward\OH_work.dta" ,clear
gen TotalEnroll=student_female_2017+student_male_2017
gen PercBlackHispMulti=(student_black_2017+student_latino_2017+student_multi_2017)/TotalEnroll
gen PercEconDisadv=student_EconDis_2017/TotalEnroll
rename PERFORMANCEINDEXSCOREGRADE PriorAcadAch
rename rpting_bldg_irn ID

keep dist_name SchoolName CITY county dist_name SchoolName CITY county ID PF grade_12_2017 PriorAcadAch PercBlackHispMulti PercEconDisadv
gen NN1=.
gen NN2=.
gen NN3=.
recast float ID
drop if PF==.
mahapick (grade_12_2017 PriorAcadAch PercBlackHispMulti PercEconDisadv), idvar(ID) treated(PF) pickids(NN1 NN2 NN3) genfile(NN_OH) replace nummatches(3) nocovtrlimitation
save "D:\PeerForward_Match3to1_17_18\OH_toMatch.dta",replace
use "D:\peerforward\NN_OH.dta" ,clear
save "D:\PeerForward_Match3to1_17_18\NN_OH.dta",replace
use "D:\PeerForward_Match3to1_17_18\OH_toMatch.dta",clear

*merge in NN_OH
merge 1:m ID using "D:\PeerForward_Match3to1_17_18\NN_OH.dta"
keep if _merge==3
tab PF
rename _prime_id PF_SchoolId
rename _matchnum NN
label define nn 0"PF matched school" 1"1st Nearest Neighbor" 2"2nd Nearest Neighbor" 3"3rd Nearest Neighbor"
label value NN nn
sort PF_SchoolId NN
save "D:\PeerForward_Match3to1_17_18\OH_NN_simple.dta",replace
*Export to Excel
export excel using "D:\PeerForward_Match3to1_17_18\OH_matchedSimple.xls", firstrow(variables) replace

*Multilevel model: are these schools significantly different on outcomes; did matching work well
local cov "grade_12_2017 PercBlackHispMulti PercEconDisadv"
foreach x of local cov{
mixed `x' PF||PF_SchoolId:
}
