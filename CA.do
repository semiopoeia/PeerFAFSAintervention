**Data cleaning
**dropping schools that received hybrid
drop if Unique_ID==1612590110189 
drop if Unique_ID==1612590125716 
drop if Unique_ID==1612590125161
tab Treatment
**10 peer forward, 2463 potential control
tab Treatment SchoolType
**all of the schools with peer forward are classified as public high schools
**so we stick with this
keep if SchoolType=="High Schools (Public)"
**10 peer forward, 1250 potential control
tab EducationalOptionType Treatment
**all peer forward are considered as education option type=traditional so we keep this
keep if EducationalOptionType=="Traditional"
**10 peer forward, 1245 potential control
tab CharterSchoolYN Treatment
*1 peer forward is a charter, however, there is a data error where No has leading space
drop if CharterSchoolYN=="No"
replace CharterSchoolYN="1" if CharterSchoolYN=="Yes"
replace CharterSchoolYN="0" if CharterSchoolYN=="No "
tab Virtual Treatment
**all peer forward are either Virtual=C(primarily classrooms) or Virtual=N(not virtual)
drop if Virtual=="F"
drop if Virtual=="V" 
tab Magnet Treatment
**2 magnet schools for peer forward
replace Virtual="1" if Virtual=="C"
replace Virtual="0" if Virtual=="N"
replace Magnet="1" if Magnet=="Y"
replace Magnet="0" if Magnet=="N"
destring CharterSchoolYN Virtual Magnet, force replace
local fafsa "FAFSA_6_30_16 FAFSA_12_30_16 FAFSA3_3_16 FAFSA_3_3_17"
foreach f of local fafsa{
replace `f'="5" if `f'=="<5" 
}
destring FAFSA_6_30_16 FAFSA_12_30_16 FAFSA3_3_16 FAFSA_3_3_17,force replace
tab LowGrade Treatment
tab HighGrade Treatment
**all peer forward have low=9 and high=12
keep if LowGrade=="9"
keep if HighGrade=="12"
**1132 potential control, 10 peer forward
destring EnrollmentK12_2017 FreeMealCountK12_2017 FRPMCountK12_2017 TotalELLStudents grad_cohort_prct_2014_2015 grad_cohort_prct_2013_2014 grad_cohort_prct_2012_2013 Enroll12_SAT_2016 NumTstTakr_SAT_2016 AvgScrERW_SAT_2016 AvgScoreMath_SAT_2016 NumCCR_Benchmark_SAT_2016 PctCCR_Benchmark_SAT_2016 Enroll12_ACT_16 NumTstTakr_ACT_16 AvgScrEng_ACT_16 AvgScrRead_ACT_16 AvgScrMath_ACT_16 AvgScrSci_ACT_16 NumGE21_ACT_16 PctGE21_ACT_16 ELA_Y1_2015 ELA_Y2_2015 MATH_Y1_2015 MATH_Y2_2016 SCI_Y1_2014 SSCI_Y2_2015 SCI_Y3_2016,force replace
**removing missing on FAFSA_3_3_17, will be excluded from analysis
drop if FAFSA_3_3_17==.
sort Unique_ID
**prepare to mine FAFSA outcome
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_full.dta", replace
drop Treatment Unique_ID BuildingName district_name City SchoolType EducationalOptionType LowGrade HighGrade obs
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_FAFSAmine.dta", replace
**variables from mining with influence>.1
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_full.dta", clear
sort Unique_ID
local cov "FAFSA_6_30_16	FAFSA3_3_16	FAFSA_12_30_16	EnrollmentK12_2017	SumofGR_12_2017	NumTstTakr_SAT_2016	NumCCR_Benchmark_SAT_2016	NumTstTakr_ACT_16	SumofGR_12_2016	Enroll12_ACT_16	FRPMCountK12_2017	WhiteNotHispanic_2017	TwoorMoreRacesNotHispanic_	AvgScrERW_SAT_2016	HispanicorLatino_2017	AvgScoreMath_SAT_2016	FreeMealCountK12_2017	AfricanAmericanNotHispanic_2	grad_cohort_prct_2014_2015	ELA_Y2_2015	PctCCR_Benchmark_SAT_2016	PctGE21_ACT_16	FilipinoNotHispanic_2017	ELA_Y1_2015	SCI_Y1_2014	SCI_Y3_2016	MATH_Y1_2015	TotalELLStudents	MATH_Y2_2016	grad_cohort_prct_2012_2013	AsianNotHispanic_2017	NumGE21_ACT_16	PacificIslanderNotHispanic_2	NotReported_race_2017	grad_cohort_prct_2013_2014	SSCI_Y2_2015	AmericanIndianorAlaskaNative"
keep Treatment `cov'
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_TREATmine.dta", replace
**separated
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_full.dta", clear
sort Unique_ID
**check covariate balance
local cov "FAFSA_6_30_16	FAFSA3_3_16	FAFSA_12_30_16	EnrollmentK12_2017	SumofGR_12_2017	NumTstTakr_SAT_2016	NumCCR_Benchmark_SAT_2016	NumTstTakr_ACT_16	SumofGR_12_2016	Enroll12_ACT_16	FRPMCountK12_2017	WhiteNotHispanic_2017	TwoorMoreRacesNotHispanic_	AvgScrERW_SAT_2016	HispanicorLatino_2017	AvgScoreMath_SAT_2016	FreeMealCountK12_2017	AfricanAmericanNotHispanic_2	grad_cohort_prct_2014_2015	ELA_Y2_2015	PctCCR_Benchmark_SAT_2016	PctGE21_ACT_16	FilipinoNotHispanic_2017	ELA_Y1_2015	SCI_Y1_2014	SCI_Y3_2016	MATH_Y1_2015	TotalELLStudents	MATH_Y2_2016	grad_cohort_prct_2012_2013	AsianNotHispanic_2017	NumGE21_ACT_16	PacificIslanderNotHispanic_2	NotReported_race_2017	grad_cohort_prct_2013_2014	SSCI_Y2_2015	AmericanIndianorAlaskaNative"
sort Treatment
foreach x of local cov{
by Treatment:sum `x'
}
**some clear place where overlap doesn't exist, let's trim on linear propensities
local cov "FAFSA_6_30_16	FAFSA3_3_16	FAFSA_12_30_16	EnrollmentK12_2017	SumofGR_12_2017	NumTstTakr_SAT_2016	NumCCR_Benchmark_SAT_2016	NumTstTakr_ACT_16	SumofGR_12_2016	Enroll12_ACT_16	FRPMCountK12_2017	WhiteNotHispanic_2017	TwoorMoreRacesNotHispanic_	AvgScrERW_SAT_2016	HispanicorLatino_2017	AvgScoreMath_SAT_2016	FreeMealCountK12_2017	AfricanAmericanNotHispanic_2	grad_cohort_prct_2014_2015	ELA_Y2_2015	PctCCR_Benchmark_SAT_2016	PctGE21_ACT_16	FilipinoNotHispanic_2017	ELA_Y1_2015	SCI_Y1_2014	SCI_Y3_2016	MATH_Y1_2015	TotalELLStudents	MATH_Y2_2016	grad_cohort_prct_2012_2013	AsianNotHispanic_2017	NumGE21_ACT_16	PacificIslanderNotHispanic_2	NotReported_race_2017	grad_cohort_prct_2013_2014	SSCI_Y2_2015	AmericanIndianorAlaskaNative"
sort Treatment
foreach x of local cov{
sem (Treatment<-`x',),method(mlmv) vce(jackknife) nocapslatent
predict p`x'
by Treatment: sum p`x'
}
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_full_withP.dta", replace

drop if pAmericanIndianorAlaskaNative<.008
drop if pSSCI_Y2_2015<.004
drop if pgrad_cohort_prct_2013_2014<.01
drop if pgrad_cohort_prct_2013_2014>.025
drop if pNotReported_race_2017<.008
drop if pPacificIslanderNotHispanic_2<.01
drop if pNumGE21_ACT_16<.01
drop if pAsianNotHispanic_2017<.009
drop if pgrad_cohort_prct_2012_2013<.008
drop if pMATH_Y2_2016<.004
drop if pMATH_Y1_2015<.01
drop if pSCI_Y3_2016<.008
drop if pSCI_Y1_2014<.009
drop if pELA_Y1_2015<.004
drop if pFilipinoNotHispanic_2017<.01
drop if pPctGE21_ACT_16<.005
drop if pPctCCR_Benchmark_SAT_2016<.007
drop if pELA_Y2_2015<.004
drop if pgrad_cohort_prct_2014_2015<.01
drop if pgrad_cohort_prct_2014_2015>.03
drop if pAvgScoreMath_SAT_2016<.007
drop if pAvgScrERW_SAT_2016<.007
drop if pTwoorMoreRacesNotHispanic_<.01
drop if pWhiteNotHispanic_2017<.01
drop if pEnroll12_ACT_16<.006
drop if pSumofGR_12_2016<.006
drop if pNumTstTakr_ACT_16<.009
drop if pNumCCR_Benchmark_SAT_2016<.006
drop if pNumTstTakr_SAT_2016<.006
drop if pSumofGR_12_2017<.006
drop if pEnrollmentK12_2017<.005
drop if pFAFSA_12_30_16<.008
drop if pFAFSA3_3_16<.006
drop if pFAFSA_6_30_16<.007
**trimmed file puts us at 21 controls, and 10 peer forward
local ps "pFAFSA_6_30_16 pFAFSA3_3_16 pFAFSA_12_30_16 pEnrollmentK12_2017 pSumofGR_12_2017 pNumTstTakr_SAT_2016 pNumCCR_Benchmark_SAT_2016 pNumTstTakr_ACT_16 pSumofGR_12_2016 pEnroll12_ACT_16 pFRPMCountK12_2017 pWhiteNotHispanic_2017 pTwoorMoreRacesNotHispanic_ pAvgScrERW_SAT_2016 pHispanicorLatino_2017 pAvgScoreMath_SAT_2016 pFreeMealCountK12_2017 pAfricanAmericanNotHispanic_2 pgrad_cohort_prct_2014_2015 pELA_Y2_2015 pPctCCR_Benchmark_SAT_2016 pPctGE21_ACT_16 pFilipinoNotHispanic_2017 pELA_Y1_2015 pSCI_Y1_2014 pSCI_Y3_2016 pMATH_Y1_2015 pTotalELLStudents pMATH_Y2_2016 pgrad_cohort_prct_2012_2013 pAsianNotHispanic_2017 pNumGE21_ACT_16 pPacificIslanderNotHispanic_2 pNotReported_race_2017 pgrad_cohort_prct_2013_2014 pSSCI_Y2_2015 pAmericanIndianorAlaskaNative"
**make an average propensity to trim on and weight with
egen meanPS=rowmean(`ps')
by Treatment: sum meanPS
**pretty nice balance with control ps being contained in treatment range
**but we can trim below .01 and above .02, since treatment ps go out of these bounds
drop if meanPS<.01
drop if meanPS>.02
gen ipw=(Treatment/meanPS)+((1-Treatment)/(1-meanPS))
tab meanPS Treatment
**can't estimate when i try creating strata, so we will just treat CA as one strata
tab Treatment
**7 treatment, 21 controls
poisson FAFSA_3_3_17 Treatment [pw=ipw], exposure( SumofGR_12_2017) irr
**results show IRR=1.07, SE=.126, z=.57,p=.569, non-significant but positive with ~7% higher return rate
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_trim1.dta", replace
**prepare to append
rename FAFSA_3_3_17 FAFSA3 
rename Unique_ID ID
rename meanPS ps 
gen Strata=1
rename SumofGR_12_2017 enroll
gen State="CA"
egen StateStrata=concat(State Strata)
egen meanPS=mean(ps)
egen sdPS=sd(ps)
gen stdps=(ps-meanPS)/sdPS
gen sPS= exp(stdps)/(exp(stdps)+1)
gen sIPW=(Treatment/sPS)+((1-Treatment)/(1-sPS))
egen msIPW=mean(sIPW)
sort ID
gen keyID=_n
tostring keyID,replace
rename ID Unique_ID
rename keyID ID
keep Treatment FAFSA3 ID ps Strata ipw enroll State StateStrata meanPS sdPS stdps sPS sIPW msIPW
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\CA_toAppend.dta", replace
