clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/estimation.txt", replace

use "clean_data/nuts2_reg_ready.dta"

***
*** 1) First stage
***

// EU countries
regress robot_exposure frobot_exposure_01, noconstant
twoway (scatter robot_exposure frobot_exposure_01) ///
	(lfit robot_exposure frobot_exposure_01)
	
// The US
regress usrobot_exposure frobot_exposure_04, noconstant
twoway (scatter robot_exposure frobot_exposure_04) ///
	(lfit robot_exposure frobot_exposure_04)

***
*** 2) Reduced form regressions
***

// EU countries
regress diff_emp_to_pop_01 robot_exposure import_exposure population_2001 ///
	female_share bachelor_share high_school_share ///
	[w=working_age_pop], noconstant 

// The US
regress diff_emp_to_pop_04 usrobot_exposure import_exposure population_2001 ///
	female_share bachelor_share high_school_share ///
	[w=working_age_pop], noconstant 
	
***
*** 3) Two-stage least squares estimation
***	

// EU countries
ivregress 2sls diff_emp_to_pop_01 (frobot_exposure_01 = robot_exposure) ///
	import_exposure population_2001 female_share bachelor_share ///
	high_school_share [w=working_age_pop], noconstant 

// The US
ivregress 2sls diff_emp_to_pop_04 (frobot_exposure_04 = usrobot_exposure) ///
	import_exposure population_2001 female_share bachelor_share ///
	high_school_share [w=working_age_pop], noconstant 

cd "/Users/aml/AutoEmp/do_files"
log close
