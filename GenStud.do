/*making generalizable study dataset: identify in and out sample, matching by name may be easiest*/

*CA
**got the names from the dataset to be appended and analyzed, but then apply to full dataset
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_full.dta", clear
gen InOutSample= "1" if ///
					BuildingName =="Cesar E. Chavez Learning Academies-Academy of Scie" | ///
					BuildingName =="Los Angeles Senior High" | ///
					BuildingName =="George Washington Preparatory High" | ///
					BuildingName =="Crenshaw Science, Technology, Engineering, Math an" | ///
					BuildingName =="Susan Miller Dorsey Senior High" | ///
					BuildingName =="Centennial High" | ///
					BuildingName =="San Juan High" | ///
					BuildingName =="School of History and Dramatic Arts at Sonia Sotom" | ///
					BuildingName =="Helen Bernstein High" | ///
					BuildingName =="Emery Secondary" | ///
					BuildingName =="John Muir High" | ///
					BuildingName =="Thomas Jefferson Senior High" | ///
					BuildingName =="San Diego Business/Leadership" | ///
					BuildingName =="WESM Health/Sports Medicine" | ///
					BuildingName =="Communication and Technology at Diego Rivera Learn" | ///
					BuildingName =="Contreras Learning Center-Academic Leadership Comm" | ///
					BuildingName =="Sun Valley High" | ///
					BuildingName =="Dr. Maya Angelou Community High" | ///
					BuildingName =="Science, Technology, Engineering, Arts and Mathema" | ///
					BuildingName =="Canoga Park Senior High" | ///
					BuildingName =="Manual Arts Senior High" | ///
					BuildingName =="David Starr Jordan Senior High" | ///
					BuildingName =="East Valley Senior High" | ///
					BuildingName =="Green Design at Diego Rivera Learning Complex" | ///
					BuildingName =="Santee Education Complex" | ///
					BuildingName =="Augustus F. Hawkins High A Critical Design and Gam" | ///
					BuildingName =="Sylmar Charter High" | ///
					BuildingName =="Public Service Community at Diego Rivera Learning"

destring InOutSample, replace
replace InOutSample=0 if InOutSample==.
duplicates drop BuildingName, force
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_4gen.dta",replace
********CALIFORNIA*************
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_4gen.dta",clear
label define sample 0"Out-Sample" 1"In-Sample"
label values InOutSample sample
label define treat 0"Non-PeerForward" 1"PeerForward"
label values Treatment treat
gen PriorFAFSA=FAFSA3_3_16/ SumofGR_12_2016
gen PctBlackHisp=( AfricanAmericanNotHispanic_2 + HispanicorLatino_2017 )/ EnrollmentK12_2017
gen PctFreeReduced=FRPMCountK12_2017/ EnrollmentK12_2017
gen AvgSAT=(AvgScrERW_SAT_2016+AvgScoreMath_SAT_2016)/2
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_4gen.dta",replace
/*local cov "PriorFAFSA PctBlackHisp PctFreeReduced SumofGR_12_2017 AvgSAT"
foreach x of local cov{
sum `x'
sort InOutSample
by InOutSample: sum `x'
sort Treatment
by Treatment: sum `x'
sort InOutSample Treatment
by InOutSample Treatment: sum `x'
*graph box `x', name(Full,replace) nodraw
*graph box `x', over(InOutSample) name(InOut,replace) nodraw 
*graph box `x', over(Treatment) name(Treatment, replace) nodraw
*graph box `x', over(InOutSample) over(Treatment) name(InOutTreat,replace) nodraw
*graph combine Full InOut Treatment InOutTreat, altshrink saving("C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA`x'groupings.gph",replace)
}*/
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_4gen.dta",replace

use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_4gen.dta",clear
**In vs Out full
local cov "PriorFAFSA PctBlackHisp PctFreeReduced SumofGR_12_2017 AvgSAT"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, nodots bca reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) nodots bca:esize twosample `x', by(InOutSample)
}
*compare Treat vs. Control full sample
local cov "PriorFAFSA PctBlackHisp PctFreeReduced SumofGR_12_2017 AvgSAT"
foreach x of local cov{
reg `x' Treatment, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), nodots bca reps(100) seed(213):esize twosample `x', by(Treatment)
}
*compare In vs Out for Treatment
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_4gen.dta",clear
keep if Treatment==1
local cov "PriorFAFSA PctBlackHisp PctFreeReduced SumofGR_12_2017 AvgSAT"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, nodots bca reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) nodots bca:esize twosample `x', by(InOutSample)
}
*compare In vs Out for controls
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_4gen.dta",clear
keep if Treatment==0
local cov "PriorFAFSA PctBlackHisp PctFreeReduced SumofGR_12_2017 AvgSAT"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca reps(100) nodots seed(213)) 
bootstrap r(d), reps(100) seed(213) nodots bca:esize twosample `x', by(InOutSample)
}

