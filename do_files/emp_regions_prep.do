clear
capture log c
cd "/Users/aml/Documents/KU/Seminar 2"
log using "logs/emp_regions_prep.txt", replace

import excel "raw_data/eurostat/emp_regions.xlsx", sheet("Sheet 1") cellrange(A13:L40) firstrow

drop GEOLabels

save "clean_data/emp_regions_clean.dta", replace

log close
