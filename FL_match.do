*using FL_work
use "F:\PeerForward_Match3to1_17_18\FL_work.dta" ,clear
egen Pull=rowmean(EnglishLanguageArtsAchievemen MathematicsAchievement_2016)
egen PriorAcadAch=std(Pull)
rename PercentofMinorityStudents_201 PctMinority
rename PercentofEconomicallyDisadvan PctEconDisadv

keep DISTRICTNAME CITY SCHOOLNAME PF Grade_12_2017 PctMinority PctEconDisadv ID PriorAcadAch
gen NN1=.
gen NN2=.
gen NN3=.
recast float ID
drop if PF==.
mahapick (Grade_12_2017 PctMinority PctEconDisadv PriorAcadAch), idvar(ID) treated(PF) pickids(NN1 NN2 NN3) genfile(NN_FL) nummatches(3) 
save "F:\PeerForward_Match3to1_17_18\FL_toMatch.dta",replace

*merge in NN_FL
merge 1:m ID using "F:\PeerForward_Match3to1_17_18\NN_FL.dta"
keep if _merge==3
tab PF
rename _prime_id PF_SchoolId
rename _matchnum NN
label define nn 0"PF matched school" 1"1st Nearest Neighbor" 2"2nd Nearest Neighbor" 3"3rd Nearest Neighbor"
label value NN nn
sort PF_SchoolId NN
save "F:\PeerForward_Match3to1_17_18\FL_NN_simple.dta",replace
*Export to Excel
export excel using "F:\PeerForward_Match3to1_17_18\FL_matchedSimple.xls", firstrow(variables) replace

*Multilevel model: are these schools significantly different on outcomes; did matching work well
local cov "Grade_12_2017 PctMinority PctEconDisadv PriorAcadAch"
foreach x of local cov{
mixed `x' PF||PF_SchoolId:
}
