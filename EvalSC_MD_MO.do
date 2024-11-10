use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta", clear
mepoisson FAFSA3 Treatment [pw=ipw],exposure(enroll)||StateStrata:,irr
**can also do state by state
sort State
by State:mepoisson FAFSA3 Treatment [pw=ipw],exposure(enroll)||StateStrata:,irr
