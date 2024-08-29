clear
cd "$mydir"
capture log close
log using "logs/descriptive_stats.txt", replace 

use "clean_data/nuts2_reg_ready.dta"

sum diff_emp_to_pop_* diff_log_wages_* robot_exposure frobot_exposure_01 ///
	frobot_exposure_04 usrobot_exposure import_exposure emp_share_* ///
	bachelor_share high_school_share female_share working_age_pop
	
sum robot_exposure_*

sum usrobot_exposure_*

sum frobot_exposure_*
	
clear 
use "clean_data/reg_ready.dta"

sum diff_emp_to_pop robot_exposure frobot_exposure import_exposure ///
	bachelor_share high_school_share female_share working_age_pop
	
cd "$mydir/do_files"
log close
