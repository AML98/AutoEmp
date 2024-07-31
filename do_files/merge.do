clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/merge.txt", replace

use "clean_data/emp_regions.dta"

// Merge
merge m:1 id using "clean_data/emp_countries.dta", update
drop _merge

merge m:1 id using "clean_data/diff_robots.dta", update
drop _merge id

merge m:1 region using "clean_data/demographics.dta"
drop if _merge == 1 | _merge == 2
drop _merge

// Compute long difference in robot exposure
gen robot_exposure = 0

foreach industry in agri_forest_fish manufact construct other_industry {
	gen robot_exposure_`industry' = emp_share_`industry' * ///
		(diff_robots_`industry' / emp_base_`industry')
	replace robot_exposure = robot_exposure + robot_exposure_`industry'
}

// Compute long difference in employment to population
gen diff_emp_to_pop = total_emp_2016/population_2016 - total_emp_2000/population_2000
keep region diff_emp_to_pop robot_exposure robot_exposure_agri_forest_fish ///
	robot_exposure_manufact robot_exposure_construct ///
	robot_exposure_other_industry female_share FR*

save "clean_data/reg_ready.dta", replace
cd "/Users/aml/AutoEmp/do_files"
log close
