clear
cd "$mydir"
log using "logs/estimation.txt", replace 

use "clean_data/nuts2_reg_ready.dta"

***
*** 1) First stage - NUTS 2 ANALYSIS
***

// EU countries
regress robot_exposure frobot_exposure_01, noconstant
twoway (scatter robot_exposure frobot_exposure_01, ///
       mcolor(black) msymbol(circle) msize(small)) ///
       (lfit robot_exposure frobot_exposure_01, lcolor(black) lwidth(medium)), ///
	   xtitle("French Robot Exposure", size(large)) ytitle("EU Countries Robot Exposure", size(large)) ///
	   xlabel(, labsize(large)) ylabel(, labsize(large)) ///
       plotregion(style(none)) bgcolor(white) ///
       legend(off) graphregion(color(white)) ///
	 
graph export "plots/first_stage_EU.png", replace
	
// The US
regress usrobot_exposure frobot_exposure_04, noconstant
twoway (scatter usrobot_exposure frobot_exposure_04, ///
       mcolor(black) msymbol(circle) msize(small)) ///
       (lfit usrobot_exposure frobot_exposure_04, lcolor(black) lwidth(medium)), ///
	   xtitle("French Robot Exposure", size(large)) ytitle("US Robot Exposure", size(large)) ///
	   xlabel(, labsize(large)) ylabel(, labsize(large)) ///
       plotregion(style(none)) bgcolor(white) ///
       legend(off) graphregion(color(white)) ///

graph export "plots/first_stage_US.png", replace

***
*** 2) Reduced form regressions - NUTS 2 ANALYSIS
***

*** i) Employment to population

// EU countries
eststo nuts2_eu_emp: regress diff_emp_to_pop_01 robot_exposure ///
	import_exposure population_2001 female_share bachelor_share ///
	high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US
eststo nuts2_us_emp: regress diff_emp_to_pop_04 usrobot_exposure ///
	import_exposure population_2001 female_share bachelor_share ///
	high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 
	
*** ii) Wages to employment

// EU countries
eststo nuts2_eu_wage: regress diff_log_wages_01 robot_exposure ///
	import_exposure population_2001 female_share bachelor_share ///
	high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US
eststo nuts2_us_wage: regress diff_log_wages_04 usrobot_exposure ///
	import_exposure population_2001 female_share bachelor_share ///
	high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 
	
***
*** 3) Two-stage least squares estimation - NUTS 2 ANALYSIS
***	

*** i) Employment to population

// EU countries
eststo nuts2_iv_eu_emp: ivregress 2sls diff_emp_to_pop_01 ///
	(frobot_exposure_01 = robot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US
eststo nuts2_iv_us_emp: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04 = usrobot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US and EU
eststo nuts2_iv_us_eu_emp: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04 = usrobot_exposure robot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 
	
// Gradually adding control variables - EU countries
eststo nuts2_iv_eu_emp_1: ivregress 2sls diff_emp_to_pop_01 ///
	(frobot_exposure_01 = robot_exposure), ///
	noconstant 
eststo nuts2_iv_eu_emp_2: ivregress 2sls diff_emp_to_pop_01 ///
	(frobot_exposure_01 = robot_exposure) ///
	[w=working_age_pop], noconstant
eststo nuts2_iv_eu_emp_3: ivregress 2sls diff_emp_to_pop_01 ///
	(frobot_exposure_01 = robot_exposure) import_exposure ///
	[w=working_age_pop], noconstant 
eststo nuts2_iv_eu_emp_4: ivregress 2sls diff_emp_to_pop_01 ///
	(frobot_exposure_01 = robot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share ///
	[w=working_age_pop], noconstant 
	
// Gradually adding control variables - The US
eststo nuts2_iv_us_emp_1: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04 = usrobot_exposure), ///
	noconstant 
eststo nuts2_iv_us_emp_2: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04 = usrobot_exposure) ///
	[w=working_age_pop], noconstant
eststo nuts2_iv_us_emp_3: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04 = usrobot_exposure) import_exposure ///
	[w=working_age_pop], noconstant 
eststo nuts2_iv_us_emp_4: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04 = usrobot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share ///
	[w=working_age_pop], noconstant 
	
// Gradually adding control variables - The US and EU
eststo nuts2_iv_us_eu_emp_1: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04 = usrobot_exposure robot_exposure), ///
	noconstant 
eststo nuts2_iv_us_eu_emp_2: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04 = usrobot_exposure robot_exposure) ///
	[w=working_age_pop], noconstant
eststo nuts2_iv_us_eu_emp_3: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04 = usrobot_exposure robot_exposure) import_exposure ///
	[w=working_age_pop], noconstant 
eststo nuts2_iv_us_eu_emp_4: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04 = usrobot_exposure robot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share ///
	[w=working_age_pop], noconstant 
	
** ii) Wages to employment

