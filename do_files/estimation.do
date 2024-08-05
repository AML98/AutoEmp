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

*** i) Employment to population

// EU countries
regress diff_emp_to_pop_01 robot_exposure import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US
regress diff_emp_to_pop_04 usrobot_exposure import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 
	
*** ii) Wages to employment

// EU countries
regress diff_log_wages_01 robot_exposure import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US
regress diff_log_wages_04 usrobot_exposure import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 
	
***
*** 3) Two-stage least squares estimation
***	

*** i) Employment to population

// EU countries
ivregress 2sls diff_emp_to_pop_01 (frobot_exposure_01 = robot_exposure) ///
	import_exposure population_2001 female_share bachelor_share ///
	high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US
ivregress 2sls diff_emp_to_pop_04 (frobot_exposure_04 = usrobot_exposure) ///
	import_exposure population_2001 female_share bachelor_share ///
	high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 
	
** ii) Wages to employment

// EU countries
ivregress 2sls diff_log_wages_01 (frobot_exposure_01 = robot_exposure) ///
	import_exposure population_2001 female_share bachelor_share ///
	high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US
ivregress 2sls diff_log_wages_04 (frobot_exposure_04 = usrobot_exposure) ///
	import_exposure population_2001 female_share bachelor_share ///
	high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

cd "/Users/aml/AutoEmp/do_files"
log close
