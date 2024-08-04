clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/nuts2_merge.txt", replace

use "clean_data/nuts2_emp_regions.dta"

// Merge
merge m:1 id using "clean_data/nuts2_emp_countries.dta", update
drop _merge

merge m:1 id using "clean_data/nuts2_diff_robots.dta", update
drop _merge

// Compute long differences
gen robot_exposure = 0
gen frobot_exposure = 0

local varlist ind10_12 ind13_15 ind16 ind17_18 ind19_22 ind23 ind24_25 ind26_27 ///
	ind28 ind29_30 ind91 AB C E F

foreach industry of local varlist {
	
	// 1) Robot exposure for instrument countries
	gen robot_exposure_`industry' = emp_share_`industry' * ///
		(diff_robots_`industry' / emp_base_`industry')
	replace robot_exposure = robot_exposure + robot_exposure_`industry'
	
	// 2) Robot exposure for France
	gen frobot_exposure_`industry' = emp_share_`industry' * ///
		(fr_diff_robots_`industry' / fr_emp_base_`industry')
	replace frobot_exposure = frobot_exposure + frobot_exposure_`industry'
}

// Compute long difference in employment to population
gen diff_emp_to_pop = total_emp_2016 - total_emp_2001

keep region_code region diff_emp_to_pop robot_exposure robot_exposure_* ///
	frobot_exposure frobot_exposure_*
order region_code region diff_emp_to_pop robot_exposure robot_exposure_* ///
	frobot_exposure frobot_exposure_*

save "clean_data/nuts2_reg_ready.dta", replace
cd "/Users/aml/AutoEmp/do_files/nuts2_data_prep"
log close
