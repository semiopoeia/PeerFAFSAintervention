***Pulling in the full data set
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SCdata.dta"

***Retain relevant variables, 
***i.e. top covariates from boosting,Treatment,IDs,and Outcome
keep Unique_ID ID Treatment G5GRADRATE16 G_12_2017 cFAF lFAF //
CFR_COLLEGE G_10_2017 Black_2017 Amer_Indian_2016 Hisp_2016  //
Haw_Pac_2016 two_2016 White_2016 missing_r_2016 Female_2016 //
Male_2016 Missing_g_2016 G_9_2017 G_11_2017 L13 C27 EOC16_Math //
POVERTY DUAL A16_WrtAvg Total_enrolled_2017 CTS_tectch EOC16_Eng //
CHDUAL L12 Clib_Res LPOVERTY Capp ST6 A16_BenRea LTS_tectch C12 C33 //
DROPREC L29 ST7 L32 ST10 C28 L19 DUALcours A16_Comp21 A16_MatAvg ST5 //
DUAL_suc L11 C30 ST11 L28 LIFE C16 L27 A16_BenCom Wk16_Read L6 C9 Clib_bk //
L30 ST8 C31 C11 L18 Llib_bk L33 C17 C25 CHDROPREC C19 Llib_Res CTVac C32 //
EOC16_Hist Lapp ST12 C4 C18 FAFSA_3_1_17 

***Review Variables
sum

***it appears we have some missing value indicators (-1, -4)
***so we convert these to system missing
mvdecode _all, mv(-1,-4)

**Some numeric values have been read in as string
***so we convert these to numeric
destring ST5 ST6 ST7 ST8 ST10 ST11 ST12 FAFSA_3_1_17, force replace

***Since counts for missing gender or race seem uninformative 
***as well as having high missing values, dropping them
drop Missing_g_2016 missing_r_2016

***create a variable indicating amount of missing values across cases
egen msflg=rowmiss(_all)
sum msflg
***shows only 14 cases have complete values

***create indicator for missing vs. non-missing cases
gen msflgD=1 if msflg>0
replace msflgD=0 if msflg==0
label define miss 0"No Miss" 1"Miss"
label values msflgD miss

***Save under new title
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_FAFSA3_working.dta"

