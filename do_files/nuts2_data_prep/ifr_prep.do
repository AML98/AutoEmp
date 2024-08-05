clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/nuts2_fr_prep.txt", replace

import excel "raw_data/ifr/IFR_data_new.xlsx", sheet("Sheet2") firstrow
save "raw_data/ifr/nuts2_IFR_data.dta", replace

***
*** 1) Long differences in robot stock for instrument countries
***

// Remove unnecessary observations
keep if Year == 2001 | Year == 2016
drop if country == "France" | industrycode == "D"

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
	rename `var' diff_robots_`var'
}

gen id = _n

tempfile robots_inst_countries
save `robots_inst_countries'
clear

***
*** 2) Long differences in robot stock for the US
***

import excel "raw_data/ifr/IFR_data_new.xlsx", sheet("Sheet3") firstrow

// Remove unnecessary observations
keep if Year == 2004 | Year == 2016
drop if industrycode == "D"
replace industrycode = "ind" + industrycode if industrycode != "A_B" & ///
	industrycode != "C" & industrycode != "E" & industrycode != "F"
replace industrycode = "AB" if industrycode == "A_B"

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
	
drop if Year == 2004
drop Year robot_stock
sxpose, clear force firstnames destring

foreach var of varlist _all {
	rename `var' us_diff_robots_`var'
}

gen id = _n

tempfile robots_us
save `robots_us'
clear

***
*** 3) Long differences in robot stock for France
***

use "raw_data/ifr/nuts2_IFR_data.dta"

// Remove unnecessary observations
keep if Year == 2001 | Year == 2004 | Year == 2016
keep if country == "France"
drop if industrycode == "D"

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

tempfile temp
save `temp'

// Compute long differences and transpose (2004-2016)
by industrycode (Year), sort: ///
	gen diff_robot_stock_04 = robot_stock - robot_stock[_n-1] if Year == 2016

drop if Year == 2001 | Year == 2004
drop Year robot_stock
sxpose, clear force firstnames destring

foreach var of varlist _all {
	rename `var' fr_diff_robots_04_`var'
}

gen id = 1

tempfile diff04
save `diff04'
clear

use `temp'

// Compute long differences and transpose (2001-2016)
by industrycode (Year), sort: ///
	gen diff_robot_stock_01 = robot_stock - robot_stock[_n-2] if Year == 2016

drop if Year == 2001 | Year == 2004
drop Year robot_stock
sxpose, clear force firstnames destring

foreach var of varlist _all {
	rename `var' fr_diff_robots_01_`var'
}

gen id = 1

***
*** 4) Merge into one data set
***

merge 1:1 id using `diff04'
drop _merge

merge 1:1 id using `robots_inst_countries'
drop _merge

merge 1:1 id using `robots_us'
drop _merge

save "clean_data/nuts2_diff_robots", replace
cd "/Users/aml/AutoEmp/do_files/nuts2_data_prep"
log close
