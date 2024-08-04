clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/nuts2_emp_countries_prep.txt", replace

***
*** 1) Combine LFS and SBS data
***

import excel "raw_data/eurostat/nuts2_emp_countries_lfs.xlsx", sheet("Sheet 2") ///
	cellrange(A13:D19) firstrow
	
tempfile lfs_emp
drop total_emp_2000
save `lfs_emp'
clear

import excel "raw_data/eurostat/nuts2_emp_countries_sbs.xlsx", sheet("Sheet 6") ///
	cellrange(A38:Q44) firstrow

tempfile lfs_sbs_emp

merge 1:1 country_code using `lfs_emp'
drop _merge

***
*** 2) National employment for instrument countries in year 2000
***

local varlist ind10_12 ind13_15 ind16 ind17_18 ind19_22 ind23 ind24_25 ind26_27 ///
	ind28 ind29_30 ind91 AB C E F

foreach var of local varlist {
	egen emp_base_`var' = total(`var')
	drop `var'
}

drop country country_code D
duplicates drop
gen id = 1

save "clean_data/nuts2_emp_countries.dta", replace
cd "/Users/aml/AutoEmp/do_files/nuts2_data_prep"
log close
