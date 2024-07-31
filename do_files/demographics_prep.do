clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/demographics_prep.txt", replace

***
*** 1) Prepare population data for year 2016 (sheet 27)
***

import excel "raw_data/eurostat/demographics_gender.xlsx", sheet("Sheet 27") ///
	cellrange(B12:E115) firstrow	

tempfile population_2016
	
drop if missing(population) | missing(males) | missing(females)
gen population_2016 = population / 1000
drop males females population
drop if _n == 1

save `population_2016'
clear

***
*** 2) Prepare working-age population data for year 2000 (sheet 11)
***

import excel "raw_data/eurostat/demographics_age.xlsx", sheet("Sheet 11") ///
	cellrange(B12:D115) firstrow	

tempfile working_age_pop
	
drop if missing(working_age_pop)
replace working_age_pop = working_age_pop / 1000
drop population
drop if _n == 1

save `working_age_pop'
clear

***
*** 3) Prepare population data for year 2000 (sheet 11)
***

import excel "raw_data/eurostat/demographics_gender.xlsx", sheet("Sheet 11") ///
	cellrange(B12:E115) firstrow	
	
drop if missing(population) | missing(males) | missing(females)
gen female_share = females / population
gen population_2000 = population / 1000
drop males females population
drop if _n == 1

***
*** 4) Merge data into one data set
***

merge 1:1 region using `population_2016', keepusing(population_2016)
drop if _merge == 2
drop _merge

merge 1:1 region using `working_age_pop', keepusing(working_age_pop)
drop if _merge == 2
drop _merge

save "clean_data/demographics.dta", replace
cd "/Users/aml/AutoEmp/do_files"
log close
