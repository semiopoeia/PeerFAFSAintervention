import excel "C:\Users\scottpw\Desktop\Consults\CollegeSummit\Copy of OH_Data_Final_Vs1.xlsx", sheet("Data Set") firstrow
tab SchoolName dist_name if Treatment==1
**truncated grade 12 count at 10 as it is listed as <10 for low counts
replace grade_12_2016="10" if grade_12_2016=="<10"
replace grade_12_2017="10" if grade_12_2017=="<10"
destring grade_12_2016 grade_12_2017,force replace
**FAFSA counts truncated at 5 cause coded as <5
replace FAFSA_6_30_16= "5" if FAFSA_6_30_16=="<5"
replace FAFSA_12_30_16= "5" if FAFSA_12_30_16=="<5"
replace FAFSA3_3_16= "5" if FAFSA3_3_16=="<5"
replace FAFSA_3_3_17="5" if FAFSA_3_3_17=="<5"
destring FAFSA_6_30_16 FAFSA_12_30_16 FAFSA3_3_16 FAFSA_3_3_17, force replace
**since missing values on FAFSA_3_3_17 will be eliminated from analysis
**go ahead and drop them
drop if FAFSA_3_3_17==.
**censoring student counts at 10
local studcnt "student_w_disability_2017 student_asian_2017 student_black_2017 student_white_2017 student_NativeAm_2017 student_multi_2017 student_latino_2017 student_EconDis_2017 student_female_2017 student_male_2017"
foreach x of local studcnt{
replace `x'="10" if `x'=="<10"
}
local studcnt "student_w_disability_2017 student_asian_2017 student_black_2017 student_white_2017 student_NativeAm_2017 student_multi_2017 student_latino_2017 student_EconDis_2017 student_female_2017 student_male_2017"
destring `studcnt',force replace
gen EcDisPct= student_EconDis_2017/Total_Students_2017
**gradespan variable has lots of levels, since all of the treatment schools are in cincinati lets see grade spans served there
tab GRADESPAN if dist_name=="Cincinnati City"
**here it is mostly (11) 7-12 with 4 K-12
gen Span7_12=1 if GRADESPAN=="7-12"
replace Span7_12=0 if GRADESPAN!="7-12"
gen SpanK_12=1 if GRADESPAN=="K-12"
replace SpanK_12=1 if GRADESPAN=="K-12,P"
replace SpanK_12=0 if GRADESPAN!="1"
destring Span7_12 SpanK_12,force replace
drop GRADESPAN
local ind "INDICATORSMETGRADE_2016 PERFORMANCEINDEXSCOREGRADE_20 YEARGRADUATIONRATEGRADE_201 AE OVERALLVALUEADDEDGRADE_2016 GIFTEDVALUEADDEDGRADE_2016 LOWEST20VALUEADDEDGRADE_201 SWDVALUEADDEDGRADE_2016 AMOGRADE_2016 ACHIEVEMENTCOMPONENTGRADE_2016 GRADUATIONCOMPONENTGRADE_2016 PROGRESSCOMPONENTGRADE_2016 GAPCLOSINGCOMPONENTGRADE_2016 PREPAREDFORSUCCESSGRADE_2016"
foreach x of local ind{
tab `x'
}
local ind "INDICATORSMETGRADE_2016 PERFORMANCEINDEXSCOREGRADE_20 YEARGRADUATIONRATEGRADE_201 AE OVERALLVALUEADDEDGRADE_2016 GIFTEDVALUEADDEDGRADE_2016 LOWEST20VALUEADDEDGRADE_201 SWDVALUEADDEDGRADE_2016 AMOGRADE_2016 ACHIEVEMENTCOMPONENTGRADE_2016 GRADUATIONCOMPONENTGRADE_2016 PROGRESSCOMPONENTGRADE_2016 GAPCLOSINGCOMPONENTGRADE_2016 PREPAREDFORSUCCESSGRADE_2016"
foreach x of local ind{
replace `x'="0" if `x'=="F"
replace `x'="1" if `x'=="D"
replace `x'="2" if `x'=="C"
replace `x'="3" if `x'=="B"
replace `x'="4" if `x'=="A"
}
destring `ind',force replace
sum
**missingness is low across variables
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_full.dta",replace
**prepare for FAFSA mining
sort Unique_ID
keep grade_12_2016 grade_12_2017 FAFSA_6_30_16 FAFSA_12_30_16 FAFSA3_3_16 FAFSA_3_3_17 student_w_disability_2017 student_asian_2017 student_black_2017 student_white_2017 student_NativeAm_2017 student_multi_2017 student_latino_2017 student_EconDis_2017 student_female_2017 student_male_2017 Total_Students_2017 INDICATORSMETGRADE_2016 PERFORMANCEINDEXSCOREGRADE_20 YEARGRADUATIONRATEGRADE_201 AE OVERALLVALUEADDEDGRADE_2016 GIFTEDVALUEADDEDGRADE_2016 LOWEST20VALUEADDEDGRADE_201 SWDVALUEADDEDGRADE_2016 AMOGRADE_2016 ACHIEVEMENTCOMPONENTGRADE_2016 GRADUATIONCOMPONENTGRADE_2016 PROGRESSCOMPONENTGRADE_2016 GAPCLOSINGCOMPONENTGRADE_2016 PREPAREDFORSUCCESSGRADE_2016 EcDisPct Span7_12 SpanK_12
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_FAFSAmine.dta",replace
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_full.dta",clear
***top influence vars from FAFSA mining in R
local imp "FAFSA_12_30_16	FAFSA_6_30_16	FAFSA3_3_16	student_asian_2017	student_female_2017	student_male_2017	student_white_2017	Total_Students_2017	student_multi_2017	grade_12_2017	student_latino_2017	AMOGRADE_2016	INDICATORSMETGRADE_2016	EcDisPct	PREPAREDFORSUCCESSGRADE_2016	student_w_disability_2017	grade_12_2016	PROGRESSCOMPONENTGRADE_2016	OVERALLVALUEADDEDGRADE_2016	LOWEST20VALUEADDEDGRADE_201	PERFORMANCEINDEXSCOREGRADE_20	ACHIEVEMENTCOMPONENTGRADE_2016	SWDVALUEADDEDGRADE_2016	student_EconDis_2017	student_black_2017	GIFTEDVALUEADDEDGRADE_2016	AE	YEARGRADUATIONRATEGRADE_201"
**make treatment mining set
keep Treatment `imp' 
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_TREATmine.dta",replace
**perfect separation so try the logit
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_full.dta",clear
local imp "FAFSA_12_30_16	FAFSA_6_30_16	FAFSA3_3_16	student_asian_2017	student_female_2017	student_male_2017	student_white_2017	Total_Students_2017	student_multi_2017	grade_12_2017	student_latino_2017	AMOGRADE_2016	INDICATORSMETGRADE_2016	EcDisPct	PREPAREDFORSUCCESSGRADE_2016	student_w_disability_2017	grade_12_2016	PROGRESSCOMPONENTGRADE_2016	OVERALLVALUEADDEDGRADE_2016	LOWEST20VALUEADDEDGRADE_201	PERFORMANCEINDEXSCOREGRADE_20	ACHIEVEMENTCOMPONENTGRADE_2016	SWDVALUEADDEDGRADE_2016	student_EconDis_2017	student_black_2017	GIFTEDVALUEADDEDGRADE_2016	AE	YEARGRADUATIONRATEGRADE_201"
logit Treatment `imp' 
**not working (collinearity)
local imp "FAFSA_12_30_16	FAFSA_6_30_16	FAFSA3_3_16	student_asian_2017	student_female_2017	student_male_2017	student_white_2017	Total_Students_2017	student_multi_2017	grade_12_2017	student_latino_2017	AMOGRADE_2016	INDICATORSMETGRADE_2016	EcDisPct	PREPAREDFORSUCCESSGRADE_2016	student_w_disability_2017	grade_12_2016	PROGRESSCOMPONENTGRADE_2016	OVERALLVALUEADDEDGRADE_2016	LOWEST20VALUEADDEDGRADE_201	PERFORMANCEINDEXSCOREGRADE_20	ACHIEVEMENTCOMPONENTGRADE_2016	SWDVALUEADDEDGRADE_2016	student_EconDis_2017	student_black_2017	GIFTEDVALUEADDEDGRADE_2016	AE	YEARGRADUATIONRATEGRADE_201"
foreach x of local imp{
logit Treatment `x'
predict ps`x'
}
**too many perfect predictors, try producing linear propensity
local imp "FAFSA_12_30_16	FAFSA_6_30_16	FAFSA3_3_16	student_asian_2017	student_female_2017	student_male_2017	student_white_2017	Total_Students_2017	student_multi_2017	grade_12_2017	student_latino_2017	AMOGRADE_2016	INDICATORSMETGRADE_2016	EcDisPct	PREPAREDFORSUCCESSGRADE_2016	student_w_disability_2017	grade_12_2016	PROGRESSCOMPONENTGRADE_2016	OVERALLVALUEADDEDGRADE_2016	LOWEST20VALUEADDEDGRADE_201	PERFORMANCEINDEXSCOREGRADE_20	ACHIEVEMENTCOMPONENTGRADE_2016	SWDVALUEADDEDGRADE_2016	student_EconDis_2017	student_black_2017	GIFTEDVALUEADDEDGRADE_2016	AE	YEARGRADUATIONRATEGRADE_201"
foreach x of local imp{
sem (Treatment<-`x',),method(mlmv) vce(jackknife) nocapslatent
predict linp`x'
}
*too long names
rename PERFORMANCEINDEXSCOREGRADE_20 PERFORMANCEINDEX
rename	ACHIEVEMENTCOMPONENTGRADE_2016 ACHIEVEMENTGRADE_2016	
rename SWDVALUEADDEDGRADE_2016 SWDVALUEADDGRADE_2016
rename	student_EconDis_2017 EconDis_2017
rename	student_black_2017 black_2017
rename	GIFTEDVALUEADDEDGRADE_2016 GIFTVALUEADD_2016	
rename AE ae
rename	YEARGRADUATIONRATEGRADE_201 YearGradRatGrade
local short "PERFORMANCEINDEX ACHIEVEMENTGRADE_2016 SWDVALUEADDGRADE_2016 EconDis_2017 black_2017 GIFTVALUEADD_2016 ae YearGradRatGrade"
foreach x of local short{
sem (Treatment<-`x',),method(mlmv) vce(jackknife) nocapslatent
predict linp`x'
}
**black_2017 propensity can't be estimated
**hard trim
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_full.dta",replace
sort Treatment
by Treatment: sum black_2017
drop if black_2017<605
drop if black_2017>878
tab Treatment
local cov "GIFTVALUEADD_2016 ae YearGradRatGrade"
foreach x of local cov{
sem (Treatment<-`x',),method(mlmv) vce(jackknife) nocapslatent
predict linp`x'
}
**gifted value added propensity also not feasible
sort Treatment
by Treatment:sum GIFTVALUEADD_2016
histogram GIFTVALUEADD_2016, by(Treatment)
**no reported gifted value added for treatment can't use it
local cov "ae YearGradRatGrade"
foreach x of local cov{
sem (Treatment<-`x',),method(mlmv) vce(jackknife) nocapslatent
predict linp`x'
}
**since we are down to so few, it's best to just trim on the mean
local linp "linpFAFSA_12_30_16 linpFAFSA_6_30_16 linpFAFSA3_3_16 linpstudent_asian_2017 linpstudent_female_2017 linpstudent_male_2017 linpstudent_white_2017 linpTotal_Students_2017 linpstudent_multi_2017 linpgrade_12_2017 linpstudent_latino_2017 linpAMOGRADE_2016 linpINDICATORSMETGRADE_2016 linpEcDisPct linpPREPAREDFORSUCCESSGRADE_2016 linpstudent_w_disability_2017 linpgrade_12_2016 linpPROGRESSCOMPONENTGRADE_2016 linpOVERALLVALUEADDEDGRADE_2016 linpLOWEST20VALUEADDEDGRADE_201 linpPERFORMANCEINDEX linpACHIEVEMENTGRADE_2016 linpSWDVALUEADDGRADE_2016 linpEconDis_2017 linpblack_2017 linpae linpYearGradRatGrade"
egen meanLinP=rowmean(`linp')
by Treatment: sum meanLinP
drop if meanLinP<.02
**left with 10 control and 3 treatment
gen ipw=(Treatment/meanLinP)+((1-Treatment)/(1-meanLinP))
**with so few treatment no use in making strata
poisson FAFSA_3_3_17 Treatment [pw=ipw],exposure(grade_12_2017) irr
gen Strata=1
gen State="OH"
egen StateStrata=concat(State Strata)
rename FAFSA_3_3_17 FAFSA3
tostring Unique_ID, gen(id) force
drop ID
rename id ID
rename meanLinP ps
renam grade_12_2017 enroll
keep Treatment FAFSA3 ID ps Strata ipw enroll State StateStrata 
egen meanPS=mean(ps)
egen sdPS=sd(ps)
gen stdps=(ps-meanPS)/sdPS
*create inverse logit to put everyone on some probability scale
gen sPS= exp(stdps)/(exp(stdps)+1)
gen sIPW=(Treatment/sPS)+((1-Treatment)/(1-sPS))
egen msIPW=mean(sIPW)
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_toAppend.dta",replace
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta",clear
append using "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_toAppend.dta"
