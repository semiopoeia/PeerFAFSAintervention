**indicates dataset to use
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\ExmpSampDataCA.dta" 

**IDENTIFY AND EXPLORING LOCAL UNITS
****getting a variable for count of schools per district
sort LEAID
egen SchPerDist=count(SCHID),by(LEAID)
**get a sense of count of schools in districts where program is implemented in at least one school
sum SchPerDist if treatment==1
***create unique id for each city-state combination
egen CityState=group(City State)
**similarly,make unique id for states
egen State=group(State)


***ESTABLISHING A SET OF COVARIATES TO CREATE PROPENSITY SCORE
**pull in data from common core

***makes a shortcut reference so you don't have to rewrite covariate names over and over again
local covariates "TOTFRL G12 G13 BL12M BL12F"

**use boosted regression to mine for predictors


**CREATING AND EXPLORING MATCHES


**SETTING UP THE OUTCOME
/**creating proportion variables, because raw count
for FAFSA turn ins is confounded by school size**/
gen Feb5FAFSA15_16=App_C_2_5/G12

