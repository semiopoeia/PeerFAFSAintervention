**create unique id
egen ID=concat(DISTRICT SCHOOL)
**scanning data for empty vars and obs
drop AT AU
**last two obs are all missing
drop if ID==".."
**FL gives a report card with letter grades (personally, i think this is dumb)
**so i will need to convert their letter grades to numeric values
replace Grade2016="." if Grade2016=="I"
replace InformationalBaselineGrade201="." if InformationalBaselineGrade201=="I"
replace Grade2016="0" if Grade2016=="F"
replace InformationalBaselineGrade201="0" if InformationalBaselineGrade201=="F"
replace Grade2016="1" if Grade2016=="D"
replace InformationalBaselineGrade201="1" if InformationalBaselineGrade201=="D"
replace Grade2016="2" if Grade2016=="C"
replace InformationalBaselineGrade201="2" if InformationalBaselineGrade201=="C"
replace Grade2016="3" if Grade2016=="B"
replace InformationalBaselineGrade201="3" if InformationalBaselineGrade201=="B"
replace Grade2016="4" if Grade2016=="A"
replace InformationalBaselineGrade201="4" if InformationalBaselineGrade201=="A"
destring Grade2016 InformationalBaselineGrade201, force replace
rename InformationalBaselineGrade201 InfoBaseGrade2016
**recode FAFSA vars so that the <5 value will simply be truncated at 5
replace FAFSA_6_30_16="5" if FAFSA_6_30_16=="<5"
replace FAFSA_12_30_16="5" if FAFSA_12_30_16=="<5"
replace FAFSA3_3_16="5" if FAFSA3_3_16=="<5"
replace FAFSA_3_3_17="5" if FAFSA_3_3_17=="<5"
destring FAFSA_6_30_16 FAFSA_12_30_16 FAFSA3_3_16 FAFSA_3_3_17, force replace
destring Grade_12_2016,force replace
replace CharterSchool="1" if CharterSchool=="YES"
replace CharterSchool="0" if CharterSchool=="NO"
destring CharterSchool, force replace
replace TitleI="1" if TitleI=="YES"
replace TitleI="0" if TitleI=="NO"
destring TitleI, force replace
*create indicator
tab AlternativeESECenterSchool, gen(AEN_)
tab AlternativeESECenterSchool Treatment
**no peer forward schools are Altern./ESE
drop AlternativeESECenterSchool 

