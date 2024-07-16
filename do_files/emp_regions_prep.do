clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/emp_regions_prep.txt", replace

import excel "raw_data/eurostat/emp_regions.xlsx", sheet("Sheet 1") cellrange(A13:L40) firstrow
drop GEOLabels
keep region_code AB CE F
drop if missing(AB) | missing(CE) | missing(F)

gen emp_share_AB = AB / AB[1] 
gen emp_share_CE = CE / CE[1] 
gen emp_share_F = F / F[1]

save "clean_data/emp_regions.dta", replace

cd "/Users/aml/AutoEmp/do_files"

log close
