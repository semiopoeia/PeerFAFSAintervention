**data cleaning for NY
import excel "C:\Users\scottpw\Desktop\Consults\CollegeSummit\Copy of NY_2017_Enrollment_Final.xlsx", sheet("Data_Set_NY") firstrow

replace SCHOOLTYPE="1" if SCHOOLTYPE=="CHARTER"
replace SCHOOLTYPE="0" if SCHOOLTYPE=="PUBLIC"
label define schtyp 0"Public" 1"Charter"
destring SCHOOLTYPE,replace
label values SCHOOLTYPE schtyp
egen UNIQID=concat( STATEDISTRICTID STATELOCATIONID)
replace FAFSA_6_30_16="5" if FAFSA_6_30_16 =="<5"
replace FAFSA_12_30_16="5" if FAFSA_12_30_16 =="<5"
replace FAFSA3_3_16="5" if FAFS3_3_16 =="<5"
replace FAFSA_3_3_17="5" if FAFSA_3_3_17 =="<5"
destring PK12TOTAL_2017 GRADE12_2017 GRADE12_2016 FAFSA_6_30_16 FAFSA_12_30_16 FAFSA3_3_16 FAFSA_3_3_17, replace
destring GRAD_CNT_Grad_2010_4_yr LOCAL_CNT_Grad_2010_4_yr REG_CNT_Grad_2010_4_yr REG_ADV_CNT_Grad_2010_4_yr NON_DIPLOMA_CREDENTIAL_CNT_Grad_ STILL_ENR_CNT_Grad_2010_4_yr GED_CNT_Grad_2010_4_yr DROPOUT_CNT_Grad_2010_4_yr, force replace
**lots of destringing
***value coding for MET vars is odd, I'm not entirely clear on the codes so i'm going to create indicators
local cov "MET_PART_Math_2014 MET_PERF_Math_2014 MET_PART_Math_2015 MET_PERF_Math_2015 MET_PART_ELA_2014 MET_PERF_ELA_2014 MET_PART_ELA_2015 MET_PERF_ELA_2015"
foreach x of local cov{
	tab `x', gen(`x'_)
}
drop `cov'
local ayp "AYP_Math_2014 AYP_Math_2015 AYP_ELA_2014 AYP_ELA_2015"
foreach x of local ayp{
	tab `x', gen(`x'_)
}
drop `ayp'
**find variables with high missingness to drop (only 20% present), <260 observations
sum _all
drop ENROLL_CNT_Grad_2010_4_yr
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_full_altSet.dta",replace
**create set to mine outcome on (find the most influential variables to control out)
sort UNIQID
drop COUNTY STATEDISTRICTID DISTRICTNAME STATELOCATIONID City_State City FAFSAName LOCATIONNAME Treatment UNIQID
***save and move into R
drop if FAFSA_3_3_17==.
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_toMine_FAFSA.dta",replace

**make treatment mine data with most influential vars
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_full_altSet.dta", clear
keep Treatment FAFSA_12_30_16	FAFSA_6_30_16	NotEnglishLanguageLearner_201	FAFSA3_3_16	GeneralEducationStudents_2017	AsianPacificIslander_Race_2017	REG_ADV_CNT_Grad_2010_4_yr	EconomicallyDisadvantaged_2017	REG_ADV_CNT_Grad_2012_4_yr	PI_G_RATE_Math_2015	NUM_PARTIC_ELA_2014	NUM_ENROLL_Math_2014	PI_G_RATE_ELA_2015	Multiracial_Race_2017	REG_ADV_CNT_Grad_2010_5_yr	PI_G_RATE_Math_2014	GRADE12_2017	NotEconomicallyDisadvantaged_2	NUM_ENROLL_Math_2015	GRAD_CNT_Grad_2010_6_yr	White_Race_2017	REG_ADV_CNT_Grad_2009_6_yr	ENROLL_CNT_Grad_2010_6_yr	REG_ADV_CNT_Grad_2011_5_yr	StudentswithDisabilities_2017	ENROLL_CNT_2009_6_yr	GRAD_CNT_Grad_2010_4_yr	REG_CNT_Grad_2012_4_yr	GRAD_CNT_Grad_2011_5_yr	ENROLL_CNT_Grad_2012_4_yr	Hispanic_Race_2017	REG_CNT_Grad_2009_6_yr	Black_Race_2017	ENROLL_CNT_Grad_2011_5_yr	AMO_STAND_ELA_2014	GRADE12_2016	PI_G_RATE_ELA_2014	REG_CNT_Grad_2010_4_yr	LOCAL_CNT_Grad_2010_6_yr	PK12TOTAL_2017	REG_CNT_Grad_2010_5_yr	AmericanIndianAlaskaNative_Ra	NUM_PERF_Math_2015	STILL_ENR_CNT_Grad_2012_4_yr	ENROLL_CNT_Grad_2010_5_yr	GRAD_CNT_Grad_2012_4_yr	NUM_ENROLL_ELA_2014	NUM_PARTIC_Math_2015	BE	LOCAL_CNT_Grad_2010_5_yr	DROPOUT_CNT_Grad_2012_4_yr	NON_DIPLOMA_CREDENTIAL_CNT_Grad_	LOCAL_CNT_Grad_2010_4_yr	GRAD_CNT_Grad_2009_6_yr	STILL_ENR_CNT_Grad_2010_5_yr	EnglishLanguageLearner_2017	STILL_ENR_CNT_Grad_2010_4_yr	CURRENT_SH_TARGET_ELA_2015	LOCAL_CNT_Grad_2009_6_yr	CURRENT_SH_TARGET_Math_2014	LOCAL_CNT_Grad_2011_5_yr	NUM_PARTIC_ELA_2015	DROPOUT_CNT_Grad_2009_6_yr	STILL_ENR_CNT_Grad_2010_6_yr	DROPOUT_CNT_Grad_2010_4_yr	CURRENT_SH_TARGET_ELA_2014	BW	REG_CNT_Grad_2011_5_yr	LOCAL_CNT_Grad_2012_4_yr	NUM_PERF_Math_2014	STILL_ENR_CNT_Grad_2011_5_yr	NUM_PERF_ELA_2015	NUM_ENROLL_ELA_2015	BN	GRAD_CNT_Grad_2010_5_yr	STILL_ENR_CNT_Grad_2009_6_yr	GED_CNT_Grad_2009_6_yr	DROPOUT_CNT_Grad_2010_6_yr	GED_CNT_Grad_2010_6_yr	GED_CNT_Grad_2010_4_yr	PER_PARTIC_ELA_2015	CURRENT_SH_TARGET_Math_2015	GED_CNT_Grad_2012_4_yr
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_toMine_Treat.dta",replace
**mine Treatment in R
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_ps.dta", clear
merge 1:1 _n using "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_full_altSet.dta"
drop if yhat<0.0034453
**since we have controls with propensity=1, our inverse probability weight will be problematic because IPW= (Treatment/Propensity)+ (1-Treatment)/(1-Propensity), resulting in a zero in the denominator
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_trim1.dta", replace
**So we will make a linear propensity score that will balance on covariance that significantly differ between groups
local cov "FAFSA_12_30_16	FAFSA_6_30_16	NotEnglishLanguageLearner_201	FAFSA3_3_16	GeneralEducationStudents_2017	AsianPacificIslander_Race_2017	REG_ADV_CNT_Grad_2010_4_yr	EconomicallyDisadvantaged_2017	REG_ADV_CNT_Grad_2012_4_yr	PI_G_RATE_Math_2015	NUM_PARTIC_ELA_2014	NUM_ENROLL_Math_2014	PI_G_RATE_ELA_2015	Multiracial_Race_2017	REG_ADV_CNT_Grad_2010_5_yr	PI_G_RATE_Math_2014	GRADE12_2017	NotEconomicallyDisadvantaged_2	NUM_ENROLL_Math_2015	GRAD_CNT_Grad_2010_6_yr	White_Race_2017	REG_ADV_CNT_Grad_2009_6_yr	ENROLL_CNT_Grad_2010_6_yr	REG_ADV_CNT_Grad_2011_5_yr	StudentswithDisabilities_2017	ENROLL_CNT_2009_6_yr	GRAD_CNT_Grad_2010_4_yr	REG_CNT_Grad_2012_4_yr	GRAD_CNT_Grad_2011_5_yr	ENROLL_CNT_Grad_2012_4_yr	Hispanic_Race_2017	REG_CNT_Grad_2009_6_yr	Black_Race_2017	ENROLL_CNT_Grad_2011_5_yr	AMO_STAND_ELA_2014	GRADE12_2016	PI_G_RATE_ELA_2014	REG_CNT_Grad_2010_4_yr	LOCAL_CNT_Grad_2010_6_yr	PK12TOTAL_2017	REG_CNT_Grad_2010_5_yr	AmericanIndianAlaskaNative_Ra	NUM_PERF_Math_2015	STILL_ENR_CNT_Grad_2012_4_yr	ENROLL_CNT_Grad_2010_5_yr	GRAD_CNT_Grad_2012_4_yr	NUM_ENROLL_ELA_2014	NUM_PARTIC_Math_2015	BE	LOCAL_CNT_Grad_2010_5_yr	DROPOUT_CNT_Grad_2012_4_yr	NON_DIPLOMA_CREDENTIAL_CNT_Grad_	LOCAL_CNT_Grad_2010_4_yr	GRAD_CNT_Grad_2009_6_yr	STILL_ENR_CNT_Grad_2010_5_yr	EnglishLanguageLearner_2017	STILL_ENR_CNT_Grad_2010_4_yr	CURRENT_SH_TARGET_ELA_2015	LOCAL_CNT_Grad_2009_6_yr	CURRENT_SH_TARGET_Math_2014	LOCAL_CNT_Grad_2011_5_yr	NUM_PARTIC_ELA_2015	DROPOUT_CNT_Grad_2009_6_yr	STILL_ENR_CNT_Grad_2010_6_yr	DROPOUT_CNT_Grad_2010_4_yr	CURRENT_SH_TARGET_ELA_2014	BW	REG_CNT_Grad_2011_5_yr	LOCAL_CNT_Grad_2012_4_yr	NUM_PERF_Math_2014	STILL_ENR_CNT_Grad_2011_5_yr	NUM_PERF_ELA_2015	NUM_ENROLL_ELA_2015	BN	GRAD_CNT_Grad_2010_5_yr	STILL_ENR_CNT_Grad_2009_6_yr	GED_CNT_Grad_2009_6_yr	DROPOUT_CNT_Grad_2010_6_yr	GED_CNT_Grad_2010_6_yr	GED_CNT_Grad_2010_4_yr	PER_PARTIC_ELA_2015	CURRENT_SH_TARGET_Math_2015	GED_CNT_Grad_2012_4_yr"
hotelling `cov',by(Treatment)
foreach x of local cov{
  by Treatment: sum `x'
  ttest `x',by(Treatment)
  sdtest `x', by(Treatment)
  ttest `x',by(Treatment) unequal
}
local cov "FAFSA_12_30_16	FAFSA_6_30_16	NotEnglishLanguageLearner_201	FAFSA3_3_16	GeneralEducationStudents_2017	AsianPacificIslander_Race_2017	REG_ADV_CNT_Grad_2010_4_yr	EconomicallyDisadvantaged_2017	REG_ADV_CNT_Grad_2012_4_yr	PI_G_RATE_Math_2015	NUM_PARTIC_ELA_2014	NUM_ENROLL_Math_2014	PI_G_RATE_ELA_2015	Multiracial_Race_2017	REG_ADV_CNT_Grad_2010_5_yr	PI_G_RATE_Math_2014	GRADE12_2017	NotEconomicallyDisadvantaged_2	NUM_ENROLL_Math_2015	GRAD_CNT_Grad_2010_6_yr	White_Race_2017	REG_ADV_CNT_Grad_2009_6_yr	ENROLL_CNT_Grad_2010_6_yr	REG_ADV_CNT_Grad_2011_5_yr	StudentswithDisabilities_2017	ENROLL_CNT_2009_6_yr	GRAD_CNT_Grad_2010_4_yr	REG_CNT_Grad_2012_4_yr	GRAD_CNT_Grad_2011_5_yr	ENROLL_CNT_Grad_2012_4_yr	Hispanic_Race_2017	REG_CNT_Grad_2009_6_yr	Black_Race_2017	ENROLL_CNT_Grad_2011_5_yr	AMO_STAND_ELA_2014	GRADE12_2016	PI_G_RATE_ELA_2014	REG_CNT_Grad_2010_4_yr	LOCAL_CNT_Grad_2010_6_yr	PK12TOTAL_2017	REG_CNT_Grad_2010_5_yr	AmericanIndianAlaskaNative_Ra	NUM_PERF_Math_2015	STILL_ENR_CNT_Grad_2012_4_yr	ENROLL_CNT_Grad_2010_5_yr	GRAD_CNT_Grad_2012_4_yr	NUM_ENROLL_ELA_2014	NUM_PARTIC_Math_2015	BE	LOCAL_CNT_Grad_2010_5_yr	DROPOUT_CNT_Grad_2012_4_yr	NON_DIPLOMA_CREDENTIAL_CNT_Grad_	LOCAL_CNT_Grad_2010_4_yr	GRAD_CNT_Grad_2009_6_yr	STILL_ENR_CNT_Grad_2010_5_yr	EnglishLanguageLearner_2017	STILL_ENR_CNT_Grad_2010_4_yr	CURRENT_SH_TARGET_ELA_2015	LOCAL_CNT_Grad_2009_6_yr	CURRENT_SH_TARGET_Math_2014	LOCAL_CNT_Grad_2011_5_yr	NUM_PARTIC_ELA_2015	DROPOUT_CNT_Grad_2009_6_yr	STILL_ENR_CNT_Grad_2010_6_yr	DROPOUT_CNT_Grad_2010_4_yr	CURRENT_SH_TARGET_ELA_2014	BW	REG_CNT_Grad_2011_5_yr	LOCAL_CNT_Grad_2012_4_yr	NUM_PERF_Math_2014	STILL_ENR_CNT_Grad_2011_5_yr	NUM_PERF_ELA_2015	NUM_ENROLL_ELA_2015	BN	GRAD_CNT_Grad_2010_5_yr	STILL_ENR_CNT_Grad_2009_6_yr	GED_CNT_Grad_2009_6_yr	DROPOUT_CNT_Grad_2010_6_yr	GED_CNT_Grad_2010_6_yr	GED_CNT_Grad_2010_4_yr	PER_PARTIC_ELA_2015	CURRENT_SH_TARGET_Math_2015	GED_CNT_Grad_2012_4_yr"
foreach x of local cov{
  regress Treatment `x', vce(robust)
}
**find cov. that significantly differ between treatment groups
local sigdiffcov "FAFSA_12_30_16 FAFSA_6_30_16 NotEnglishLanguageLearner_201 FAFSA3_3_16 GeneralEducationStudents_2017 NotEconomicallyDisadvantaged_2 White_Race_2017 GRAD_CNT_Grad_2010_4_yr GRAD_CNT_Grad_2011_5_yr Hispanic_Race_2017 CURRENT_SH_TARGET_Math_2014 DROPOUT_CNT_Grad_2009_6_yr DROPOUT_CNT_Grad_2010_4_yr BW BN GRAD_CNT_Grad_2010_5_yr GED_CNT_Grad_2010_4_yr CURRENT_SH_TARGET_Math_2015"
***create a linear predictor for this and trim
sem(Treatment<-`sigdiffcov',),method(mlmv) nocapslatent difficult
predict linps
sort Treatment
by Treatment: sum linps
sort UNIQID
**drop cases below minimum propensity for treatment group
drop if linps<.0568152
histogram linps, by(Treatment)
**we now have a nice common support region
**so we make our weights and strata
gen ipw=(Treatment/linps)+((1-Treatment)/(1-linps))
gen StateStrata=1 if linps<=.1
replace StateStrata=2 if linps>.1
replace StateStrata=3 if linps>=.2
**run analysis
mepoisson FAFSA_3_3_17 Treatment [pw=ipw] ,exposure(GRADE12_2017)||StateStrata:, irr
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_trim2.dta",replace
rename UNIQID ID
rename FAFSA_3_3_17 FAFSA3
rename GRADE12_2017 enroll
rename StateStrata Strata
rename linps ps
gen State="NY"
egen StateStrata=concat(State Strata)
**make reduced set for appending to other states
keep Treatment FAFSA3 ID ps Strata ipw enroll State StateStrata
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_reduced_toAppend.dta",replace
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta" ,clear
append using "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_reduced_toAppend.dta"
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta",replace
mepoisson FAFSA3 Treatment [pw=ipw] ,exposure(enroll) State: Treatment ||StateStrata:, irr 


