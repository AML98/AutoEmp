clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/nuts2_wages.txt", replace

import excel "raw_data/eurostat/nuts2_wages.xlsx", sheet("Sheet 1") ///
	cellrange(A10:AC33) firstrow	
	
drop if _n == 1
keep region_code region wages_2001 wages_2004 wages_2016

gen log_wages_2001 = log(wages_2001)
gen log_wages_2004 = log(wages_2004)
gen log_wages_2016 = log(wages_2016)

save "clean_data/nuts2_wages.dta", replace
cd "/Users/aml/AutoEmp/do_files/nuts2_data_prep"
log close
