clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/ifr_prep.txt", replace

import excel "raw_data/ifr/IFR_data_new.xlsx", sheet("Sheet1") firstrow
save "raw_data/ifr/IFR_data_new.dta", replace

// 1) Remove unnecessary observations
keep if Year == 1999 | Year == 2008
drop if industrycode == "P"
drop if country == "France"

// 2) Aggregagte on country level
sort industrycode Year
by industrycode Year: egen robot_stock = total(op_stock) 
drop delivered op_stock country countrycode
duplicates drop Year industrycode, force

// 3) Aggregate on industry level
replace industrycode = "CE" if ///
	industrycode == "C" | industrycode == "D" | industrycode == "E"
	
collapse (sum) robot_stock, by(Year industrycode)

// 4) Compute long differences and transpose
by industrycode (Year), sort: ///
	gen diff_robot_stock = robot_stock - robot_stock[_n-1]

drop if Year == 1999
drop Year robot_stock
sxpose, clear force firstnames destring

foreach v in AB CE F {
	rename `v' diff_robot_stock_`v'
}

// 5) Add id variable for merge
gen id = _n

save "clean_data/foreign_diff_robot_stock", replace
cd "/Users/aml/AutoEmp/do_files"

log close