sort ID
duplicates list ID
**1151, 1431,1991, and 3581 are duplicates
**1151 is validly two separate (district 1 school,school 151 & district 11 school 51
**similar with all, just going to change the ids for one of each duplicate pair
replace ID = "3581A" in 289
replace ID = "1151A" in 20
replace ID = "1431A" in 130
replace ID = "1991A" in 186

save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_full.dta",replace
**check initial balance
sort Treatment
by Treatment: sum
sort ID
**dropping variables that have no variance in treatment
drop NativeHawaiianorOtherPacific AmericanIndianorAlaskaNative TotalComponents_2016
drop if FAFSA_3_3_17==.
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_SetFull.dta",replace
**create a set to mine FAFSA predictors
sort ID
drop DISTRICT DISTRICTNAME SCHOOL City SCHOOLNAME Treatment ID
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_FAFSAmine.dta",replace
**predicting vars in order of influence
local AllPreds "FAFSA_12_30_16	ofStudents_2017	FAFSA_6_30_16	FAFSA3_3_16	Grade_12_2017	HispanicLatino_2017	Grade_12_2016	Asian_2017	ofReducedPriceLunchStudent	White_2017	AS	MathematicsLearningGains_2016	ScienceAchievement_2016	ofFreeLunchStudents_2017	PercentofEconomicallyDisadvan	BlackorAfricanAmerican_2017	TotalPointsEarned_2016	CollegeandCareerAcceleration	MathematicsLearningGainsofth	TwoorMoreRaces_2017	PercentofMinorityStudents_201	GraduationRate201415	GraduationRate201314	MathematicsAchievement_2016	AB	EnglishLanguageArtsLearningG	PercentofTotalPossiblePoints	SocialStudiesAchievement_2016	EnglishLanguageArtsAchievemen	PercentTested_2016	InfoBaseGrade2016	Grade2016	TitleI	CharterSchool"
**making a set to mine treatment
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_SetFull.dta",clear
sort ID
drop DISTRICT DISTRICTNAME SCHOOL City SCHOOLNAME FAFSA_3_3_17 ID
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_TREATmine.dta",replace
keep Treatment ofFreeLunchStudents_2017 ofStudents_2017 ofReducedPriceLunchStudent PercentofMinorityStudents_201 EnglishLanguageArtsAchievemen BlackorAfricanAmerican_2017 GraduationRate201415 
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_TREATmineRED.dta",replace
**boosted propensity with larger set and reduced set result in only 1 misclassified observation, so we need less stringent classifier
sem(Treatment<-ofFreeLunchStudents_2017 ofStudents_2017 ofReducedPriceLunchStudent PercentofMinorityStudents_201 EnglishLanguageArtsAchievemen BlackorAfricanAmerican_2017 GraduationRate201415,), method(mlmv) vce(jacknife) nocapslatent
predict linprob
by Treatment: sum linprob
drop if linprob<.06
drop if linprob >.21
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_trimLIN1.dta",replace
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_SetFull.dta",clear
local AllPreds "FAFSA_12_30_16	ofStudents_2017	FAFSA_6_30_16	FAFSA3_3_16	Grade_12_2017	HispanicLatino_2017	Grade_12_2016	Asian_2017	ofReducedPriceLunchStudent	White_2017	AS	MathematicsLearningGains_2016	ScienceAchievement_2016	ofFreeLunchStudents_2017	PercentofEconomicallyDisadvan	BlackorAfricanAmerican_2017	TotalPointsEarned_2016	CollegeandCareerAcceleration	MathematicsLearningGainsofth	TwoorMoreRaces_2017	PercentofMinorityStudents_201	GraduationRate201415	GraduationRate201314	MathematicsAchievement_2016	AB	EnglishLanguageArtsLearningG	PercentofTotalPossiblePoints	SocialStudiesAchievement_2016	EnglishLanguageArtsAchievemen	PercentTested_2016	InfoBaseGrade2016	Grade2016	TitleI	CharterSchool"
sem (Treatment<-`AllPreds',), method(mlmv) nocapslatent
predict linpr
sort Treatment
by Treatment: sum linpr
drop if linpr<.125
drop if linpr>.27
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_trimLIN2.dta",replace
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_SetFull.dta",clear
local AllPreds "FAFSA_12_30_16	ofStudents_2017	FAFSA_6_30_16	FAFSA3_3_16	Grade_12_2017	HispanicLatino_2017	Grade_12_2016	Asian_2017	ofReducedPriceLunchStudent	White_2017	AS	MathematicsLearningGains_2016	ScienceAchievement_2016	ofFreeLunchStudents_2017	PercentofEconomicallyDisadvan	BlackorAfricanAmerican_2017	TotalPointsEarned_2016	CollegeandCareerAcceleration	MathematicsLearningGainsofth	TwoorMoreRaces_2017	PercentofMinorityStudents_201	GraduationRate201415	GraduationRate201314	MathematicsAchievement_2016	AB	EnglishLanguageArtsLearningG	PercentofTotalPossiblePoints	SocialStudiesAchievement_2016	EnglishLanguageArtsAchievemen	PercentTested_2016	InfoBaseGrade2016	Grade2016	TitleI	CharterSchool"
foreach x of local AllPreds{
logit Treatment `x'
predict ps`x'
}
local pscores "psFAFSA_12_30_16 psofStudents_2017 psFAFSA_6_30_16 psFAFSA3_3_16 psGrade_12_2017 psHispanicLatino_2017 psGrade_12_2016 psAsian_2017 psofReducedPriceLunchStudent psWhite_2017 psAS psMathematicsLearningGains_2016 psScienceAchievement_2016 psofFreeLunchStudents_2017 psPercentofEconomicallyDisadvan psBlackorAfricanAmerican_2017 psTotalPointsEarned_2016 psCollegeandCareerAcceleration psMathematicsLearningGainsofth psTwoorMoreRaces_2017 psPercentofMinorityStudents_201 psGraduationRate201415 psGraduationRate201314 psMathematicsAchievement_2016 psAB psEnglishLanguageArtsLearningG psPercentofTotalPossiblePoints psSocialStudiesAchievement_2016 psEnglishLanguageArtsAchievemen psPercentTested_2016 psInfoBaseGrade2016 psGrade2016 psTitleI psCharterSchool"
foreach p of local pscores{
by Treatment:sum `p'
ttest `p',by(Treatment)
sdtest `p',by(Treatment)
}
**remove cases where ps doesn't overlap
drop if psGrade2016>.07
drop if psGrade2016<.02
drop if psInfoBaseGrade2016>.11
drop if psInfoBaseGrade2016<.01
drop if psEnglishLanguageArtsAchievemen>.06
drop if psEnglishLanguageArtsAchievemen<.01
drop if psMathematicsAchievement_2016<.01
drop if psMathematicsAchievement_2016>.08
drop if psPercentofMinorityStudents_201<.0008
drop if psTwoorMoreRaces_2017<.004
drop if psBlackorAfricanAmerican_2017<.007
drop if psPercentofEconomicallyDisadvan<.01
drop if psPercentofEconomicallyDisadvan>.08
drop if psofFreeLunchStudents_2017<.01
drop if psofFreeLunchStudents_2017>.15
drop if psAS<.008
drop if psAS>.06
drop if psWhite_2017<.001
tab Treatment
**now at 14 control and 9 treatment
local pscores "psFAFSA_12_30_16 psofStudents_2017 psFAFSA_6_30_16 psFAFSA3_3_16 psGrade_12_2017 psHispanicLatino_2017 psGrade_12_2016 psAsian_2017 psofReducedPriceLunchStudent psWhite_2017 psAS psMathematicsLearningGains_2016 psScienceAchievement_2016 psofFreeLunchStudents_2017 psPercentofEconomicallyDisadvan psBlackorAfricanAmerican_2017 psTotalPointsEarned_2016 psCollegeandCareerAcceleration psMathematicsLearningGainsofth psTwoorMoreRaces_2017 psPercentofMinorityStudents_201 psGraduationRate201415 psGraduationRate201314 psMathematicsAchievement_2016 psAB psEnglishLanguageArtsLearningG psPercentofTotalPossiblePoints psSocialStudiesAchievement_2016 psEnglishLanguageArtsAchievemen psPercentTested_2016 psInfoBaseGrade2016 psGrade2016 psTitleI psCharterSchool"
egen meanPS=rowmean(`pscores')
tab meanPS Treatment
by Treatment: sum meanPS
drop if meanPS<.024
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_trimLOG.dta",replace
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_SetFull.dta",clear
local AllPreds "FAFSA_12_30_16	ofStudents_2017	FAFSA_6_30_16	FAFSA3_3_16	Grade_12_2017	HispanicLatino_2017	Grade_12_2016	Asian_2017	ofReducedPriceLunchStudent	White_2017	AS	MathematicsLearningGains_2016	ScienceAchievement_2016	ofFreeLunchStudents_2017	PercentofEconomicallyDisadvan	BlackorAfricanAmerican_2017	TotalPointsEarned_2016	CollegeandCareerAcceleration	MathematicsLearningGainsofth	TwoorMoreRaces_2017	PercentofMinorityStudents_201	GraduationRate201415	GraduationRate201314	MathematicsAchievement_2016	AB	EnglishLanguageArtsLearningG	PercentofTotalPossiblePoints	SocialStudiesAchievement_2016	EnglishLanguageArtsAchievemen	PercentTested_2016	InfoBaseGrade2016	Grade2016	TitleI	CharterSchool"
foreach x of local AllPreds{
sem (Treatment<- `x',),method(mlmv) nocapslatent
predict ps`x'
}
local pscores "psFAFSA_12_30_16 psofStudents_2017 psFAFSA_6_30_16 psFAFSA3_3_16 psGrade_12_2017 psHispanicLatino_2017 psGrade_12_2016 psAsian_2017 psofReducedPriceLunchStudent psWhite_2017 psAS psMathematicsLearningGains_2016 psScienceAchievement_2016 psofFreeLunchStudents_2017 psPercentofEconomicallyDisadvan psBlackorAfricanAmerican_2017 psTotalPointsEarned_2016 psCollegeandCareerAcceleration psMathematicsLearningGainsofth psTwoorMoreRaces_2017 psPercentofMinorityStudents_201 psGraduationRate201415 psGraduationRate201314 psMathematicsAchievement_2016 psAB psEnglishLanguageArtsLearningG psPercentofTotalPossiblePoints psSocialStudiesAchievement_2016 psEnglishLanguageArtsAchievemen psPercentTested_2016 psInfoBaseGrade2016 psGrade2016 psTitleI psCharterSchool"
sort Treatment
foreach p of local pscores{
by Treatment:sum `p'
ttest `p',by(Treatment)
sdtest `p',by(Treatment)
}
drop if psGrade2016<.02
drop if psGrade2016>.05
drop if psInfoBaseGrade2016<.02
drop if psInfoBaseGrade2016>.07
drop if psEnglishLanguageArtsAchievemen<.02
drop if psEnglishLanguageArtsAchievemen>.05
drop if psSocialStudiesAchievement_2016<.02
drop if psSocialStudiesAchievement_2016>.05
drop if psPercentofTotalPossiblePoints<.02
drop if psMathematicsAchievement_2016<.02
drop if psMathematicsAchievement_2016>.05
drop if psPercentofMinorityStudents_201<.01
drop if psTwoorMoreRaces_2017<.008
drop if psTotalPointsEarned_2016<.02
drop if psTotalPointsEarned_2016>.03
drop if psBlackorAfricanAmerican_2017<.02
drop if psPercentofEconomicallyDisadvan<.02
drop if psofFreeLunchStudents_2017<.03
drop if psMathematicsLearningGains_2016<.02
drop if psAS<.01
drop if psWhite_2017<.01
local pscores "psFAFSA_12_30_16 psofStudents_2017 psFAFSA_6_30_16 psFAFSA3_3_16 psGrade_12_2017 psHispanicLatino_2017 psGrade_12_2016 psAsian_2017 psofReducedPriceLunchStudent psWhite_2017 psAS psMathematicsLearningGains_2016 psScienceAchievement_2016 psofFreeLunchStudents_2017 psPercentofEconomicallyDisadvan psBlackorAfricanAmerican_2017 psTotalPointsEarned_2016 psCollegeandCareerAcceleration psMathematicsLearningGainsofth psTwoorMoreRaces_2017 psPercentofMinorityStudents_201 psGraduationRate201415 psGraduationRate201314 psMathematicsAchievement_2016 psAB psEnglishLanguageArtsLearningG psPercentofTotalPossiblePoints psSocialStudiesAchievement_2016 psEnglishLanguageArtsAchievemen psPercentTested_2016 psInfoBaseGrade2016 psGrade2016 psTitleI psCharterSchool"
egen meanPS=rowmean(`pscores')
tab meanPS Treatment
by Treatment: sum meanPS
gen ipw=(Treatment/meanPS)+((1-Treatment)/(1-meanPS))
gen Strata=1 if meanPS<.029
replace Strata=2 if meanPS>.029
mepoisson FAFSA_3_3_17 Treatment [pw=ipw], exposure(ofStudents_2017)||Strata:, irr
**Strata don't work, so FL will have one strata
poisson FAFSA_3_3_17 Treatment [pw=ipw], exposure(ofStudents_2017) irr
replace Strata=1
gen State="FL"
egen StateStrata=concat(State Strata)
rename ofStudents_2017 enroll
rename meanPS ps
rename FAFSA_3_3_17 FAFSA3
sort ID
keep FAFSA3 Treatment ps ipw Strata State StateStrata enroll ID
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_trimLIN2.dta",replace
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta",clear
append using "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_trimLIN2.dta"
egen meanPS=mean(ps),by(State)
egen sdPS=sd(ps),by(State)
gen stdps=(ps-meanPS)/sdPS
*create inverse logit to put everyone on some probability scale
gen sPS= exp(stdps)/(exp(stdps)+1)
gen sIPW=(Treatment/sPS)+((1-Treatment)/(1-sPS))
mepoisson FAFSA3 Treatment [pw=sIPW],exposure(enroll)||StateStrata: Treatment,irr
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta",replace
