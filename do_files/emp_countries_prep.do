clear
capture log c
cd "/Users/aml/Documents/KU/Seminar 2"
log using "logs/emp_countries_prep.txt", replace

import excel "raw_data/eurostat/emp_countries.xlsx", sheet("Sheet 1") cellrange(A12:Z21) firstrow

rename GEOLabels country

save "clean_data/emp_countries_clean.dta", replace

log close
