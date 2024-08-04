clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/merge.txt", replace

use "clean_data/emp_regions.dta"

// Merge
merge m:1 id using "clean_data/emp_countries.dta", update
drop _merge

merge m:1 id using "clean_data/diff_robots.dta", update
drop _merge

merge m:1 id using "clean_data/diff_imports.dta", update
drop _merge id

merge m:1 region_code using "clean_data/demographics.dta"
drop if _merge == 1 | _merge == 2
drop _merge

// Compute long differences
gen robot_exposure = 0
gen frobot_exposure = 0
gen import_exposure = 0

foreach industry in agri_forest_fish manufact construct other_industry {
	
	// 1) Robot exposure for instrument countries
	gen robot_exposure_`industry' = emp_share_`industry' * ///
		(diff_robots_`industry' / emp_base_`industry')
	replace robot_exposure = robot_exposure + robot_exposure_`industry'
	
	// 2) Robot exposure for France
	gen frobot_exposure_`industry' = emp_share_`industry' * ///
		(fr_diff_robots_`industry' / fr_emp_base_`industry')
	replace frobot_exposure = frobot_exposure + frobot_exposure_`industry'
	
	// 3) Import exposure
	gen import_exposure_`industry' = imp_emp_share_`industry' * ///
		(diff_imp_`industry' / imp_emp_base_`industry')
	replace import_exposure = import_exposure + import_exposure_`industry'
}

// Compute long difference in employment to population
gen diff_emp_to_pop = total_emp_2016/population_2016 - total_emp_2000/population_2000

keep region_code region diff_emp_to_pop robot_exposure ///
	robot_exposure_agri_forest_fish robot_exposure_manufact ///
	robot_exposure_construct robot_exposure_other_industry female_share ///
	import_exposure import_exposure_agri_forest_fish import_exposure_manufact ///
	import_exposure_construct import_exposure_other_industry working_age_pop ///
	population_2000 high_school_share bachelor_share FR* frobot_exposure

save "clean_data/reg_ready.dta", replace
cd "/Users/aml/AutoEmp/do_files/nuts3_data_prep"
log close
