clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/first_stage.txt", replace

foreach v in fr_emp_base emp_base {
	
	use "clean_data/emp_countries.dta"
	keep `v'_*

	tempfile tem_`v'
	xpose, clear
	gen id = _n
	rename v1 `v'
	save `tem_`v''
	clear
}

foreach v in fr_diff_robots diff_robots {
	
	use "clean_data/diff_robots.dta"
	keep `v'_*

	tempfile tem_`v'
	xpose, clear
	gen id = _n
	rename v1 `v'
	save `tem_`v''
	clear
}

use `tem_fr_emp_base'

merge 1:1 id using `tem_emp_base'
drop _merge

merge 1:1 id using `tem_fr_diff_robots'
drop _merge

merge 1:1 id using `tem_diff_robots'
drop _merge id

gen diff_robots_to_pop = diff_robots / emp_base
gen diff_fr_robots_to_pop = fr_diff_robots / fr_emp_base 

regress diff_fr_robots_to_pop diff_robots_to_pop
twoway (scatter diff_fr_robots_to_pop diff_robots_to_pop) ///
	(lfit diff_fr_robots_to_pop diff_robots_to_pop)

save "clean_data/first_stage.dta", replace
cd "/Users/aml/AutoEmp/do_files"
log close
