clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/estimation.txt", replace

use "clean_data/nuts2_reg_ready.dta"

// First stage
regress robot_exposure frobot_exposure, noconstant
twoway (scatter robot_exposure frobot_exposure) ///
	(lfit robot_exposure frobot_exposure)

// Reduced form regressions
regress diff_emp_to_pop robot_exposure import_exposure population_2001 
	female_share bachelor_share high_school_share ///
	[w=working_age_pop], noconstant 
	
// 2 stage least squares estimation
ivregress 2sls diff_emp_to_pop (frobot_exposure = robot_exposure) ///
	import_exposure population_2001 female_share bachelor_share ///
	high_school_share [w=working_age_pop], noconstant 

cd "/Users/aml/AutoEmp/do_files"
log close
