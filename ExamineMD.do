sem(Treatment<-Level4ctELA10 FAFSA3_3_16 TestedCountELA10  ///
Level3pctELA10 Seniors17 Level2pctELA10 Level4pctELA10 Level1pctELA10 Level5pctELA10 ///
EarnDiplom154 TestedCountAlg1 Level3ctELA10 Level2pctAlg1 Level3ctAlg1 ///
Level1ctAlg1 Level5ctELA10 Level3pctAlg1 Level4pctAlg1 Level1pctAlg1 Level2ctAlg1 EnrolledPct_2015 /// 
Level2ctELA10 Level1ctELA10 EarnDiplom164 AdjCohortCount153 Level2ctAlg2 BL Level1ctAlg2 Level3ctAlg2 ///
HI,),nocapslatent method(mlmv)

local cov "FAFSA_12_30_16 FAFSA_6_30_16 Level4ctELA10 Seniors16 FAFSA3_3_16 TestedCountELA10 Level3pctELA10 Seniors17 Level2pctELA10 Level4pctELA10 Level1pctELA10 Level5pctELA10 EarnDiplom154 TestedCountAlg1 StudentCount_2015 Level3ctELA10 Level2pctAlg1 Level3ctAlg1 Level1ctAlg1 Level5ctELA10 Level3pctAlg1 Level4pctAlg1 Level1pctAlg1 Level2ctAlg1 EnrolledPct_2015 Level2ctELA10 Level1ctELA10 EarnDiplom164 AdjCohortCount153 Level2ctAlg2 BL Level1ctAlg2 Level3ctAlg2 HI"
foreach y of local cov{
by Treatment:sum `y'
ttest `y', by(Treatment)
sdtest `y',by(Treatment)
} 

local sigdiffcov "Seniors16 TestedCountELA10 Seniors17 Level2pctELA10 Level4pctELA10 Level5pctELA10 EarnDiplom154 TestedCountAlg1 StudentCount_2015 Level3ctELA10 Level2pctAlg1 Level3ctAlg1 Level1ctAlg1 Level5ctELA10 Level3pctAlg1 Level4pctAlg1 Level1pctAlg1 Level2ctAlg1 Level2ctELA10 Level1ctELA10 EarnDiplom164 AdjCohortCount153 Level2ctAlg2 BL Level1ctAlg2 Level3ctAlg2 HI"
foreach cov of local sigdiffcov{
by Treatment: sum `cov'
ttest `cov',by(Treatment)
}
local sigdiffcov "Seniors16 TestedCountELA10 Seniors17 Level2pctELA10 Level4pctELA10 Level5pctELA10 EarnDiplom154 TestedCountAlg1 StudentCount_2015 Level3ctELA10 Level2pctAlg1 Level3ctAlg1 Level1ctAlg1 Level5ctELA10 Level3pctAlg1 Level4pctAlg1 Level1pctAlg1 Level2ctAlg1 Level2ctELA10 Level1ctELA10 EarnDiplom164 AdjCohortCount153 Level2ctAlg2 BL Level1ctAlg2 Level3ctAlg2 HI"
logit Treatment `sigdiffcov'
foreach cov of local sigdiffcov{
logit Treatment `cov'
predict p`cov'
}
drop if TestedCountAlg1<139
drop if Level1ctAlg1<43
drop if Level2ctAlg1<57
drop if BL<73
drop if Level1ctAlg2<48
drop if Level3ctAlg2>57

egen prm=rowmean(pSeniors-pHI)
by Treatment: sum prm
drop if prm>.12
