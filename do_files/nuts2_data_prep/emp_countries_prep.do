clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/nuts2_emp_countries_prep.txt", replace

***
*** 1) Combine LFS and SBS data for 2001
***

import excel "raw_data/eurostat/nuts2_emp_countries_lfs.xlsx", sheet("Sheet 2") ///
	cellrange(A13:D19) firstrow
	
drop total_emp_2000
tempfile lfs_emp
save `lfs_emp'
clear

import excel "raw_data/eurostat/nuts2_emp_countries_sbs.xlsx", sheet("Sheet 6") ///
	cellrange(A38:Q44) firstrow

merge 1:1 country_code using `lfs_emp'
drop _merge

tempfile lfs_sbs_emp
save `lfs_sbs_emp', replace
clear

***
*** 2) Combine FRED data for for US
***

import excel "raw_data/fred/us_emp_agri.xls", ///
	cellrange(A11:B45) firstrow

tempfile agri
save `agri'
clear	
	
import excel "raw_data/fred/us_emp_ex_agri.xls", ///
	cellrange(A70:P104) firstrow

merge 1:1 yr using `agri'
drop _merge

keep if yr == 2001
drop D yr

tempfile us_emp
save `us_emp'
clear 

***
*** 3) National employment for instrument countries
***

// i) EU countries

use `lfs_sbs_emp'

local varlist ind10_12 ind13_15 ind16 ind17_18 ind19_22 ind23 ind24_25 ind26_27 ///
	ind28 ind29_30 ind91 AB C E F

foreach var of local varlist {
	egen emp_base_`var' = total(`var')
	drop `var'
}

drop country country_code D
duplicates drop
gen id = 1

save `lfs_sbs_emp', replace
clear

// ii) United States

use `us_emp'

local varlist ind10_12 ind13_15 ind16 ind17_18 ind19_22 ind23 ind24_25 ind26_27 ///
	ind28 ind29_30 ind91 AB C E F

foreach var of local varlist {
	rename `var' us_emp_base_`var'
}

gen id = 1

// iii) Combine data for US and EU

merge 1:1 id using `lfs_sbs_emp'
drop _merge

order emp_base_* us_emp_base_ind10_12 us_emp_base_ind13_15 us_emp_base_ind16 ///
	us_emp_base_ind17_18 us_emp_base_ind19_22 us_emp_base_ind23 ///
	us_emp_base_ind24_25 us_emp_base_ind26_27 us_emp_base_ind28 ///
	us_emp_base_ind29_30 us_emp_base_ind91 us_emp_base_AB ///
	us_emp_base_C us_emp_base_E us_emp_base_F

save "clean_data/nuts2_emp_countries.dta", replace
cd "/Users/aml/AutoEmp/do_files/nuts2_data_prep"
log close
