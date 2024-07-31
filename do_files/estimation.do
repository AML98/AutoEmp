clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/estimation.txt", replace

use "clean_data/reg_ready.dta"

// Reduced form regressions
regress diff_emp_to_pop robot_exposure female_share FR*, noconstant
twoway (scatter diff_emp_to_pop robot_exposure) ///
	(lfit diff_emp_to_pop robot_exposure)

/*
regress diff_emp_regions robot_exposure_F
twoway (scatter diff_emp_regions robot_exposure_F) ///
	(lfit diff_emp_regions robot_exposure_F)

regress diff_emp_regions robot_exposure_CE
twoway (scatter diff_emp_regions robot_exposure_CE) ///
	(lfit diff_emp_regions robot_exposure_CE)
*/

cd "/Users/aml/AutoEmp/do_files"

log close
