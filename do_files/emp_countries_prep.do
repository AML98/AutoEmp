clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/emp_countries_prep.txt", replace

// Data for year 2000 (sheet 9)
import excel "raw_data/eurostat/emp_countries.xlsx", sheet("Sheet 9") ///
	cellrange(A12:F21) firstrow

keep country agri_forest_fish industry manufact construct
gen other_industry = industry - manufact - construct
drop industry

// Aggregate on country level
foreach v in agri_forest_fish manufact construct other_industry {
	egen emp_base_`v' = total(`v')
	drop `v'
}

drop country
duplicates drop

// Add id variable for merge later
gen id = _n

save "clean_data/emp_countries.dta", replace
cd "/Users/aml/AutoEmp/do_files"

log close