*FL
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_SetFull.dta",clear
gen InOutSample="1" if ID =="137151" | ///
ID =="137231" | ///
ID =="137251" | ///
ID =="137381" | ///
ID =="137541" | ///
ID =="137701" | ///
ID =="137731" | ///
ID =="502301" | ///
ID =="502361" | ///
ID =="50581" | ///
ID =="50691" | ///
ID =="6211"
destring InOutSample, replace
replace InOutSample=0 if InOutSample==.
duplicates drop ID, force
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_4gen.dta",replace
***FLORIDA***
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_4gen.dta",clear
label define sample 0"Out-Sample" 1"In-Sample"
label values InOutSample sample
label define treat 0"Non-PeerForward" 1"PeerForward"
label values Treatment treat
gen PriorFAFSA=FAFSA3_3_16/Grade_12_2016 if Grade_12_2016>0
rename PercentofMinorityStudents_201 PctMinority
rename PercentofEconomicallyDisadvan PctEconDisadv
rename PercentofTotalPossiblePoints PercTotalPoints
/*local cov "PriorFAFSA PctMinority PctEconDisadv Grade_12_2017 PercTotalPoints"
foreach x of local cov{
sum `x'
sort InOutSample
by InOutSample: sum `x'
sort Treatment
by Treatment: sum `x'
sort InOutSample Treatment
by InOutSample Treatment: sum `x'
*graph box `x', name(Full,replace) nodraw
*graph box `x', over(InOutSample) name(InOut,replace) nodraw 
*graph box `x', over(Treatment) name(Treatment, replace) nodraw
*graph box `x', over(InOutSample) over(Treatment) name(InOutTreat,replace) nodraw
*graph combine Full InOut Treatment InOutTreat, altshrink saving("C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL`x'groupings.gph", replace)
}*/
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_4gen.dta",replace

use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_4gen.dta",clear
**In vs Out full
local cov "PriorFAFSA PctMinority PctEconDisadv Grade_12_2017 PercTotalPoints"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, nodots bca reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}
*compare Treat vs. Control full sample
local cov "PriorFAFSA PctMinority PctEconDisadv Grade_12_2017 PercTotalPoints"
foreach x of local cov{
reg `x' Treatment, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) nodots bca:esize twosample `x', by(Treatment)
}
*compare In vs Out for Treatment
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_4gen.dta",clear
keep if Treatment==1
local cov "PriorFAFSA PctMinority PctEconDisadv Grade_12_2017 PercTotalPoints"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) nodots bca:esize twosample `x', by(InOutSample)
}
*compare In vs Out for controls
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_4gen.dta",clear
keep if Treatment==0
local cov "PriorFAFSA PctMinority PctEconDisadv Grade_12_2017 PercTotalPoints"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) nodots bca:esize twosample `x', by(InOutSample)
}

*MD
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_merged.dta", replace
gen InOutSample="1" if ID=="161502" | ///
ID=="161806" | ///
ID=="16908" | ///
ID=="21301" | ///
ID=="221307" | ///
ID=="22513"
destring InOutSample, replace
replace InOutSample=0 if InOutSample==.
duplicates drop ID, force
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_4gen.dta",replace
***MARYLAND***
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_4gen.dta",clear
label define sample 0"Out-Sample" 1"In-Sample"
label values InOutSample sample
label define treat 0"Non-PeerForward" 1"PeerForward"
label values Treatment treat
rename O Seniors17
rename Seniors Seniors16
gen PriorFAFSA=FAFSA3_3_16/Seniors16 if Seniors16>0
gen PctBlackHisp=(BL+HI)/Member
gen PctFreeReduced=TOTFRL/Member
gen PriorAch=(Level3pctELA10+Level3pctAlg1)/2
/*local cov "PriorFAFSA PctBlackHisp PctFreeReduced Seniors17 PriorAch"
foreach x of local cov{
sum `x'
sort InOutSample
by InOutSample: sum `x'
sort Treatment
by Treatment: sum `x'
sort InOutSample Treatment
by InOutSample Treatment: sum `x'
*graph box `x', name(Full,replace) nodraw
*graph box `x', over(InOutSample) name(InOut,replace) nodraw 
*graph box `x', over(Treatment) name(Treatment, replace) nodraw
*graph box `x', over(InOutSample) over(Treatment) name(InOutTreat,replace) nodraw
*graph combine Full InOut Treatment InOutTreat, altshrink saving("C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD`x'groupings.gph", replace)
}*/
drop _merge
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_4gen.dta",replace

use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_4gen.dta",clear
**In vs Out full
local cov "PriorFAFSA PctBlackHisp PctFreeReduced Seniors17 PriorAch"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca reps(100) seed(213) nodots) 
bootstrap r(d), reps(100) seed(213) nodots bca:esize twosample `x', by(InOutSample)
}
*compare Treat vs. Control full sample
local cov "PriorFAFSA PctBlackHisp PctFreeReduced Seniors17 PriorAch"
foreach x of local cov{
reg `x' Treatment, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) nodots bca:esize twosample `x', by(Treatment)
}
*compare In vs Out for Treatment
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_4gen.dta",clear
keep if Treatment==1
local cov "PriorFAFSA PctBlackHisp PctFreeReduced Seniors17 PriorAch"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}
*compare In vs Out for controls
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_4gen.dta",clear
keep if Treatment==0
local cov "PriorFAFSA PctBlackHisp PctFreeReduced Seniors17 PriorAch"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}

