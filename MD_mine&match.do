use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_merged.dta", clear
sort obs
keep Seniors16 Seniors17 FAFSA_6_30_16 FAFSA_12_30_16 FAFSA3_3_16 FAFSA_3_3_17 TOTFRL Member AM AS HI BL WH HP TR StudentCount_2015 EnrolledCount_2015 EnrolledPct_2015 grad15Rate3 EarnDiplom153 AdjCohortCount153 grad15Rate4 EarnDiplom154 AdjCohortCount154 grad15Rate5 EarnDiplom155 AdjCohortCount155 grad16Rate3 EarnDiplom163 AdjCohortCount163 grad16Rate4 EarnDiplom164 AdjCohortCount164 TestedCountELA3 Level1ctELA3 Level1pctELA3 Level2ctELA3 Level2pctELA3 Level3ctELA3 Level3pctELA3 Level4ctELA3 Level4pctELA3 Level5ctELA3 Level5pctELA3 TestedCountELA4 Level1ctELA4 Level1pctELA4 Level2ctELA4 Level2pctELA4 Level3ctELA4 Level3pctELA4 Level4ctELA4 Level4pctELA4 Level5ctELA4 Level5pctELA4 TestedCountELA5 Level1ctELA5 Level1pctELA5 Level2ctELA5 Level2pctELA5 Level3ctELA5 Level3pctELA5 Level4ctELA5 Level4pctELA5 Level5ctELA5 Level5pctELA5 TestedCountMath3 Level1ctMath3 Level1pctMath3 Level2ctMath3 Level2pctMath3 Level3ctMath3 Level3pctMath3 Level4ctMath3 Level4pctMath3 Level5ctMath3 Level5pctMath3 TestedCountMath4 Level1ctMath4 Level1pctMath4 Level2ctMath4 Level2pctMath4 Level3ctMath4 Level3pctMath4 Level4ctMath4 Level4pctMath4 Level5ctMath4 Level5pctMath4 TestedCountMath5 Level1ctMath5 Level1pctMath5 Level2ctMath5 Level2pctMath5 Level3ctMath5 Level3pctMath5 Level4ctMath5 Level4pctMath5 Level5ctMath5 Level5pctMath5 TestedCountAlg1 Level1ctAlg1 Level1pctAlg1 Level2ctAlg1 Level2pctAlg1 Level3ctAlg1 Level3pctAlg1 Level4ctAlg1 Level4pctAlg1 Level5ctAlg1 Level5pctAlg1 TestedCountELA6 Level1ctELA6 Level1pctELA6 Level2ctELA6 Level2pctELA6 Level3ctELA6 Level3pctELA6 Level4ctELA6 Level4pctELA6 Level5ctELA6 Level5pctELA6 TestedCountELA7 Level1ctELA7 Level1pctELA7 Level2ctELA7 Level2pctELA7 Level3ctELA7 Level3pctELA7 Level4ctELA7 Level4pctELA7 Level5ctELA7 Level5pctELA7 TestedCountELA8 Level1ctELA8 Level1pctELA8 Level2ctELA8 Level2pctELA8 Level3ctELA8 Level3pctELA8 Level4ctELA8 Level4pctELA8 Level5ctELA8 Level5pctELA8 TestedCountMath6 Level1ctMath6 Level1pctMath6 Level2ctMath6 Level2pctMath6 Level3ctMath6 Level3pctMath6 Level4ctMath6 Level4pctMath6 Level5ctMath6 Level5pctMath6 TestedCountMath7 Level1ctMath7 Level1pctMath7 Level2ctMath7 Level2pctMath7 Level3ctMath7 Level3pctMath7 Level4ctMath7 Level4pctMath7 Level5ctMath7 Level5pctMath7 TestedCountMath8 Level1ctMath8 Level1pctMath8 Level2ctMath8 Level2pctMath8 Level3ctMath8 Level3pctMath8 Level4ctMath8 Level4pctMath8 Level5ctMath8 Level5pctMath8 TestedCountAlg2 Level1ctAlg2 Level1pctAlg2 Level2ctAlg2 Level2pctAlg2 Level3ctAlg2 Level3pctAlg2 Level4ctAlg2 Level4pctAlg2 Level5ctAlg2 Level5pctAlg2 TestedCountELA10 Level1ctELA10 Level1pctELA10 Level2ctELA10 Level2pctELA10 Level3ctELA10 Level3pctELA10 Level4ctELA10 Level4pctELA10 Level5ctELA10 Level5pctELA10 TestedCountELA11 Level1ctELA11 Level1pctELA11 Level2ctELA11 Level2pctELA11 Level3ctELA11 Level3pctELA11 Level4ctELA11 Level4pctELA11 Level5ctELA11 Level5pctELA11 TestedCountGeometry Level1ctGeometry Level1pctGeometry Level2ctGeometry Level2pctGeometry Level3ctGeometry Level3pctGeometry Level4ctGeometry Level4pctGeometry Level5ctGeometry Level5pctGeometry TestedCountELA9 Level1ctELA9 Level1pctELA9 Level2ctELA9 Level2pctELA9 Level3ctELA9 Level3pctELA9 Level4ctELA9 Level4pctELA9 Level5ctELA9 Level5pctELA9
drop if FAFSA_3_3_17==.
sum 
*drop vars with no variance
drop Level5pctMath8 Level5ctMath8 Level5ctMath7 Level5pctMath7 Level5pctMath6 Level5ctMath6 Level5ctMath5 Level4ctMath5 Level2ctMath5 Level1ctMath5 Level5ctMath4 Level1ctMath4 Level5ctMath3 Level3ctMath3 Level2ctMath3 Level1ctMath3 Level5ctELA5 Level2ctELA5 Level1ctELA5 Level5ctELA4 Level1ctELA4 Level5ctELA3 Level2pctELA3 Level2ctELA3 Level1ctELA3
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_ToMineFAFSA3.dta",replace
gen obs=_n
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\MD_ToMergeP.dta",replace