// EU countries
eststo nuts2_iv_eu_wage: ivregress 2sls diff_log_wages_01 ///
	(frobot_exposure_01 = robot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US
eststo nuts2_iv_us_wage: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04 = usrobot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant
	
// The US and EU
eststo nuts2_iv_us_eu_wage: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04 = usrobot_exposure robot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 
	
// Gradually adding control variables - EU countries
eststo nuts2_iv_eu_wage_1: ivregress 2sls diff_log_wages_01 ///
	(frobot_exposure_01 = robot_exposure), ///
	noconstant 
eststo nuts2_iv_eu_wage_2: ivregress 2sls diff_log_wages_01 ///
	(frobot_exposure_01 = robot_exposure) ///
	[w=working_age_pop], noconstant
eststo nuts2_iv_eu_wage_3: ivregress 2sls diff_log_wages_01 ///
	(frobot_exposure_01 = robot_exposure) import_exposure ///
	[w=working_age_pop], noconstant 
eststo nuts2_iv_eu_wage_4: ivregress 2sls diff_log_wages_01 ///
	(frobot_exposure_01 = robot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share ///
	[w=working_age_pop], noconstant 
	
// Gradually adding control variables - The US
eststo nuts2_iv_us_wage_1: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04 = usrobot_exposure), ///
	noconstant 
eststo nuts2_iv_us_wage_2: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04 = usrobot_exposure) ///
	[w=working_age_pop], noconstant
eststo nuts2_iv_us_wage_3: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04 = usrobot_exposure) import_exposure ///
	[w=working_age_pop], noconstant 
eststo nuts2_iv_us_wage_4: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04 = usrobot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share ///
	[w=working_age_pop], noconstant 	
	
// Gradually adding control variables - The US and EU
eststo nuts2_iv_us_eu_wage_1: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04 = usrobot_exposure robot_exposure), ///
	noconstant 
eststo nuts2_iv_us_eu_wage_2: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04 = usrobot_exposure robot_exposure) ///
	[w=working_age_pop], noconstant
eststo nuts2_iv_us_eu_wage_3: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04 = usrobot_exposure robot_exposure) import_exposure ///
	[w=working_age_pop], noconstant 
eststo nuts2_iv_us_eu_wage_4: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04 = usrobot_exposure robot_exposure) import_exposure population_2001 ///
	female_share bachelor_share high_school_share ///
	[w=working_age_pop], noconstant 
	
*** iii) Robustness check on employment - no automobile industry

// EU countries
eststo nuts2_iv_eu_emp_auto: ivregress 2sls diff_emp_to_pop_01 ///
	(frobot_exposure_01_auto = robot_exposure_auto) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US
eststo nuts2_iv_us_emp: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04_auto = usrobot_exposure_auto) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US and EU
eststo nuts2_iv_us_eu_emp: ivregress 2sls diff_emp_to_pop_04 ///
	(frobot_exposure_04_auto = usrobot_exposure_auto robot_exposure_auto) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 
	
*** iv) Robustness check on wages - no automobile industry

// EU countries
eststo nuts2_iv_eu_wage: ivregress 2sls diff_log_wages_01 ///
	(frobot_exposure_01_auto = robot_exposure_auto) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 

// The US
eststo nuts2_iv_us_wage: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04_auto = usrobot_exposure_auto) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant
	
// The US and EU
eststo nuts2_iv_us_eu_wage: ivregress 2sls diff_log_wages_04 ///
	(frobot_exposure_04_auto = usrobot_exposure_auto robot_exposure_auto) import_exposure population_2001 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F ///
	[w=working_age_pop], noconstant 
	
***
*** 4) Placebo check
*** 
	
// These regions do not have emp data in 1996
drop if region_code == "FR10" | region_code == "FRE1"

regress emp_to_pop_diff_9601 robot_exposure, noconstant
twoway (scatter emp_to_pop_diff_9601 robot_exposure, ///
       mcolor(black) msymbol(circle) msize(small)), ///
	   ytitle("Change in emp.-to-pop. ratio 1996-2001", size(large)) xtitle("Robot exposure using EU instrument 2001-2016", size(large)) ///
	   xlabel(, labsize(large)) ylabel(, labsize(large)) ///
       plotregion(style(none)) bgcolor(white) ///
       legend(off) graphregion(color(white)) ///
	 
graph export "plots/placebo_check_EU.png", replace

regress emp_to_pop_diff_9601 usrobot_exposure, noconstant
twoway (scatter emp_to_pop_diff_9601 usrobot_exposure, ///
       mcolor(black) msymbol(circle) msize(small)), ///
	   ytitle("Change in emp.-to-pop. ratio 1996-2001", size(large)) xtitle("Robot exposure using US instrument 2004-2016", size(large)) ///
	   xlabel(, labsize(large)) ylabel(, labsize(large)) ///
       plotregion(style(none)) bgcolor(white) ///
       legend(off) graphregion(color(white)) ///
	 
graph export "plots/placebo_check_US.png", replace
	
***
*** 5) Reduced form regressions - NUTS 3 ANALYSIS
***

clear 
use "clean_data/reg_ready.dta"

*** i) Employment to population

