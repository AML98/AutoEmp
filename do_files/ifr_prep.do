clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/ifr_prep.txt", replace

import excel "raw_data/ifr/IFR_data_new.xlsx", sheet("Sheet1") firstrow
save "raw_data/ifr/IFR_data_new.dta", replace

***
*** 1) Long differences in robot stock for instrument countries
***

tempfile robots_inst_countries

// Remove unnecessary observations
keep if Year == 2000 | Year == 2016
drop if industrycode == "P"
drop if country == "France"

// Aggregagte on country level
sort industrycode Year
by industrycode Year: egen robot_stock = total(op_stock) 
drop delivered op_stock country countrycode
duplicates drop Year industrycode, force

// Aggregate on industry level
replace industrycode = "CE" if ///
	industrycode == "C" | industrycode == "E"
collapse (sum) robot_stock, by(Year industrycode)

// Compute long differences and transpose
by industrycode (Year), sort: ///
	gen diff_robot_stock = robot_stock - robot_stock[_n-1]

drop if Year == 2000
drop Year robot_stock
sxpose, clear force firstnames destring

// Rename
rename AB diff_robots_agri_forest_fish
rename CE diff_robots_other_industry
rename D diff_robots_manufact
rename F diff_robots_construct

// Add id variable for merge
gen id = _n

save `robots_inst_countries'
clear

***
*** 2) Long differences in robot stock for instrument countries
***

use "raw_data/ifr/IFR_data_new.dta"

// Remove unnecessary observations
keep if Year == 2000 | Year == 2016
drop if industrycode == "P"
keep if country == "France"

// Aggregagte on country level
sort industrycode Year
by industrycode Year: egen robot_stock = total(op_stock) 
drop delivered op_stock country countrycode
duplicates drop Year industrycode, force

// Aggregate on industry level
replace industrycode = "CE" if ///
	industrycode == "C" | industrycode == "E"
collapse (sum) robot_stock, by(Year industrycode)

// Compute long differences and transpose
by industrycode (Year), sort: ///
	gen diff_robot_stock = robot_stock - robot_stock[_n-1]

drop if Year == 2000
drop Year robot_stock
sxpose, clear force firstnames destring

// Rename
rename AB fr_diff_robots_agri_forest_fish
rename CE fr_diff_robots_other_industry
rename D fr_diff_robots_manufact
rename F fr_diff_robots_construct

// Add id variable for merge
gen id = _n

***
*** 3) Merge into one data set
***

merge 1:1 id using `robots_inst_countries'
drop _merge

save "clean_data/diff_robots", replace
cd "/Users/aml/AutoEmp/do_files"

log close