*MI
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MIfull1.dta",clear
tostring Unique_ID,gen(ID)
gen InOutSample="1" if ID=="4251" | ///
ID=="1864" | ///
ID=="2314" | ///
ID=="6428" | ///
ID=="8884" | ///
ID=="398" | ///
ID=="1380" | ///
ID=="405" | ///
ID=="1554" | ///
ID=="8636" | ///
ID=="731" | ///
ID=="2008" | ///
ID=="35" | ///
ID=="9604" | ///
ID=="1214" | ///
ID=="306" | ///
ID=="1925" | ///
ID=="2736"
destring InOutSample, replace
replace InOutSample=0 if InOutSample==.
duplicates drop ID, force
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MI_4gen.dta",replace
***MICHIGAN***
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MI_4gen.dta",clear
label define sample 0"Out-Sample" 1"In-Sample"
label values InOutSample sample
label define treat 0"Non-PeerForward" 1"PeerForward"
label values Treatment treat
gen PriorFAFSA=FAFSA3_3_16/Grade_12_ENROLLMENT_2016 if Grade_12_ENROLLMENT_2016>0
replace PriorFAFSA=. if PriorFAFSA>1
gen PctBlackHisp=(AFRICAN_AMERICAN_ENROLLMENT_2017+HISPANIC_ENROLLMENT_2017)/TOTAL_ENROLLMENT_2017
gen PctEconDisAdv=ECONOMIC_DISADVANTAGED_ENROLLMEN/TOTAL_ENROLLMENT_2017
/*local cov "PriorFAFSA PctBlackHisp PctEconDisAdv GRADE_12_ENROLLMENT_2017 MathScoreAverage_2016"
foreach x of local cov{
sum `x'
sort InOutSample
by InOutSample: sum `x'
sort Treatment
by Treatment: sum `x'
sort InOutSample Treatment
by InOutSample Treatment: sum `x'
*graph box `x', name(Full,replace) nodraw
*graph box `x', over(InOutSample) name(InOut,replace) nodraw 
*graph box `x', over(Treatment) name(Treatment, replace) nodraw
*graph box `x', over(InOutSample) over(Treatment) name(InOutTreat,replace) nodraw
*graph combine Full InOut Treatment InOutTreat, altshrink saving("C:\Users\scottpw\Desktop\Consults\CollegeSummit\MI`x'groupings.gph", replace)
}*/
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MI_4gen.dta",replace

use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MI_4gen.dta",clear
**In vs Out full
local cov "PriorFAFSA PctBlackHisp PctEconDisAdv GRADE_12_ENROLLMENT_2017 MathScoreAverage_2016"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}
*compare Treat vs. Control full sample
local cov "PriorFAFSA PctBlackHisp PctEconDisAdv GRADE_12_ENROLLMENT_2017 MathScoreAverage_2016"
foreach x of local cov{
reg `x' Treatment, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(Treatment)
}
*all treatment in-sample

*compare In vs Out for controls
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MI_4gen.dta",clear
keep if Treatment==0
local cov "PriorFAFSA PctBlackHisp PctEconDisAdv GRADE_12_ENROLLMENT_2017 MathScoreAverage_2016"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}

*MO
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MO_masterSet.dta", clear
tostring ID, replace
gen InOutSample="1" if ID=="203" | ///
ID=="204" | ///
ID=="406" | ///
ID=="411" | ///
ID=="433" | ///
ID=="435" 
destring InOutSample, replace
replace InOutSample=0 if InOutSample==.
duplicates drop ID, force
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MO_4gen.dta",replace
***MISSOURI***
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MO_4gen.dta",clear
label define sample 0"Out-Sample" 1"In-Sample"
label values InOutSample sample
label define treat 0"Non-PeerForward" 1"PeerForward"
label values Treatment treat
destring ENROLLMENT_BLACK_PCT ENROLLMENT_HISPANIC_PCT, replace force
destring FAFSA3_3_16, force replace
destring ACT_COMPOSITE_SCORE_2016, force replace
gen PriorFAFSA=FAFSA3_3_16/ENROLLMENT_GRADES_12_2016 if ENROLLMENT_GRADES_12_2016>0
gen PctBlackHisp=ENROLLMENT_BLACK_PCT+ENROLLMENT_HISPANIC_PCT
destring LUNCH_COUNT_FREE_REDUCTED_PCT, force replace
rename LUNCH_COUNT_FREE_REDUCTED_PCT PctFreeReduced
/*local cov "PriorFAFSA PctBlackHisp PctFreeReduced ENROLLMENT_GRADES_12_2017 ACT_COMPOSITE_SCORE_2016"
foreach x of local cov{
sum `x'
sort InOutSample
by InOutSample: sum `x'
sort Treatment
by Treatment: sum `x'
sort InOutSample Treatment
by InOutSample Treatment: sum `x'
graph box `x', name(Full,replace) nodraw
graph box `x', over(InOutSample) name(InOut,replace) nodraw 
graph box `x', over(Treatment) name(Treatment, replace) nodraw
graph box `x', over(InOutSample) over(Treatment) name(InOutTreat,replace) nodraw
graph combine Full InOut Treatment InOutTreat, altshrink saving("C:\Users\scottpw\Desktop\Consults\CollegeSummit\MO`x'groupings.gph", replace)
}*/
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MO_4gen.dta",replace

