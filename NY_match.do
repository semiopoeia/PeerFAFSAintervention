*using NYwork
use "C:\Users\pws5\Documents\peerforward\NYwork.dta"  ,clear
egen TotalRace=rowtotal(AmericanIndianAlaskaNative_Race_ AsianPacificIslander_Race_2017 Black_Race_2017 Hispanic_Race_2017 Multiracial_Race_2017 White_Race_2017)
gen PctBlackHisp=(Black_Race_2017+Hispanic_Race_2017)/TotalRace
egen TotalSES=rowtotal(EconomicallyDisadvantaged_2017 NotEconomicallyDisadvantaged_201)
gen PctEconDisadv=EconomicallyDisadvantaged_2017/TotalSES 
egen Pull=rowmean(PI_G_RATE_ELA_2015 PI_G_RATE_Math_2015)
egen PriorAcadAch=std(Pull)


keep COUNTY DISTRICTNAME STATELOCATIONID City LOCATIONNAME PF PriorAcadAch PctEconDisadv PctBlackHisp GRADE12_2017
egen ID=group(STATELOCATIONID)
gen NN1=.
gen NN2=.
gen NN3=.
recast float ID
drop if PF==.
mahapick (PriorAcadAch PctEconDisadv PctBlackHisp GRADE12_2017), idvar(ID) treated(PF) pickids(NN1 NN2 NN3) genfile(NN_NY) nummatches(3) 
save "F:\PeerForward_Match3to1_17_18\NY_toMatch.dta",replace

*merge in NN_FL
merge 1:m ID using "C:\Users\pws5\Documents\peerforward\NN_NY.dta"
keep if _merge==3
tab PF
rename _prime_id PF_SchoolId
rename _matchnum NN
label define nn 0"PF matched school" 1"1st Nearest Neighbor" 2"2nd Nearest Neighbor" 3"3rd Nearest Neighbor"
label value NN nn
sort PF_SchoolId NN
save "F:\PeerForward_Match3to1_17_18\NY_NN_simple.dta",replace
*Export to Excel
export excel using "F:\PeerForward_Match3to1_17_18\NY_matchedSimple.xls", firstrow(variables) replace

*Multilevel model: are these schools significantly different on outcomes; did matching work well
local cov "PriorAcadAch PctEconDisadv PctBlackHisp GRADE12_2017"
foreach x of local cov{
mixed `x' PF||PF_SchoolId:
}
