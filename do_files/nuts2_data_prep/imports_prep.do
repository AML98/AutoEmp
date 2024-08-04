clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/imports_prep.txt", replace

import excel "raw_data/eurostat/imports_detailed_industry.xlsx", sheet("Sheet 1") ///
	cellrange(A32:Q43) firstrow	

keep if yr == 2012 | yr == 2016
drop D

local varlist ind10_12 ind13_15 ind16 ind17_18 ind19_22 ind23 ind24_25 ind26_27 ///
	ind28 ind29_30 ind91 AB C E F

foreach var of local varlist {
	gen diff_imp_`var' = `var' - `var'[_n-1]
	format diff_imp_`var' %14.2f
	drop `var'
}

gen id = 1

drop if yr == 2012
drop yr

save "clean_data/nuts2_diff_imports.dta", replace
cd "/Users/aml/AutoEmp/do_files/nuts2_data_prep"
log close
