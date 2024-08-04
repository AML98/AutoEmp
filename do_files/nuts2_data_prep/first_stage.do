clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/nuts2_first_stage.txt", replace

use "clean_data/nuts2_emp_regions.dta"
keep fr_emp_base_*

tempfile tem_fr_emp_base
xpose, clear
gen id = _n
rename v1 fr_emp_base
save `tem_fr_emp_base'
clear

use "clean_data/nuts2_emp_countries.dta"
keep emp_base_*

tempfile tem_emp_base
xpose, clear
gen id = _n
rename v1 emp_base
save `tem_emp_base'
clear

foreach v in fr_diff_robots diff_robots {
	
	use "clean_data/nuts2_diff_robots.dta"
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

drop if _n == 3

regress diff_fr_robots_to_pop diff_robots_to_pop
twoway (scatter diff_fr_robots_to_pop diff_robots_to_pop) ///
	(lfit diff_fr_robots_to_pop diff_robots_to_pop)

save "clean_data/first_stage.dta", replace
cd "/Users/aml/AutoEmp/do_files/nuts2_data_prep"
log close
