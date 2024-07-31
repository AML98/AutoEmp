clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/emp_countries_prep.txt", replace

import excel "raw_data/eurostat/emp_countries.xlsx", sheet("Sheet 1") ///
	cellrange(A12:Z21) firstrow

keep country AB CF F
drop if country == "France"
gen CE = CF - F
drop CF

// Aggregate on country level
foreach v in AB CE F {
	egen emp_base_`v' = total(`v')
	drop `v'
}

drop country
duplicates drop
order emp_base_F, last

// Add id variable for merge
gen id = _n

save "clean_data/emp_countries.dta", replace
cd "/Users/aml/AutoEmp/do_files"

log close