// EU countries
eststo nuts3_eu_emp: regress diff_emp_to_pop robot_exposure import_exposure ///
	population_2000 female_share bachelor_share high_school_share FR* ///
	[w=working_age_pop], noconstant 
	
// Gradually adding control variables
eststo nuts3_eu_emp_1: regress diff_emp_to_pop robot_exposure, ///
	noconstant 
eststo nuts3_eu_emp_2: regress diff_emp_to_pop robot_exposure ///
	[w=working_age_pop], noconstant 
eststo nuts3_eu_emp_3: regress diff_emp_to_pop robot_exposure import_exposure ///
	[w=working_age_pop], noconstant 
eststo nuts3_eu_emp_4: regress diff_emp_to_pop robot_exposure import_exposure ///
	population_2000 female_share bachelor_share high_school_share ///
	[w=working_age_pop], noconstant 
	
***
*** 6) Tex tables
*** 

esttab nuts2_iv_eu_emp nuts2_iv_us_emp nuts3_eu_emp ///
	using "tables/table1.tex", drop(import_exposure population_2001 population_2000 ///
	female_share bachelor_share high_school_share emp_share_D emp_share_F FR*) ///
	se star(* 0.05 ** 0.01 *** 0.001) replace ///
    booktabs nomtitle label	

esttab nuts2_iv_eu_wage nuts2_iv_us_wage ///
	using "tables/table2.tex", drop(import_exposure population_2001 female_share ///
	bachelor_share high_school_share emp_share_D emp_share_F) ///
	se star(* 0.05 ** 0.01 *** 0.001) append ///
    booktabs nomtitle label	
	
esttab nuts2_iv_eu_emp_1 nuts2_iv_eu_emp_2 nuts2_iv_eu_emp_3 nuts2_iv_eu_emp_4 nuts2_iv_eu_emp ///
	using "tables/controls_iv_eu_emp.tex", drop(import_exposure population_2001 female_share ///
	bachelor_share high_school_share emp_share_D emp_share_F) ///
	se star(* 0.05 ** 0.01 *** 0.001) replace ///
	booktabs nomtitle label
	
esttab nuts2_iv_us_emp_1 nuts2_iv_us_emp_2 nuts2_iv_us_emp_3 nuts2_iv_us_emp_4 nuts2_iv_us_emp ///
	using "tables/controls_iv_us_emp.tex", drop(import_exposure population_2001 female_share ///
	bachelor_share high_school_share emp_share_D emp_share_F) ///
	se star(* 0.05 ** 0.01 *** 0.001) replace ///
	booktabs nomtitle label
	
esttab nuts2_iv_us_eu_emp_1 nuts2_iv_us_eu_emp_2 nuts2_iv_us_eu_emp_3 nuts2_iv_us_eu_emp_4 nuts2_iv_us_eu_emp ///
	using "tables/controls_iv_eu_us_emp.tex", drop(import_exposure population_2001 female_share ///
	bachelor_share high_school_share emp_share_D emp_share_F) ///
	se star(* 0.05 ** 0.01 *** 0.001) replace ///
	booktabs nomtitle label
	
esttab nuts2_iv_eu_wage_1 nuts2_iv_eu_wage_2 nuts2_iv_eu_wage_3 nuts2_iv_eu_wage_4 nuts2_iv_eu_wage ///
	using "tables/controls_iv_eu_wage.tex", drop(import_exposure population_2001 female_share ///
	bachelor_share high_school_share emp_share_D emp_share_F) ///
	se star(* 0.05 ** 0.01 *** 0.001) replace ///
	booktabs nomtitle label

esttab nuts2_iv_us_wage_1 nuts2_iv_us_wage_2 nuts2_iv_us_wage_3 nuts2_iv_us_wage_4 nuts2_iv_us_wage ///
	using "tables/controls_iv_us_wage.tex", drop(import_exposure population_2001 female_share ///
	bachelor_share high_school_share emp_share_D emp_share_F) ///
	se star(* 0.05 ** 0.01 *** 0.001) replace ///
	booktabs nomtitle label
	
esttab nuts2_iv_us_eu_wage_1 nuts2_iv_us_eu_wage_2 nuts2_iv_us_eu_wage_3 nuts2_iv_us_eu_wage_4 nuts2_iv_us_eu_wage ///
	using "tables/controls_iv_us_eu_wage.tex", drop(import_exposure population_2001 female_share ///
	bachelor_share high_school_share emp_share_D emp_share_F) ///
	se star(* 0.05 ** 0.01 *** 0.001) replace ///
	booktabs nomtitle label
	
esttab nuts3_eu_emp_1 nuts3_eu_emp_2 nuts3_eu_emp_3 nuts3_eu_emp_4 nuts3_eu_emp ///
	using "tables/controls_nuts3.tex", drop(import_exposure population_2000 ///
	female_share bachelor_share high_school_share FR*) ///
	se star(* 0.05 ** 0.01 *** 0.001) replace ///
	booktabs nomtitle label
	
cd "$mydir/do_files"
log close
