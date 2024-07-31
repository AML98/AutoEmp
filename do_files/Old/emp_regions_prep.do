clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/emp_regions_prep.txt", replace

import excel "raw_data/eurostat/emp_regions.xlsx", sheet("Sheet 1") ///
	cellrange(A13:N40) firstrow

drop GEOLabels
keep region_code AB CE F yr_1999 yr_2008
drop if missing(AB) | missing(CE) | missing(F)

foreach v in AB CE F {
	
	// i) Employment shares
	gen emp_share_`v' = `v' / `v'[1]
	drop `v'
	
	// ii) Variables for merge
	gen emp_base_`v' = .
	gen diff_robot_stock_`v' = .
}

// Drop entire France
drop if _n == 1


// Prep for merge
gen id = 1

// Outcome variable
gen diff_emp_regions = yr_2008 - yr_1999
drop yr_1999 yr_2008

save "clean_data/emp_regions.dta", replace
cd "/Users/aml/AutoEmp/do_files"

log close
