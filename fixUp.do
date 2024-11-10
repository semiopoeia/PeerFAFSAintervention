replace Level1ct="5" if Level1ct=="<= 5.0" 
replace Level1ct="." if Level1ct=="*" 
replace Level1ct="95" if Level1ct==">= 95.0" 

replace Level2ct="5" if Level2ct=="<= 5.0" 
replace Level2ct="." if Level2ct=="*" 
replace Level2ct="95" if Level2ct==">= 95.0" 

replace Level2pct="5" if Level2pct=="<= 5.0" 
replace Level2pct="." if Level2pct=="*" 
replace Level2pct="95" if Level2pct==">= 95.0" 

replace Level3ct="5" if Level3ct=="<= 5.0" 
replace Level3ct="." if Level3ct=="*" 
replace Level3ct="95" if Level3ct==">= 95.0" 

replace Level3pct="5" if Level3pct=="<= 5.0" 
replace Level3pct="." if Level3pct=="*" 
replace Level3pct="95" if Level3pct==">= 95.0" 

replace Level4ct="5" if Level4ct=="<= 5.0" 
replace Level4ct="." if Level4ct=="*" 
replace Level4ct="95" if Level4ct==">= 95.0" 

replace Level4pct="5" if Level4pct=="<= 5.0" 
replace Level4pct="." if Level4pct=="*" 
replace Level4pct="95" if Level4pct==">= 95.0" 

replace Level5ct="5" if Level5ct=="<= 5.0" 
replace Level5ct="." if Level5ct=="*" 
replace Level5ct="95" if Level5ct==">= 95.0" 

replace Level5pct="5" if Level5pct=="<= 5.0" 
replace Level5pct="." if Level5pct=="*" 
replace Level5pct="95" if Level5pct==">= 95.0" 

destring Level1ct Level1pct Level2ct Level2pct Level3ct Level3pct Level4ct Level4pct Level5ct Level5pct,replace
replace StudentCount_2015="." if StudentCount_2015=="*" 

replace EnrolledCount_2015="." if EnrolledCount_2015=="*" 

replace EnrolledPct_2015="." if EnrolledPct_2015=="*"

replace Assessment="Alg1" if Assessment=="Algebra 1"
replace Assessment="Alg2" if Assessment=="Algebra 2"
replace Assessment="ELA10" if Assessment=="English/Language Arts Grade 10"
replace Assessment="ELA11" if Assessment=="English/Language Arts Grade 11"
replace Assessment="ELA3" if Assessment=="English/Language Arts Grade 3"
replace Assessment="ELA4" if Assessment=="English/Language Arts Grade 4"
replace Assessment="ELA5" if Assessment=="English/Language Arts Grade 5"
replace Assessment="ELA6" if Assessment=="English/Language Arts Grade 6"
replace Assessment="ELA7" if Assessment=="English/Language Arts Grade 7"
replace Assessment="ELA8" if Assessment=="English/Language Arts Grade 8"
replace Assessment="ELA9" if Assessment=="English/Language Arts Grade 9"
replace Assessment="Math3" if Assessment=="Mathematics Grade 3"
replace Assessment="Math4" if Assessment=="Mathematics Grade 4"
replace Assessment="Math5" if Assessment=="Mathematics Grade 5"
replace Assessment="Math6" if Assessment=="Mathematics Grade 6"
replace Assessment="Math7" if Assessment=="Mathematics Grade 7"
replace Assessment="Math8" if Assessment=="Mathematics Grade 8"