use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_FAFSA3_working.dta", clear
***Examine missing patterns by checking covariate balance between 
***missing and non-missing (note I like using the bootstrap 
***so i can mitigare concerns with parametric violations, and overly influential cases
**recall full cases is small so concern of error is important
**the same is true for treatment

*set local memory store for covariates (so we don't have to write their names over and over again)
local covariates "A16_MatAvg A16_WrtAvg A16_Comp21 A16_BenRea A16_BenCom Wk16_Read EOC16_Math EOC16_Eng EOC16_Hist G5GRADRATE16 LIFE CFR_COLLEGE POVERTY LPOVERTY C4 C9 C11 L11 L6 C16 C12 L12 L13 C17 C18 L18 C19 L19 cFAF lFAF Capp Lapp DUAL CHDUAL DUAL_suc DROPREC CHDROPREC C27 L27 C28 L28 L29 C30 L30 CTVac C31 C32 L32 C33 L33 Clib_bk Llib_bk Clib_Res Llib_Res CTS_tectch LTS_tectch C25 DUALcours ST5 ST6 ST7 ST8 ST10 ST11 ST12 FAFSA_3_1_17 G_9_2017 G_10_2017 G_11_2017 G_12_2017 Total_enrolled_2017 Black_2017 Female_2016 Male_2016 Amer_Indian_2016 Hisp_2016 Haw_Pac_2016 two_2016 White_2016"
***loop over variables to check balance, i.e. are there sig. diff. between miss and no-miss
foreach mx of local covariates{
regress `mx' msflgD, vce(bootstrap, bca reps(500) seed(732)) nodots}

**some differences between miss and no miss, but since covariate balance is most important
**we'll mainly worry about this after checking establishing common support region/propensity matches

***Create a log to store the covariate balance examination
log using "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SCexamine.smcl"
local covariates "A16_MatAvg A16_WrtAvg A16_Comp21 A16_BenRea A16_BenCom Wk16_Read EOC16_Math EOC16_Eng EOC16_Hist G5GRADRATE16 LIFE CFR_COLLEGE POVERTY LPOVERTY C4 C9 C11 L11 L6 C16 C12 L12 L13 C17 C18 L18 C19 L19 cFAF lFAF Capp Lapp DUAL CHDUAL DUAL_suc DROPREC CHDROPREC C27 L27 C28 L28 L29 C30 L30 CTVac C31 C32 L32 C33 L33 Clib_bk Llib_bk Clib_Res Llib_Res CTS_tectch LTS_tectch C25 DUALcours ST5 ST6 ST7 ST8 ST10 ST11 ST12 FAFSA_3_1_17 G_9_2017 G_10_2017 G_11_2017 G_12_2017 Total_enrolled_2017 Black_2017 Female_2016 Male_2016 Amer_Indian_2016 Hisp_2016 Haw_Pac_2016 two_2016 White_2016"
**checking covariate balance between treatment and control
foreach px of local covariates{
regress `px' Treatment, vce(bootstrap, bca reps(500) seed(732)) nodots
}

**Establishing common support on the covariates
**looking at covariate distribution between groups and eliminating
**non-overlap, namely for this dataset since we have so few treatment
**cases we will focus on removing controls below the minimum or above the maximum
**covariate values of the treatment distribution, each variable that has a significant 
**regression coefficient is considered in turn


sort Treatment
local sigdiffcov "A16_MatAvg Wk16_Read EOC16_Math EOC16_Hist LIFE POVERTY LPOVERTY C4 C9 C17 C19 L19 Capp DUAL CHDUAL DUAL_suc L28 L29 C32 L32 C33 L33 CTS_tectch LTS_tectch C25 DUALcours ST10 Black_2017 Amer_Indian_2016 Haw_Pac_2016 two_2016"
foreach sdc of local sigdiffcov{
by Treatment:sum `sdc'
}

***now we want to look at the general distribution for these covariates to see how outliers
**are influencing these distributions
local sigdiffcov "A16_MatAvg Wk16_Read EOC16_Math EOC16_Hist LIFE POVERTY LPOVERTY C4 C9 C17 C19 L19 Capp DUAL CHDUAL DUAL_suc L28 L29 C32 L32 C33 L33 CTS_tectch LTS_tectch C25 DUALcours ST10 Black_2017 Amer_Indian_2016 Haw_Pac_2016 two_2016"
foreach sdc of local sigdiffcov{
		graph twoway ///
		(kdensity `sdc' if Treatment  == 1) ///
		(kdensity `sdc' if Treatment  == 0), ///
		legend(label(1 "Peer Forward") label(2 "Control")) ///
		ytitle(Kernel density) ///
		title(`sdc') ///
		saving(`sdc'.gph, replace)		
}


graph combine A16_MatAvg.gph Wk16_Read.gph EOC16_Math.gph EOC16_Hist.gph LIFE.gph ///
POVERTY.gph LPOVERTY.gph C4.gph C9.gph C17.gph C19.gph L19.gph Capp.gph DUAL.gph ///
CHDUAL.gph DUAL_suc.gph L28.gph L29.gph C32.gph L32.gph C33.gph /// 
L33.gph CTS_tectch.gph LTS_tectch.gph C25.gph DUALcours.gph ST10.gph ///
Black_2017.gph Amer_Indian_2016.gph Haw_Pac_2016.gph two_2016.gph, ///
saving(pfSCkd.gph, replace)
**the plots indicate that we have some overlap on all of covariates

**note had to drop Lapp from kernel denisty plots because insufficient obs
**so we look individually at it here
graph box Lapp, over(Treatment)
by Treatment: sum Lapp
**because the issue is that Lapp has N=1 in treatment, thus no variation
**it will need to be dropped
drop Lapp

**since we can argue for overlap i can now begin dropping cases to set
**up a trimmed subsample using the information from the "sum" loop above

save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_FAFSA3_Trimmed1.dta"
/**this way we can retain the prior dataset with the full set
**in case this trimming is problematic (generally i am trying to create extremenly close matches by making exact overlap)
drop if A16_MatAvg<14.6 & Treatment==0
drop if A16_MatAvg>19.7 & Treatment==0
drop if Wk16_Read>96.4 & Treatment==0
drop if Wk16_Read<84.5 & Treatment==0
drop if EOC16_Math<43.6 & Treatment==0
drop if EOC16_Math>86.6 & Treatment==0
drop if EOC16_Hist<21.9 & Treatment==0
drop if EOC16_Hist>73.9 & Treatment==0
drop if LIFE<26.92308 & Treatment==0
drop if LIFE>37.23849 & Treatment==0
drop if POVERTY<41.1 & Treatment==0
drop if POVERTY>95.2 & Treatment==0
drop if LPOVERTY<49.9 & Treatment==0
drop if LPOVERTY>97.4 & Treatment==0
drop if C4<88.4 & Treatment==0
drop if C4>94.7 & Treatment==0
drop if C9<10.6 & Treatment==0
drop if C9>20.6 & Treatment==0
drop if C17<3.3 & Treatment==0
drop if C17>26.9 & Treatment==0 
drop if C19>20.4 & Treatment==0
drop if L19<1.3 & Treatment==0
drop if L19>23.5 & Treatment==0
drop if Capp<50.8 & Treatment==0
drop if Capp>72.5 & Treatment==0
drop if DUAL<8 & Treatment==0
drop if DUAL>32 & Treatment==0
**for CHDUAL we have treatment going below control minimum, so we only drop cases above treatment maximum
drop if CHDUAL>43 & Treatment==0
drop if DUAL_suc<95 & Treatment==0
***because treatment schools are so skewed on success in dual enrollment
***it is worth considering that Peer Forward is positively influencing this outcome
drop if L28<91.9 & Treatment==0
drop if L28>95.9 & Treatment==0
drop if L29<49087 & Treatment==0
drop if L29>53852 & Treatment==0
drop if C32<8.1 & Treatment==0
drop if C32>26.6 & Treatment==0
drop if L32<16.6 & Treatment==0
drop if L32>26.7 & Treatment==0
drop if C33<81.1 & Treatment==0
drop if C33>89 & Treatment==0
**similar case where L33 treat minimum goes below control min, dropping only at maximum
drop if L33>89.8 & Treatment==0
drop if CTS_tectch<408 & Treatment==0
drop if CTS_tectch>2202 & Treatment==0
drop if LTS_tectch<.6818182 & Treatment==0
drop if LTS_tectch>2.837838 & Treatment==0
drop if C25>7.4 & Treatment==0
drop if DUALcours>10 & Treatment==0
drop if ST10<38.9 & Treatment==0
drop if ST10>88.1 & Treatment==0
drop if Black_2017<383 & Treatment==0
drop if Black_2017>1010 & Treatment==0
drop if Amer_Indian_2016>1 & Treatment==0
drop if Haw_Pac_2016<3 & Treatment==0
drop if Haw_Pac_2016>90 & Treatment==0
drop if two_2016>1 & Treatment==0
tab Treatment
**unfortunately all controls are lost so we go back to older data set
**and consider other options
**/
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_FAFSA3_Trimmed1.dta", clear
**make dataset for boosting in R
drop random
gen random=runiform(0,1)
sort random
drop obs
gen obs=_n
sort obs
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_FAFSA3_Trimmed1.dta", replace
local vars "Treatment A16_MatAvg A16_WrtAvg A16_Comp21 A16_BenRea A16_BenCom Wk16_Read EOC16_Math EOC16_Eng EOC16_Hist G5GRADRATE16 LIFE CFR_COLLEGE POVERTY LPOVERTY C4 C9 C11 L11 L6 C16 C12 L12 L13 C17 C18 L18 C19 L19 cFAF lFAF Capp DUAL CHDUAL DUAL_suc DROPREC CHDROPREC C27 L27 C28 L28 L29 C30 L30 CTVac C31 C32 L32 C33 L33 Clib_bk Llib_bk Clib_Res Llib_Res CTS_tectch LTS_tectch C25 DUALcours ST5 ST6 ST7 ST8 ST10 ST11 ST12 G_9_2017 G_10_2017 G_11_2017 G_12_2017 Total_enrolled_2017 Black_2017 Female_2016 Male_2016 Amer_Indian_2016 Hisp_2016 Haw_Pac_2016 two_2016 White_2016"
keep `vars' 
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_Treat_boostR4ps.dta",replace
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_FAFSA3_Trimmed1.dta", clear
merge 1:1 _n using "C:\Users\scottpw\Desktop\Consults\CollegeSummit\psD.dta"
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_TreatTrim1.dta",replace
graph twoway ///
	(kdensity ps if Treatment  == 1) ///
	(kdensity ps if Treatment  == 0), ///
	legend(label(1 "Peer Forward") label(2 "Control")) ///
	ytitle(Kernel density) ///
	title(PS_SC_overlap) ///
	saving(PS_SC_overlap.gph, replace)
**find close matches on propensity, note boosting is partcularly powerful
keep ID Treatment FAFSA_3_1_17 yhat
gen ps=round(yhat,.01)
sort Treatment
by Treatment: sum ps
***we drop values below Treatment==1 ps minimum & above Treatment==0 ps maximum
drop if ps<.03 & Treatment==0
drop if ps>.35 & Treatment==1
drop if FAFSA_3_1_17==.
bootstrap, reps(1200) bca seed(8675309): regress ps i.Treatment
**shows groups are not significantly different on the propensity score, 
**hence we can conclude balance (bootstrapping is used because small sample)

**this leaves us with 20 controls & 4 treatment in common support
**from here we can nearest neighbor matching using mahalanobis distance
**drop NN1-NN7
teffects nnmatch (FAFSA_3_1_17 ps) (Treatment), nneighbor(1) 
**the statistic is significant (p=.047), small sample size underpowers
**and we bootstrap in order to overcome this and other small sample issues
**also because of how tiny the treatment is in relation to control some bootstrap
**replications fail, but it's no big deal as well over 500 replications were successful
bootstrap, reps(1200) bca : teffects nnmatch (FAFSA_3_1_17 ps) (Treatment), nneighbor(1)
**the bootstrapped results return the same treatment effect estimate, 
**since standard errors(empirically derived) are now smaller the p-value goes down to (p=.008)

**because FAFSA return is a count variable it is good to fit Poisson
**first run propensity weighting Poisson Regression
**unfortunately, you can't bootstrap with sampling weights in Stata
**so I simply set the standard errors to be robust and report the incidence rate ratio
poisson FAFSA_3_1_17 Treatment [pweight=ipw],irr
**these results also indicate a positive effect of Peer Forward,
**namely Peer Forward schools have around twice the amount of returns

save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_matchSetTrim.dta",replace