use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MO_4gen.dta",clear
**In vs Out full
local cov "PriorFAFSA PctBlackHisp PctFreeReduced ENROLLMENT_GRADES_12_2017 ACT_COMPOSITE_SCORE_2016"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}
*compare Treat vs. Control full sample (*%Free/Reduced doesn't resolve)
local cov "PriorFAFSA PctBlackHisp PctFreeReduced ENROLLMENT_GRADES_12_2017 ACT_COMPOSITE_SCORE_2016"
foreach x of local cov{
reg `x' Treatment, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(Treatment)
}

/*compare In vs Out for Treatment (too few for estimation)
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MO_4gen.dta",clear
keep if Treatment==1
local cov "PriorFAFSA PctBlackHisp PctFreeReduced ENROLLMENT_GRADES_12_2017 ACT_COMPOSITE_SCORE_2016"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}*/
*compare In vs Out for controls
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MO_4gen.dta",clear
keep if Treatment==0
local cov "PriorFAFSA PctBlackHisp PctFreeReduced ENROLLMENT_GRADES_12_2017 ACT_COMPOSITE_SCORE_2016"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}

*NY
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_full_altSet.dta" ,clear
gen InOutSample="1" if LOCATIONNAME=="DEPOSIT MIDDLE-SENIOR HIGH SCHOOL" | ///
LOCATIONNAME=="MCKINLEY VOC HIGH SCHOOL" | ///
LOCATIONNAME=="MATH SCIENCE TECH PREP SCHOOL-SENECA" | ///
LOCATIONNAME=="BUFFALO ACADEMY-VIS & PERF ARTS" | ///
LOCATIONNAME=="EMERSON SCHOOL OF HOSPITALITY" | ///
LOCATIONNAME=="TAPESTRY CHARTER SCHOOL" | ///
LOCATIONNAME=="BUFFALO ACAD-SCI CHARTER SCHOOL" | ///
LOCATIONNAME=="ORACLE CHARTER SCHOOL" | ///
LOCATIONNAME=="HEALTH SCIENCES CHARTER SCHOOL" | ///
LOCATIONNAME=="LAKE SHORE SENIOR HIGH SCHOOL" | ///
LOCATIONNAME=="ELIZABETHTOWN-LEWIS CENTRAL SCHOOL" | ///
LOCATIONNAME=="SALMON RIVER HIGH SCHOOL" | ///
LOCATIONNAME=="SCHOOL 58-WORLD OF INQUIRY SCHOOL" | ///
LOCATIONNAME=="ROCHESTER ACADEMY CHARTER SCHOOL" | ///
LOCATIONNAME=="MALVERNE SENIOR HIGH SCHOOL" | ///
LOCATIONNAME=="MURRY BERGTRAUM HS FOR BUS CAR" | ///
LOCATIONNAME=="HIGH SCHOOL OF HOSPITALITY MGMNT" | ///
LOCATIONNAME=="HUDSON HS OF LEARNING TECHNOLOGIES" | ///
LOCATIONNAME=="AMERICAN SIGN LANG & ENG SECONDAR" | ///
LOCATIONNAME=="URBAN SCH-BUSINESS-YNG WOMEN" | ///
LOCATIONNAME=="LEADERSHIP & PUBLIC SERVICE HIGH SCH" | ///
LOCATIONNAME=="GLOBAL LEARNING COLLABORATIVE (THE)" | ///
LOCATIONNAME=="HS FOR LAW ADVCY & COMM JUST" | ///
LOCATIONNAME=="OPPORTUNITY CHARTER SCHOOL" | ///
LOCATIONNAME=="ACADEMY FOR SOCIAL ACTION" | ///
LOCATIONNAME=="THURGOOD MARSHALL ACAD FOR LEARNING" | ///
LOCATIONNAME=="WOMEN'S ACADEMY OF EXCELLENCE" | ///
LOCATIONNAME=="RENAISSANCE HIGH SCHOOL-MTT" | ///
LOCATIONNAME=="MILLENIUM ART ACADEMY" | ///
LOCATIONNAME=="BRONX EARLY COL ACAD-TEACH/LEARN" | ///
LOCATIONNAME=="MORRIS ACADEMY FOR COLLA STUDIES" | ///
LOCATIONNAME=="EAGLE ACADEMY FOR YOUNG MEN" | ///
LOCATIONNAME=="BRONX PREP CHARTER SCHOOL" | ///
LOCATIONNAME=="BRONX SCHOOL OF LAW & FINANCE" | ///
LOCATIONNAME=="BRONX THEATRE HIGH SCHOOL" | ///
LOCATIONNAME=="BRONX HEALTH SCIENCES HIGH SCHOOL" | ///
LOCATIONNAME=="GEORGE WESTINGHOUSE CAREER/TECH HS" | ///
LOCATIONNAME=="CITY POLYTECHNIC HIGH SCHOOL" | ///
LOCATIONNAME=="SCIENCE SKILLS CENTER HIGH SCHOOL" | ///
LOCATIONNAME=="DR SUSAN S MCKINNEY SEC SCH-ARTS" | ///
LOCATIONNAME=="BROOKLYN COMM HS-COMM, ARTS, MEDIA" | ///
LOCATIONNAME=="ACORN COMMUNITY HIGH SCHOOL" | ///
LOCATIONNAME=="URBAN ASSEMBLY INST OF MATH AND SCIE" | ///
LOCATIONNAME=="NORTHSIDE CHARTER HIGH SCHOOL" | ///
LOCATIONNAME=="BROOKLYN HIGH SCHOOL OF THE ARTS" | ///
LOCATIONNAME=="COBBLE HILL SCHOOL OF AMERICAN STUD" | ///
LOCATIONNAME=="PARK SLOPE COLLEGIATE" | ///
LOCATIONNAME=="BROOKLYN HIGH SCHOOL-LAW AND TECH" | ///
LOCATIONNAME=="HIGH SCHOOL-YOUTH & COMM DVLPMNT" | ///
LOCATIONNAME=="SCHOOL FOR DEMOCRACY & LDRSHP" | ///
LOCATIONNAME=="PATHWAYS TECH EARLY COLLEGE HIGH SCH" | ///
LOCATIONNAME=="HS FOR PUBLIC SERVICE-HEROES OF TOM" | ///
LOCATIONNAME=="ACAD FOR COLLEGE PREP AND CAREER EXP" | ///
LOCATIONNAME=="KURT HAHN EXPEDITIONARY LRNING SCH" | ///
LOCATIONNAME=="HIGH SCHOOL FOR MEDICAL PROFESSIONS" | ///
LOCATIONNAME=="URBAN ACTION ACADEMY" | ///
LOCATIONNAME=="VICTORY COLLEGIATE HIGH SCHOOL" | ///
LOCATIONNAME=="ACADEMY FOR YOUNG WRITERS" | ///
LOCATIONNAME=="ACADEMY OF INNOVATIVE TECHNOLOGY" | ///
LOCATIONNAME=="WORLD ACAD FOR TOTAL COM HEALTH" | ///
LOCATIONNAME=="SCH FOR CLASSICS: AN ACADEMY-TWP" | ///
LOCATIONNAME=="TRANSIT TECH CAREER AND TECH EDU" | ///
LOCATIONNAME=="LIFE ACAD HS FOR FILM AND MUSIC" | ///
LOCATIONNAME=="WILLIAM E GRADY CAREER AND TECH" | ///
LOCATIONNAME=="HIGH SCHOOL OF SPORTS MANAGEMENT" | ///
LOCATIONNAME=="EAGLE ACADEMY FOR YOUNG MEN II" | ///
LOCATIONNAME=="FLUSHING HIGH SCHOOL" | ///
LOCATIONNAME=="FREDERICK DOUGLASS ACAD VI HS" | ///
LOCATIONNAME=="AUGUST MARTIN HIGH SCHOOL" | ///
LOCATIONNAME=="CHANNEL VIEW SCHOOL FOR RESEARCH" | ///
LOCATIONNAME=="HS-LAW ENFORCMNT & PUB SAFETY" | ///
LOCATIONNAME=="YOUNG WOMEN'S LRDSHP SCH-QUEENS" | ///
LOCATIONNAME=="QUEENS COLLEGIATE" | ///
LOCATIONNAME=="FOREST HILLS HIGH SCHOOL" | ///
LOCATIONNAME=="EXCELSIOR PREP HIGH SCHOOL" | ///
LOCATIONNAME=="PREP ACADEMY FOR WRITERS" | ///
LOCATIONNAME=="GEORGE WASHINGTON CARVER HS" | ///
LOCATIONNAME=="PATHWAYS COLLEGE PREPARATORY SCHOOL" | ///
LOCATIONNAME=="HUMANITIES & ARTS MAGNET HS" | ///
LOCATIONNAME=="MATH/SCIENCE RESEARCH/TECH MAGNET" | ///
LOCATIONNAME=="EAGLE ACADEMY FOR YOUNG MEN III" | ///
LOCATIONNAME=="QUEENS PREP ACADEMY" | ///
LOCATIONNAME=="RENAISSANCE CHARTER SCHOOL" | ///
LOCATIONNAME=="SYRACUSE ACAD-SCI CHARTER SCH" | ///
LOCATIONNAME=="NORTH BABYLON HIGH SCHOOL" | ///
LOCATIONNAME=="WALTER G O'CONNELL COPIAGUE HIGH SCH" | ///
LOCATIONNAME=="AMITYVILLE MEMORIAL HIGH SCHOOL" | ///
LOCATIONNAME=="WYANDANCH MEMORIAL HIGH SCHOOL" | ///
LOCATIONNAME=="LIVINGSTON MANOR HIGH SCHOOL" | ///
LOCATIONNAME=="SPENCER-VAN ETTEN HIGH SCHOOL" | ///
LOCATIONNAME=="NEWFIELD SENIOR HIGH SCHOOL" 
destring InOutSample, replace
replace InOutSample=0 if InOutSample==.
duplicates drop LOCATIONNAME, force
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_4gen.dta",replace
***NEW YORK***
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_4gen.dta",clear
label define sample 0"Out-Sample" 1"In-Sample"
label values InOutSample sample
label define treat 0"Non-PeerForward" 1"PeerForward"
label values Treatment treat
gen PriorFAFSA=FAFSA3_3_16/GRADE12_2016
drop if PriorFAFSA>1
gen PctBlackHisp=(Black_Race_2017+Hispanic_Race_2017)/ GrandTotal_Race_2017
gen PctEconDisAdv=EconomicallyDisadvantaged_2017/GrandTotal_E_D_2017
gen PriorAch=(PI_G_RATE_Math_2015+ PI_G_RATE_ELA_2015)/2
/*local cov "PriorFAFSA PctBlackHisp PctEconDisAdv GRADE12_2017 PriorAch"
foreach x of local cov{
sum `x'
sort InOutSample
by InOutSample: sum `x'
sort Treatment
by Treatment: sum `x'
sort InOutSample Treatment
by InOutSample Treatment: sum `x'
graph box `x', name(Full,replace) nodraw
graph box `x', over(InOutSample) name(InOut,replace) nodraw 
graph box `x', over(Treatment) name(Treatment, replace) nodraw
graph box `x', over(InOutSample) over(Treatment) name(InOutTreat,replace) nodraw
graph combine Full InOut Treatment InOutTreat, altshrink saving("C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY`x'groupings.gph", replace)
}*/
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_4gen.dta",replace

use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_4gen.dta",clear
**In vs Out full
local cov "PriorFAFSA PctBlackHisp PctEconDisAdv GRADE12_2017 PriorAch"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}
*compare Treat vs. Control full sample
local cov "PriorFAFSA PctBlackHisp PctEconDisAdv GRADE12_2017 PriorAch"
foreach x of local cov{
reg `x' Treatment, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(Treatment)
}
*all treatment in-sample

*compare In vs Out for controls
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_4gen.dta",clear
keep if Treatment==0
local cov "PriorFAFSA PctBlackHisp PctEconDisAdv GRADE12_2017 PriorAch"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}

*OH
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_fullWname.dta",clear
gen InOutSample="1" if FAFSANAME=="Woodward Career Technical High School, Cincinnati" | ///
FAFSANAME=="Western Hills University High School, Cincinnati" | ///
FAFSANAME=="Start High School, Toledo" | ///
FAFSANAME=="South High School, Columbus" | ///
FAFSANAME=="Shaw High School, East Cleveland" | ///
FAFSANAME=="Robert A. Taft Information Technology  High School, Cincinnati" | ///
FAFSANAME=="John Adams High School, Cleveland" | ///
FAFSANAME=="Jesup W. Scott High School, Toledo" | ///
FAFSANAME=="Hughes STEM High School, Cincinnati" | ///
FAFSANAME=="Gilbert A. Dater High School, Cincinnati" | ///
FAFSANAME=="East High School, Youngstown" | ///
FAFSANAME=="East Community Learning Center, Akron" | ///
FAFSANAME=="Aiken High School, Cincinnati" 
destring InOutSample, replace
replace InOutSample=0 if InOutSample==.
duplicates drop FAFSANAME, force
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_4gen.dta",replace
***OHIO***
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_4gen.dta",clear
label define sample 0"Out-Sample" 1"In-Sample"
label values InOutSample sample
label define treat 0"Non-PeerForward" 1"PeerForward"
label values Treatment treat
replace FAFSA3_3_16= "5" if FAFSA3_3_16=="<5"
replace grade_12_2016="10" if grade_12_2016=="<10"
replace grade_12_2017="10" if grade_12_2017=="<10"
destring FAFSA3_3_16 grade_12_2016 grade_12_2017, force replace
gen PriorFAFSA=FAFSA3_3_16/grade_12_2016
drop if PriorFAFSA>1
local studcnt "student_w_disability_2017 student_asian_2017 student_black_2017 student_white_2017 student_NativeAm_2017 student_multi_2017 student_latino_2017 student_EconDis_2017 student_female_2017 student_male_2017"
foreach x of local studcnt{
replace `x'="10" if `x'=="<10"
}
destring `studcnt', force replace
gen PctBlackHisp=(student_black_2017+student_latino_2017)/ Total_Students_2017
replace PctBlackHisp=1 if PctBlackHisp>1
gen PctEconDisAdv=student_EconDis_2017/Total_Students_2017
replace PERFORMANCEINDEXSCOREGRADE_20="0" if PERFORMANCEINDEXSCOREGRADE_20=="F"
replace PERFORMANCEINDEXSCOREGRADE_20="1" if PERFORMANCEINDEXSCOREGRADE_20=="D"
replace PERFORMANCEINDEXSCOREGRADE_20="2" if PERFORMANCEINDEXSCOREGRADE_20=="C"
replace PERFORMANCEINDEXSCOREGRADE_20="3" if PERFORMANCEINDEXSCOREGRADE_20=="B"
replace PERFORMANCEINDEXSCOREGRADE_20="4" if PERFORMANCEINDEXSCOREGRADE_20=="A"
destring PERFORMANCEINDEXSCOREGRADE_20,force replace
gen PerfIndGrade=PERFORMANCEINDEXSCOREGRADE_20
/*local cov "PriorFAFSA PctBlackHisp PctEconDisAdv grade_12_2017 PerfIndGrade"
foreach x of local cov{
sum `x'
sort InOutSample
by InOutSample: sum `x'
sort Treatment
by Treatment: sum `x'
sort InOutSample Treatment
by InOutSample Treatment: sum `x'
*graph box `x', name(Full,replace) nodraw
*graph box `x', over(InOutSample) name(InOut,replace) nodraw 
*graph box `x', over(Treatment) name(Treatment, replace) nodraw
*graph box `x', over(InOutSample) over(Treatment) name(InOutTreat,replace) nodraw
*graph combine Full InOut Treatment InOutTreat, altshrink saving("C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH`x'groupings.gph", replace)
}*/
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_4gen.dta",replace

