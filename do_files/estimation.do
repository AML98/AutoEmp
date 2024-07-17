clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/estimation.txt", replace

use "clean_data/reg_ready.dta"

// Test regressions
regress emp_total robot_exposure
twoway (scatter emp_total robot_exposure) (lfit emp_total robot_exposure)

regress emp_total robot_exposure_F
twoway (scatter emp_total robot_exposure_F) (lfit emp_total robot_exposure_F)

regress emp_total robot_exposure_CE
twoway (scatter emp_total robot_exposure_CE) (lfit emp_total robot_exposure_CE)

cd "/Users/aml/AutoEmp/do_files"

log close