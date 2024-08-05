clear
cd "$mydir"
log using "logs/estimation.txt", replace 

use "clean_data/nuts2_reg_ready.dta"

***
*** 1) First stage
***

// EU countries
regress robot_exposure frobot_exposure_01, noconstant
twoway (scatter robot_exposure frobot_exposure_01, ///
       mcolor(black) msymbol(circle) msize(small)) ///
       (lfit robot_exposure frobot_exposure_01, lcolor(black) lwidth(medium)), ///
	   xtitle("French Robot Exposure") ytitle("EU Countries Robot Exposure") ///
	   xlabel(, labsize(medium)) ylabel(, labsize(medium)) ///
       plotregion(style(none)) bgcolor(white) ///
       legend(off) graphregion(color(white)) ///
       subtitle("First Stage Regression") ///
	 
graph export "plots/first_stage_EU.png", replace
	
// The US
regress usrobot_exposure frobot_exposure_04, noconstant
twoway (scatter usrobot_exposure frobot_exposure_04, ///
       mcolor(black) msymbol(circle) msize(small)) ///
       (lfit usrobot_exposure frobot_exposure_04, lcolor(black) lwidth(medium)), ///
	   xtitle("French Robot Exposure") ytitle("US Robot Exposure") ///
	   xlabel(, labsize(medium)) ylabel(, labsize(medium)) ///
       plotregion(style(none)) bgcolor(white) ///
       legend(off) graphregion(color(white)) ///
       subtitle("First Stage Regression") ///

graph export "plots/first_stage_US.png", replace

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

cd "$mydir/do_files"
log close