use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_4gen.dta",clear
**In vs Out full
local cov "PriorFAFSA PctBlackHisp PctEconDisAdv grade_12_2017 PerfIndGrade"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(1000) seed(213)) 
bootstrap r(d), reps(1000) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}
*compare Treat vs. Control full sample
local cov "PriorFAFSA PctBlackHisp PctEconDisAdv grade_12_2017 PerfIndGrade"
foreach x of local cov{
reg `x' Treatment, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(Treatment)
}
*all treatment in-sample

*compare In vs Out for controls
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_4gen.dta",clear
keep if Treatment==0
local cov "PriorFAFSA PctBlackHisp PctEconDisAdv grade_12_2017 PerfIndGrade"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}

*SC
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SCdata.dta",clear
gen InOutSample="1" if ID=="801002" | ///
ID=="4701004" | ///
ID=="3301001" | ///
ID=="801043" | ///
ID=="3804054" | ///
ID=="3805028" | ///
ID=="1101003" | ///
ID=="2301005" | ///
ID=="3205039" | ///
ID=="701004" | ///
ID=="1201002" | ///
ID=="3410008" | ///
ID=="4501012" | ///
ID=="3202011" | ///
ID=="1001002" | ///
ID=="2104041" | ///
ID=="2201026" | ///
ID=="2103029" | ///
ID=="2451020" | ///
ID=="2301613" | ///
ID=="4001005" | ///
ID=="4001004" | ///
ID=="4001013" | ///
ID=="4001007"
destring InOutSample, replace
replace InOutSample=0 if InOutSample==.
duplicates drop ID, force
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_4gen.dta",replace
**SOUTH CAROLINA***
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_4gen.dta",clear
label define sample 0"Out-Sample" 1"In-Sample"
label values InOutSample sample
label define treat 0"Non-PeerForward" 1"PeerForward"
label values Treatment treat
replace FAFSA_12_30_16= "5" if FAFSA_12_30_16=="<5"
destring FAFSA_12_30_16, replace force
gen PriorFAFSA=FAFSA_12_30_16/G_12_2016 if G_12_2016>0
gen PctBlackHisp=(Black_2017+ Hisp_2017)/ Total_enrolled_2017
drop if A16_ComAvg<0
/*local cov "PriorFAFSA PctBlackHisp POVERTY G_12_2017 A16_ComAvg"
foreach x of local cov{
sum `x'
sort InOutSample
by InOutSample: sum `x'
sort Treatment
by Treatment: sum `x'
sort InOutSample Treatment
by InOutSample Treatment: sum `x'
*graph box `x', name(Full,replace) nodraw
graph box `x', over(InOutSample) name(InOut,replace) nodraw 
graph box `x', over(Treatment) name(Treatment, replace) nodraw
graph box `x', over(InOutSample) over(Treatment) name(InOutTreat,replace) nodraw
graph combine Full InOut Treatment InOutTreat, altshrink saving("C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC`x'groupings.gph", replace)
}*/
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_4gen.dta",replace

