clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/imports_prep.txt", replace

import excel "raw_data/eurostat/imports.xlsx", sheet("Sheet 1") ///
	cellrange(A14:F25) firstrow	

gen imp_other_industry = imp_industry_ex_construct - imp_manufact
keep if yr == 2012 | yr == 2016
drop imp_industry_ex_construct
drop imp_total

foreach v in imp_agri_forest_fish imp_manufact imp_construct imp_other_industry{
	gen diff_`v' = `v' - `v'[_n-1]
	format diff_`v' %14.2f
	drop `v'
}

gen id = 1

drop if yr == 2012
drop yr

save "clean_data/diff_imports.dta", replace
cd "/Users/aml/AutoEmp/do_files/nuts3_data_prep"
log close
