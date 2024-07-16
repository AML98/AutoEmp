clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/ifr_prep.txt", replace

import excel "raw_data/ifr/IFR_data_new.xlsx", sheet("Sheet1") firstrow
save "raw_data/ifr/IFR_data_new.dta", replace

keep if Year == 1999 | Year == 2016
drop if industrycode == "P"
sort industrycode Year

by industrycode Year: egen total_stock_industry = total(op_stock) 
drop delivered op_stock country countrycode
duplicates drop Year industrycode, force

replace industrycode = "CE" if industrycode == "C" | industrycode == "D" | industrycode == "E"
collapse (sum) total_stock_industry, by(Year industrycode)
save "clean_data/foreign_robot_stock"
cd "/Users/aml/AutoEmp/do_files"

log close

