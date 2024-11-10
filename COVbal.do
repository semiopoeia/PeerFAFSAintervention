**CA
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta" ,clear
ttest sPS if State=="CA", by(Treatment)
graph box sPS if State=="CA", over(Treatment) title(Propensity CA) saving(PsCA.gph,replace)
use "C:\Users\scottpw\Desktop\consults\collegesummit\ca_trim1.dta",clear
local cov "PriorFAFSArate_3_16 SumofGR_12_2017 PCTfreereduced PCTBlackHispanicLatinx SATscore16"
foreach x of local cov{
	ttest `x',by(Treatment) 
}
foreach x of local cov {		
	graph box `x', over(Treatment) title(`x') saving(`x'.gph, replace)
}
	
graph combine PriorFAFSArate_3_16.gph SumofGR_12_2017.gph PCTfreereduced.gph PCTBlackHispanicLatinx.gph SATscore16.gph PsCA.gph, ///
title("Covariate Distributions for CA") saving(CAcovbal.gph, replace)

**FL
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta" ,clear
ttest sPS if State=="FL", by(Treatment)
graph box sPS if State=="FL", over(Treatment) title(Propensity FL) saving(PsFL.gph,replace)
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\FL_trimLIN2.dta", clear
local cov "PriorFAFSArr Grade_12_2017 PercentofEconomicallyDisadvan PercentofMinorityStudents_201 PercentofTotalPossiblePoints"
foreach x of local cov{
	ttest `x',by(Treatment) 
}
foreach x of local cov {		
	graph box `x', over(Treatment) title(`x') saving(`x'.gph, replace)
}
	
graph combine PriorFAFSArr.gph Grade_12_2017.gph PercentofEconomicallyDisadvan.gph PercentofMinorityStudents_201.gph PercentofTotalPossiblePoints.gph PsFL.gph, ///
title("Covariate Distributions for FL") saving(FLcovbal.gph, replace)

**MD
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta" ,clear
ttest sPS if State=="MD", by(Treatment)
graph box sPS if State=="MD", over(Treatment) title(Propensity MD) saving(PsMD.gph,replace)
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_expandTrimReduce.dta", clear
local cov "PriorFAFSArr Seniors17 PCTFreeReducedLunch PCTBlackOrHispLat PriorAch"
foreach x of local cov{
	ttest `x',by(Treatment) 
}
foreach x of local cov {		
	graph box `x', over(Treatment) title(`x') saving(`x'.gph, replace)
}
	
graph combine PriorFAFSArr.gph Seniors17.gph PCTFreeReducedLunch.gph PCTBlackOrHispLat.gph PriorAch.gph PsMD.gph, ///
title("Covariate Distributions for MD") saving(MDcovbal.gph, replace)

**MI
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta" ,clear
ttest ps if State=="MI" , by(Treatment)
graph box ps if State=="MI", over(Treatment) title(Propensity MI) saving(PsMI.gph,replace)
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MI_trim2.dta", clear
local cov "PriorFAFSArr GRADE12ENROLLMENT2017 PCTEconDisadv PCTBlackHispLat MathScoreAverage2016"
foreach x of local cov{
	ttest `x',by(Treatment) 
}
foreach x of local cov {		
	graph box `x', over(Treatment) title(`x') saving(`x'.gph, replace)
}
	
graph combine PriorFAFSArr.gph GRADE12ENROLLMENT2017.gph PCTEconDisadv.gph PCTBlackHispLat.gph MathScoreAverage2016.gph  PsMI.gph, ///
title("Covariate Distributions for MI") saving(MIcovbal.gph, replace)
 
 
 **MO
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta" ,clear
ttest sPS if State=="MO" , by(Treatment)
graph box sPS if State=="MO", over(Treatment) title(Propensity MO) saving(PsMO.gph,replace)
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\Work_MO.dta", clear
local cov "PriorFAFSArr ENROLLMENT_GRADES_12_2017 ACT_COMPOSITE_SCORE_2016"
foreach x of local cov{
	ttest `x',by(Treatment) 
}
foreach x of local cov {		
	graph box `x', over(Treatment) title(`x') saving(`x'.gph, replace)
}
	
graph combine PriorFAFSArr.gph ENROLLMENT_GRADES_12_2017.gph ACT_COMPOSITE_SCORE_2016.gph  PsMO.gph, ///
title("Covariate Distributions for MO") saving(MOcovbal.gph, replace)


**NY
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta" ,clear
ttest ps if State=="NY" , by(Treatment)
graph box sPS if State=="NY", over(Treatment) title(Propensity NY) saving(PsNY.gph,replace)
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\NY_trim2.dta", clear
local cov "PriorFAFSArr GRADE12_2017 PCTEconDisadv PCTBlackHispLat PriorAch"
foreach x of local cov{
	ttest `x',by(Treatment) 
}
foreach x of local cov {		
	graph box `x', over(Treatment) title(`x') saving(`x'.gph, replace)
}
	
graph combine PriorFAFSArr.gph GRADE12_2017.gph PCTEconDisadv.gph PCTBlackHispLat.gph PriorAch.gph  PsNY.gph, ///
title("Covariate Distributions for NY") saving(NYcovbal.gph, replace)


**OH
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta" ,clear
ttest sPS if State=="OH" , by(Treatment)
graph box sPS if State=="OH", over(Treatment) title(Propensity OH) saving(PsOH.gph,replace)
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\OH_toAppend.dta", clear
local cov "PriorFAFSArr grade_12_2017 PCTEconDis PCTBlackHispLat"
foreach x of local cov{
	ttest `x',by(Treatment) 
}
foreach x of local cov {		
	graph box `x', over(Treatment) title(`x') saving(`x'.gph, replace)
}
	
graph combine PriorFAFSArr.gph grade_12_2017.gph PCTEconDis.gph PCTBlackHispLat.gph  PsOH.gph, ///
title("Covariate Distributions for OH") saving(OHcovbal.gph, replace)

**SC
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\APPENDED1.dta" ,clear
ttest sPS if State=="SC" , by(Treatment)
graph box sPS if State=="SC", over(Treatment) title(Propensity SC) saving(PsSC.gph,replace)
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\SC_toDescribe.dta", clear
local cov "PriorFAFSArr G_12_2017 POVERTY pctHispBlk A16_ComAvg"
foreach x of local cov{
	ttest `x',by(Treatment) 
}
foreach x of local cov {		
	graph box `x', over(Treatment) title(`x') saving(`x'.gph, replace)
}
	
graph combine PriorFAFSArr.gph G_12_2017.gph POVERTY.gph pctHispBlk.gph A16_ComAvg.gph   PsSC.gph, ///
title("Covariate Distributions for SC") saving(Sccovbal.gph, replace)
