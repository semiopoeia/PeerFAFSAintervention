**because number of assessment are uneven within id we have to 
**reshape datasets for each id
levelsof ID,local(levels)
foreach l of local levels{
use "C:\Users\scottpw\Desktop\Consults\CollegeSummit\TempMD\MD_PARC.dta",clear 
keep if ID=="`l'"
reshape wide TestedCount Level1ct Level1pct Level2ct Level2pct Level3ct Level3pct Level4ct Level4pct Level5ct Level5pct, i(ID) j(Assessment) string
save "C:\Users\scottpw\Desktop\Consults\CollegeSummit\TempMD\PARCset_MD`l'.dta",replace
}
**then append the indvidual files to make a master file
cd "C:\Users\scottpw\Desktop\Consults\CollegeSummit\TempMD" 
ssc install fs
fs "PARCset_MD*.dta"
append using `r(files)'

**some variables have 2 or fewer values on them, so they should be removed
drop TestedCountELA3a Level1ctELA3a Level1pctELA3a Level2ctELA3a Level2pctELA3a Level3ctELA3a Level3pctELA3a Level4ctELA3a Level4pctELA3a Level5ctELA3a Level5pctELA3a TestedCountELA4a Level1ctELA4a Level1pctELA4a Level2ctELA4a Level2pctELA4a Level3ctELA4a Level3pctELA4a Level4ctELA4a Level4pctELA4a Level5ctELA4a Level5pctELA4a TestedCountELA5a Level1ctELA5a Level1pctELA5a Level2ctELA5a Level2pctELA5a Level3ctELA5a Level3pctELA5a Level4ctELA5a Level4pctELA5a Level5ctELA5a Level5pctELA5a TestedCountMath3a Level1ctMath3a Level1pctMath3a Level2ctMath3a Level2pctMath3a Level3ctMath3a Level3pctMath3a Level4ctMath3a Level4pctMath3a Level5ctMath3a Level5pctMath3a TestedCountMath4a Level1ctMath4a Level1pctMath4a Level2ctMath4a Level2pctMath4a Level3ctMath4a Level3pctMath4a Level4ctMath4a Level4pctMath4a Level5ctMath4a Level5pctMath4a TestedCountMath5a Level1ctMath5a Level1pctMath5a Level2ctMath5a Level2pctMath5a Level3ctMath5a Level3pctMath5a Level4ctMath5a Level4pctMath5a Level5ctMath5a Level5pctMath5a