use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_4gen.dta",clear
**In vs Out full
local cov "PriorFAFSA PctBlackHisp POVERTY G_12_2017 A16_ComAvg"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}
*compare Treat vs. Control full sample
local cov "PriorFAFSA PctBlackHisp POVERTY G_12_2017 A16_ComAvg"
foreach x of local cov{
reg `x' Treatment, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(Treatment)
}
*compare In vs Out for Treatment
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_4gen.dta",clear
keep if Treatment==1
local cov "PriorFAFSA PctBlackHisp POVERTY G_12_2017 A16_ComAvg"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}
*compare In vs Out for controls
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_4gen.dta",clear
keep if Treatment==0
local cov "PriorFAFSA PctBlackHisp POVERTY G_12_2017 A16_ComAvg"
foreach x of local cov{
reg `x' InOutSample, vce(bootstrap, bca nodots reps(100) seed(213)) 
bootstrap r(d), reps(100) seed(213) bca nodots:esize twosample `x', by(InOutSample)
}

/* **Labeling Script**
label define sample 0"Out-Sample" 1"In-Sample"
label values InOutSample sample
label define treat 0"Non-PeerForward" 1"PeerForward"
label values Treatment treat
*/

 
*CA
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_4gen.dta",clear
egen PriorAch=std(AvgSAT)
keep district_name BuildingName PriorFAFSA PctBlackHisp PctFreeReduced SumofGR_12_2017 PriorAch InOutSample Treatment
rename SumofGR_12_2017 ClassSize
rename PctFreeReduced PctEconDisadv
rename BuildingName SchoolName
rename district_name District
gen State="CA"
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_CA_4gen.dta",replace

*FL
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_4gen.dta",clear
egen PriorAch=std(PercTotalPoints)
keep DISTRICTNAME SCHOOLNAME PriorFAFSA PctMinority PctEconDisadv Grade_12_2017 PriorAch InOutSample Treatment
replace PctMinority=PctMinority/100
replace PctEconDisadv=PctEconDisadv/100
rename Grade_12_2017 ClassSize
rename PctMinority PctBlackHisp
rename SCHOOLNAME SchoolName
rename DISTRICTNAME District
gen State="FL"
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_FL_4gen.dta",replace

*MD
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_4gen.dta",clear
egen PriorAch2=std(PriorAch)
keep LEAName SchoolName PriorFAFSA PctBlackHisp PctFreeReduced Seniors17 PriorAch2 InOutSample Treatment
rename Seniors17 ClassSize
rename PctFreeReduced PctEconDisadv
rename PriorAch2 PriorAch
rename LEAName District
gen State="MD"
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_MD_4gen.dta",replace

*MI
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MI_4gen.dta",clear
egen PriorAch=std(MathScoreAverage_2016)
keep DistrictName BuildingName PriorFAFSA PctBlackHisp PctEconDisAdv GRADE_12_ENROLLMENT_2017 PriorAch InOutSample Treatment
rename GRADE_12_ENROLLMENT_2017 ClassSize
rename PctEconDisAdv PctEconDisadv
rename DistrictName District
rename BuildingName SchoolName
gen State="MI"
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_MI_4gen.dta",replace

*MO
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MO_4gen.dta",clear
egen PriorAch=std(ACT_COMPOSITE_SCORE_2016)
keep DISTRICT_NAME SCHOOL_NAME PriorFAFSA PctBlackHisp PctFreeReduced ENROLLMENT_GRADES_12_2017 PriorAch InOutSample Treatment
replace PctBlackHisp=PctBlackHisp/100
replace PctFreeReduced=PctFreeReduced/100
rename ENROLLMENT_GRADES_12_2017 ClassSize
rename PctFreeReduced PctEconDisadv
rename DISTRICT_NAME District
rename SCHOOL_NAME SchoolName
gen State="MO"
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_MO_4gen.dta",replace

*NY
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_4gen.dta",clear
egen PriorAch2=std(PriorAch)
keep DISTRICTNAME LOCATIONNAME PriorFAFSA PctBlackHisp PctEconDisAdv GRADE12_2017 PriorAch2 InOutSample Treatment
rename GRADE12_2017 ClassSize
rename PctEconDisAdv PctEconDisadv
rename PriorAch2 PriorAch
rename DISTRICTNAME District
rename LOCATIONNAME SchoolName
gen State="NY"
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_NY_4gen.dta",replace

*OH
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_4gen.dta",clear
egen PriorAch=std(PerfIndGrade)
keep dist_name SchoolName PriorFAFSA PctBlackHisp PctEconDisAdv grade_12_2017 PriorAch InOutSample Treatment
rename grade_12_2017 ClassSize
rename PctEconDisAdv PctEconDisadv
rename dist_name District
gen State="OH"
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_OH_4gen.dta",replace

*SC
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_4gen.dta",clear
egen PriorAch=std(A16_ComAvg)
keep distname locname PriorFAFSA PctBlackHisp POVERTY G_12_2017 PriorAch InOutSample Treatment
replace POVERTY=POVERTY/100
rename G_12_2017 ClassSize
rename POVERTY PctEconDisadv
rename distname District
rename locname SchoolName
gen State="SC"
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_SC_4gen.dta",replace

append using "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_FL_4gen.dta" "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_MD_4gen.dta" "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_MI_4gen.dta" "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_MO_4gen.dta" "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_NY_4gen.dta" "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_OH_4gen.dta" "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_SC_4gen.dta" "C:\Users\scottpw\Desktop\Consults\CollegeSummit\append_CA_4gen.dta"

sum PriorFAFSA PctBlackHisp PctEconDisadv ClassSize PriorAch
sort InOutSample
by InOutSample: sum PriorFAFSA PctBlackHisp PctEconDisadv ClassSize PriorAch
sort Treatment
by Treatment: sum PriorFAFSA PctBlackHisp PctEconDisadv ClassSize PriorAch

by State: sum PriorFAFSA PctBlackHisp PctEconDisadv PriorAch

sum PriorFAFSA PctBlackHisp PctEconDisadv PriorAch
gen LowFAFSA=1 if PriorFAFSA<.35
replace LowFAFSA=0 if PriorFAFSA>=.35
gen HighPctBlackHisp=1 if PctBlackHisp>.4
replace HighPctBlackHisp=0 if PctBlackHisp<=.4
gen HighEconDisadv=1 if PctEconDisadv>.52
replace HighEconDisadv=0 if PctEconDisadv<=.52
gen LowAch=1 if PriorAch<0
replace LowAch=0 if PriorAch>=0

gen Tag=1 if LowFAFSA==1 & HighPctBlackHisp==1 & HighEconDisadv==1 & LowAch==1
tab Tag
list State District SchoolName if Tag==1, noobs table
