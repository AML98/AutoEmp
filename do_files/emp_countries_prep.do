clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/emp_countries_prep.txt", replace

import excel "raw_data/eurostat/emp_countries.xlsx", sheet("Sheet 1") cellrange(A12:Z21) firstrow
keep country AB CF F
gen CE = CF - F
drop CF
save "clean_data/emp_countries.dta", replace

cd "/Users/aml/AutoEmp/do_files"

log close
