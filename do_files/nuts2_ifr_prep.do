clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/nuts2_fr_prep.txt", replace

import excel "raw_data/ifr/IFR_data_new.xlsx", sheet("Sheet2") firstrow
save "raw_data/ifr/nuts2_IFR_data.dta", replace



***
*** 1) Long differences in robot stock for instrument countries
***

tempfile robots_inst_countries

// Remove unnecessary observations
keep if Year == 2001 | Year == 2016
drop if country == "France"

// Aggregagte on country level
sort industrycode Year
by industrycode Year: egen robot_stock = total(op_stock) 
drop delivered op_stock country countrycode
duplicates drop Year industrycode, force

// Aggregate on industry level
replace industrycode = "ind24_25" if ///
	industrycode == "ind24" | industrycode == "ind25"
collapse (sum) robot_stock, by(Year industrycode)

replace industrycode = "ind29_30" if ///
	industrycode == "ind29" | industrycode == "ind30"
collapse (sum) robot_stock, by(Year industrycode)

// Compute long differences and transpose
by industrycode (Year), sort: ///
	gen diff_robot_stock = robot_stock - robot_stock[_n-1]

drop if Year == 2001
drop Year robot_stock
sxpose, clear force firstnames destring

// Add id variable for merge
gen id = _n

save `robots_inst_countries'
clear

***
*** 2) Long differences in robot stock for instrument countries
***

use "raw_data/ifr/nuts2_IFR_data.dta"

// Remove unnecessary observations
keep if Year == 2001 | Year == 2016
keep if country == "France"

// Aggregagte on country level
sort industrycode Year
by industrycode Year: egen robot_stock = total(op_stock) 
drop delivered op_stock country countrycode
duplicates drop Year industrycode, force

// Aggregate on industry level
replace industrycode = "ind24_25" if ///
	industrycode == "ind24" | industrycode == "ind25"
collapse (sum) robot_stock, by(Year industrycode)

replace industrycode = "ind29_30" if ///
	industrycode == "ind29" | industrycode == "ind30"
collapse (sum) robot_stock, by(Year industrycode)

// Compute long differences and transpose
by industrycode (Year), sort: ///
	gen diff_robot_stock = robot_stock - robot_stock[_n-1]

drop if Year == 2001
drop Year robot_stock
sxpose, clear force firstnames destring

foreach var of varlist _all {
	rename `var' fr_`var'
}

// Add id variable for merge
gen id = _n

***
*** 3) Merge into one data set
***

merge 1:1 id using `robots_inst_countries'
drop _merge

save "clean_data/nuts2_diff_robots", replace
cd "/Users/aml/AutoEmp/do_files"
log close

