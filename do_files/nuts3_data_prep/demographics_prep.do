clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/demographics_prep.txt", replace

***
*** 1) Prepare population data for year 2016 (sheet 27)
***

import excel "raw_data/eurostat/demographics_gender.xlsx", sheet("Sheet 27") ///
	cellrange(A12:E114) firstrow	

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
	cellrange(A12:D114) firstrow	

tempfile working_age_pop
	
drop if missing(working_age_pop)
replace working_age_pop = working_age_pop / 1000
drop population
drop if _n == 1

save `working_age_pop'
clear

***
*** 3) Prepare education data for year 2001 (sheet 1)
***

import excel "raw_data/eurostat/demographics_educ.xlsx", sheet("Sheet 1") ///
	cellrange(A14:E111) firstrow	

tempfile education_pop
	
drop if missing(population) | missing(high_school) | missing(bachelor)
gen high_school_share = high_school / population
gen bachelor_share = bachelor / population 
drop population high_school bachelor
drop if _n == 1

save `education_pop'
clear

***
*** 4) Prepare population data for year 2000 (sheet 11)
***

import excel "raw_data/eurostat/demographics_gender.xlsx", sheet("Sheet 11") ///
	cellrange(A12:E114) firstrow	

// Remove overseas regions
drop if region == "Guadeloupe" | region == "Martinique" | region == "Guyane" ///
	| region == "La Réunion" | region == "Mayotte"
	
drop if missing(population) | missing(males) | missing(females)
gen female_share = females / population
gen population_2000 = population / 1000
drop males females population
drop if _n == 1

***
*** 5) Merge data into one data set
***

merge 1:1 region_code using `population_2016', keepusing(population_2016)
drop if _merge == 2
drop _merge

merge 1:1 region_code using `working_age_pop', keepusing(working_age_pop)
drop if _merge == 2
drop _merge

merge 1:1 region_code using `education_pop', keepusing(high_school_share bachelor_share)
drop if _merge == 2
drop _merge

save "clean_data/demographics.dta", replace
cd "/Users/aml/AutoEmp/do_files/nuts3_data_prep"
log close
