use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta",clear
**i am standardizing the propensities within each state as z scores 
**then putting them on a probability scale so that the propensity scale is the same in every state
**note this is not that important since the weight is being applied within the state level anyhow
**but it does allow us to create a weight at the between State level (level 2)
egen meanPS=mean(ps),by(State)
egen sdPS=sd(ps),by(State)
gen stdps=(ps-meanPS)/sdPS
*create inverse logit to put everyone on some probability scale
gen sPS= exp(stdps)/(exp(stdps)+1)
gen sIPW=(Treatment/sPS)+((1-Treatment)/(1-sPS))
**only propensity weighted within the state level, 
**SE adjustment for clustering within state and (where applicable) strata within state
**also allow treatment effect to vary across strata
gen msIPW=mean(sIPW),by(State)
mepoisson FAFSA3 Treatment [pw=ipw],exposure(enroll)||StateStrata: Treatment,irr vce(cluster State)
**add a propensity weight to the between state level
mepoisson FAFSA3 Treatment [pw=ipw],exposure(enroll)||StateStrata: Treatment, pweight(msIPW) irr vce(cluster State)
**in both cases the effect is significant at around 20% higher FAFSA returns
**explore with standardized
mepoisson FAFSA3 Treatment [pw=sIPW],exposure(enroll)||StateStrata: Treatment,irr vce(cluster State)
**add a propensity weight to the between state level
mepoisson FAFSA3 Treatment [pw=sIPW],exposure(enroll)||StateStrata: Treatment, pweight(msIPW) irr vce(cluster State)

**sensitivity analysis (sort of a jackknife), estimating effect while holding each state out
egen state=group(State)
foreach i in 1 2 3 4 5 6 7 8{
tab State if state==`i'
mepoisson FAFSA3 Treatment [pw=ipw] if state!=`i',exposure(enroll)||StateStrata: Treatment,irr vce(cluster State) difficult
mepoisson FAFSA3 Treatment [pw=ipw] if state!=`i',exposure(enroll)||StateStrata: Treatment, pweight(msIPW) irr vce(cluster State) difficult
}
foreach i in 1 2 3 4 5 6 7 8{
tab State if state==`i'
poisson FAFSA3 Treatment [pw=ipw] if state==`i',exposure(enroll)irr  difficult
}

drop state
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta",replace
mepoisson FAFSA3 Treatment [pw=sIPW] if State=="SC"exposure(enroll)||StateStrata: Treatment, pweight(msIPW) irr
mepoisson FAFSA3 Treatment [pw=ipw] if State=="SC"exposure(enroll)||StateStrata: Treatment, pweight(msIPW) irr
mepoisson FAFSA3 Treatment [pw=ipw] if State=="SC"exposure(enroll)||StateStrata: Treatment,  irr
mepoisson FAFSA3 Treatment [pw=ipw] if State=="SC"exposure(enroll)||Strata:,  irr
poisson FAFSA3 Treatment [pw=ipw] if State=="SC"exposure(enroll),  irr
mepoisson FAFSA3 Treatment [pw=sIPW] if State=="SC"exposure(enroll)||Strata: Treatment,  irr

poisson FAFSA3 Treatment [pw=ipw] if State=="CA"exposure(enroll),  irr
poisson FAFSA3 Treatment [pw=sIPW] if State=="FL"exposure(enroll),  irr

**indicates school-strata
tab State Strata
**so CA(1), FL(2), MI(4),OH (7) only have 1 strata
foreach i in 1 2 4 7 {
tab State if state==`i'
poisson FAFSA3 Treatment [pw=sIPW] if state==`i',exposure(enroll)irr  difficult
}
**while MD(3),MO(5), NY(6),SC(8)
foreach i in 3 5 6 8 {
tab State if state==`i'
mepoisson FAFSA3 Treatment [pw=sIPW] if state==`i',exposure(enroll)||Strata:, irr 
}

egen state=group(State)
foreach i in 1 2 3 4 5 6 7 8{
tab State if state==`i'
mepoisson FAFSA3 Treatment [pw=sIPW] if state!=`i',exposure(enroll)||StateStrata: Treatment,irr vce(cluster State) difficult
mepoisson FAFSA3 Treatment [pw=ipw] if state!=`i',exposure(enroll)||StateStrata: Treatment, pweight(msIPW) irr vce(cluster State) difficult
mepoisson FAFSA3 Treatment [pw=sIPW] if state!=`i',exposure(enroll)||StateStrata: Treatment, pweight(msIPW) irr vce(cluster State) difficult
}
