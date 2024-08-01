clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/emp_regions_prep.txt", replace

***
*** 1) Prepare data for year 2016 (sheet 22)
***

import excel "raw_data/eurostat/emp_regions.xlsx", sheet("Sheet 22") ///
	cellrange(A12:G114) firstrow	

tempfile emp_regions_2016
drop if _n == 1 // Drop France as an observation
destring total_emp_2016, replace	
save `emp_regions_2016'
clear

***
*** 2) Prepare data for year 2000 (sheet 6)
***

import excel "raw_data/eurostat/emp_regions.xlsx", sheet("Sheet 6") ///
	cellrange(A12:G114) firstrow

drop if missing(total_emp_2000) | missing(agri_forest_fish) | ///
	missing(industry_ex_construct) | missing(manufact) | missing(construct)

destring total_emp_2000, replace
gen other_industry = industry_ex_construct - manufact
drop industry_ex_construct
drop if _n == 1
	
foreach v in agri_forest_fish manufact construct other_industry {
	
	// 1) Employment shares
	gen emp_share_`v' = `v' / total_emp_2000
	drop `v'
	
	// 2) Variables for merge later
	gen emp_base_`v' = .
	gen diff_robots_`v' = .
}

***
*** 3) Merge data for years 2000 and 2016
***

merge 1:1 region_code using `emp_regions_2016', keepusing(total_emp_2016)
drop if _merge == 2
drop _merge

// Add id variable for merge later
gen id = 1

save "clean_data/emp_regions.dta", replace
cd "/Users/aml/AutoEmp/do_files"
log close
