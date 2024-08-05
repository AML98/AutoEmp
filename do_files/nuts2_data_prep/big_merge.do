clear
cd "$mydir"
log using "logs/nuts2_merge.txt", replace

use "clean_data/nuts2_emp_regions.dta"

// Merge
merge 1:1 region_code using "clean_data/nuts2_demographics.dta"
drop _merge

merge 1:1 region_code using "clean_data/nuts2_wages.dta"
drop _merge

merge m:1 id using "clean_data/nuts2_emp_countries.dta", update
drop _merge

merge m:1 id using "clean_data/nuts2_diff_robots.dta", update
drop _merge

merge m:1 id using "clean_data/nuts2_diff_imports.dta", update
drop _merge id

// Compute long differences
gen robot_exposure = 0
gen frobot_exposure_01 = 0 // 2001-2016 diff
gen frobot_exposure_04 = 0 // 2004-2016 diff
gen usrobot_exposure = 0
gen import_exposure = 0

local varlist ind10_12 ind13_15 ind16 ind17_18 ind19_22 ind23 ind24_25 ind26_27 ///
	ind28 ind29_30 ind91 AB C E F

foreach industry of local varlist {
	
	// 1) Robot exposure for EU instrument countries (2001-2016)
	gen robot_exposure_`industry' = emp_share_`industry' * ///
		(diff_robots_`industry' / emp_base_`industry')
	replace robot_exposure = robot_exposure + robot_exposure_`industry'
	
	// 2) Robot exposure for US as instrument (2004-2016)
	gen usrobot_exposure_`industry' = emp_share_`industry' * ///
		(us_diff_robots_`industry' / us_emp_base_`industry')
	replace usrobot_exposure = usrobot_exposure + usrobot_exposure_`industry'
	
	// 3) Robot exposure for France (2001-2016)
	gen frobot_exposure_01_`industry' = emp_share_`industry' * ///
		(fr_diff_robots_01_`industry' / fr_emp_base_`industry')
	replace frobot_exposure_01 = frobot_exposure_01 + frobot_exposure_01_`industry'
	
	// 4) Robot exposure for France (2004-2016)
	gen frobot_exposure_04_`industry' = emp_share_`industry' * ///
		(fr_diff_robots_04_`industry' / fr_emp_base_`industry')
	replace frobot_exposure_04 = frobot_exposure_04 + frobot_exposure_04_`industry'
	
	// 5) Import exposure (2012-2016)
	gen import_exposure_`industry' = emp_share_`industry' * ///
		(diff_imp_`industry' / fr_emp_base_`industry')
	replace import_exposure = import_exposure + import_exposure_`industry'
}

// Compute long difference in employment to population
gen diff_emp_to_pop_01 = total_emp_2016/population_2016 - ///
	total_emp_2001/population_2001
	
gen diff_emp_to_pop_04 = total_emp_2016/population_2016 - ///
	total_emp_2004/population_2004
	
gen diff_wages_to_emp_01 = wages_2016/total_emp_2016 - ///
	wages_2001/total_emp_2001
	
gen diff_wages_to_emp_04 = wages_2016/total_emp_2016 - ///
	wages_2004/total_emp_2004
	
gen diff_log_wages_01 = log_wages_2016 - log_wages_2001
gen diff_log_wages_04 = log_wages_2016 - log_wages_2004
	
keep region_code region diff_* robot_exposure robot_exposure_* ///
	frobot_exposure_* usrobot_exposure usrobot_exposure_* import_exposure ///
	import_exposure_* population_2001 working_age_pop female_share ///
	high_school_share bachelor_share emp_share_D emp_share_F FR*
	
order region_code region diff_* robot_exposure robot_exposure_* ///
	frobot_exposure_* usrobot_exposure usrobot_exposure_* import_exposure ///
	import_exposure_* population_2001 working_age_pop female_share ///
	high_school_share bachelor_share emp_share_D emp_share_F FR*

save "clean_data/nuts2_reg_ready.dta", replace
cd "$mydir/do_files/nuts2_data_prep"
log close
