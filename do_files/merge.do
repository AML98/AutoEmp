clear
capture log close
cd "/Users/aml/AutoEmp"
log using "logs/merge.txt", replace

use "clean_data/emp_regions.dta"

// Variables for merge
global merge_vars_1 = "emp_base_AB emp_base_CE emp_base_F"
global merge_vars_2 = "diff_robot_stock_AB diff_robot_stock_CE diff_robot_stock_F"

merge m:1 id using "clean_data/emp_countries.dta", update
drop _merge

merge m:1 id using "clean_data/foreign_diff_robot_stock.dta", update
drop _merge id

save "clean_data/reg_ready.dta", replace
cd "/Users/aml/AutoEmp/do_files"

log close
