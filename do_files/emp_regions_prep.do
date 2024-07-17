clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/emp_regions_prep.txt", replace

import excel "raw_data/eurostat/emp_regions.xlsx", sheet("Sheet 1") ///
	cellrange(A13:L40) firstrow

drop GEOLabels
keep region_code AB CE F
drop if missing(AB) | missing(CE) | missing(F)

foreach v in AB CE F {
	
	// 1) Employment shares
	gen emp_share_`v' = `v' / `v'[1]
	drop `v'
	
	// 2) Variables for merge
	gen emp_base_`v' = .
	gen diff_robot_stock_`v' = .
}

drop if _n == 1

// Add id variable for merge
gen id = 1

save "clean_data/emp_regions.dta", replace
cd "/Users/aml/AutoEmp/do_files"

log close
