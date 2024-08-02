clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/emp_regions_prep.txt", replace

***
*** 1) Employment data for import exposure in year 2012 (sheet 18)
***

// i) National employment (employment base)
import excel "raw_data/eurostat/emp_regions.xlsx", sheet("Sheet 18") ///
	cellrange(A12:G114) firstrow

tempfile emp_France_2012

destring total_emp_2012, replace
gen other_industry = industry_ex_construct - manufact
drop industry_ex_construct
keep if _n == 1
gen id = 1

foreach v in agri_forest_fish manufact construct other_industry {
	rename `v' imp_emp_base_`v'
}

save `emp_France_2012'
clear

// ii) Regional employment (employment shares)
import excel "raw_data/eurostat/emp_regions.xlsx", sheet("Sheet 18") ///
	cellrange(A12:G114) firstrow
	
tempfile emp_regions_2012

drop if missing(total_emp_2012) | missing(agri_forest_fish) | ///
	missing(industry_ex_construct) | missing(manufact) | missing(construct)

destring total_emp_2012, replace
gen other_industry = industry_ex_construct - manufact
drop industry_ex_construct
drop if _n == 1

foreach v in agri_forest_fish manufact construct other_industry {
	gen imp_emp_share_`v' = `v' / total_emp_2012
	drop `v'
}

save `emp_regions_2012'
clear

***
*** 2) Regional employment data for outcome in year 2016 (sheet 22)
***

import excel "raw_data/eurostat/emp_regions.xlsx", sheet("Sheet 22") ///
	cellrange(A12:G114) firstrow	

tempfile emp_regions_2016
drop if _n == 1 // Drop France as an observation
destring total_emp_2016, replace	
save `emp_regions_2016'
clear

***
*** 3) Regional employment data for outcome and robot exposure in year 2000 (sheet 6)
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
	
	// i) Employment shares
	gen emp_share_`v' = `v' / total_emp_2000
	drop `v'
	
	// ii) Variables for merge later
	gen emp_base_`v' = .
	gen diff_robots_`v' = .
}

***
*** 4) Merge into one data set
***

// Add id variable for merge
gen id = 1

merge 1:1 region_code using `emp_regions_2016', keepusing(total_emp_2016)
drop if _merge == 2
drop _merge

merge 1:1 region_code using `emp_regions_2012', keepusing( ///
	imp_emp_share_agri_forest_fish imp_emp_share_manufact ///
	imp_emp_share_construct imp_emp_share_other_industry)
drop if _merge == 2
drop _merge

merge m:1 id using `emp_France_2012', keepusing(imp_emp_base_agri_forest_fish ///
	imp_emp_base_manufact imp_emp_base_construct imp_emp_base_other_industry id)
drop _merge

save "clean_data/emp_regions.dta", replace
cd "/Users/aml/AutoEmp/do_files"
log close
