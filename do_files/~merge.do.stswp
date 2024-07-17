clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/merge.txt", replace

use "clean_data/emp_regions.dta"

// Merge
merge m:1 id using "clean_data/emp_countries.dta", update
drop _merge

merge m:1 id using "clean_data/foreign_diff_robot_stock.dta", update
drop _merge id

gen robot_exposure = 0

// Create robot exposure
foreach industry in AB CE F {
	gen robot_exposure_`industry' = emp_share_`industry' * ///
		(diff_robot_stock_`industry' / emp_base_`industry')
	replace robot_exposure = robot_exposure + robot_exposure_`industry'
}

save "clean_data/reg_ready.dta", replace
cd "/Users/aml/AutoEmp/do_files"

log close
