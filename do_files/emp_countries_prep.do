clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/emp_countries_prep.txt", replace

***
*** 1) National employment for instrument countries in year 2000 (Sheet 9)
***

import excel "raw_data/eurostat/emp_countries.xlsx", sheet("Sheet 9") ///
	cellrange(A12:F21) firstrow

tempfile emp_inst_countries

drop if country == "France"
keep country agri_forest_fish industry manufact construct
gen other_industry = industry - manufact - construct
drop industry

foreach v in agri_forest_fish manufact construct other_industry {
	egen emp_base_`v' = total(`v')
	drop `v'
}

drop country
duplicates drop

// Add id variable for merge
gen id = _n

save `emp_inst_countries'
clear

***
*** 2) National employment for France in year 2000 (Sheet 9)
***

import excel "raw_data/eurostat/emp_countries.xlsx", sheet("Sheet 9") ///
	cellrange(A12:F21) firstrow
	
keep if country == "France"
keep country agri_forest_fish industry manufact construct
gen other_industry = industry - manufact - construct
drop industry

foreach v in agri_forest_fish manufact construct other_industry {
	rename `v' fr_emp_base_`v'
}

drop country

// Add id variable for merge
gen id = _n

***
*** 3) Merge into one data set
***

merge 1:1 id using `emp_inst_countries'
drop _merge

save "clean_data/emp_countries.dta", replace
cd "/Users/aml/AutoEmp/do_files"

log close
