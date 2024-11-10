*Step 1: create demographic variables
use "D:\peerforward\CA.dta",clear
drop Pull PriorAcadAch PctEconDisadv PctHispBlack ID
egen TotalRace=rowtotal(HispanicorLatino_2017 AmericanIndianorAlaskaNative AsianNotHispanic_2017 PacificIslanderNotHispanic_2 FilipinoNotHispanic_2017 AfricanAmericanNotHispanic_2 WhiteNotHispanic_2017 TwoorMoreRacesNotHispanic_ NotReported_race_2017)
egen Pull=rowmean(SCI_Y3_2016 SSCI_Y2_2015 ELA_Y1_2015 MATH_Y1_2015)
egen PriorAcadAch=std(Pull)
gen PctEconDisadv=FreeMealCountK12_2017 /EnrollmentK12_2017
gen PctHispBlack=(HispanicorLatino_2017+AfricanAmericanNotHispanic_2)/TotalRace
replace PctEconDisadv=1 if PctEconDisadv>1
drop if PF==.
drop if PctHispBlack==.
drop if PctEconDisadv==.
drop if PriorAcadAch==.
drop if SumofGR_12_2017==.
egen ID=group(SCHOOLNAME CITY)
**unfortunately misreporting leads to percentages over 100%
**bounding at max
*Step 2: find nearest neighbors
gen NN1=.
gen NN2=.
gen NN3=.

mahapick ( PriorAcadAch PctEconDisadv PctHispBlack SumofGR_12_2017), idvar(ID) treated(PF) pickids(NN1 NN2 NN3) genfile(NN_CA) nummatches(3) replace


*Step 3: simplify dataset
*merge file
merge 1:m ID using "D:\PeerForward_Match3to1_17_18\NN_CA.dta
keep if _merge==3
tab PF
rename _prime_id PF_SchoolId
rename _matchnum NN
label define nn 0"PF matched school" 1"1st Nearest Neighbor" 2"2nd Nearest Neighbor" 3"3rd Nearest Neighbor"
label value NN nn
sort PF_SchoolId NN
save "D:\PeerForward_Match3to1_17_18\CA_NN_simple.dta",replace
*Export to Excel
export excel using "D:\PeerForward_Match3to1_17_18\CA_matched.xls", firstrow(variables) replace

*Multilevel model: are these schools significantly different on outcomes; did matching work well
local cov " PriorAcadAch PctEconDisadv PctHispBlack SumofGR_12_2017"
foreach x of local cov{
mixed `x' PF||PF_SchoolId:
}
