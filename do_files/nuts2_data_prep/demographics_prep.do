clear
cd "$mydir"
log using "logs/nuts2_demographics_prep.txt", replace

***
*** 1) Prepare population data for year 2016 (sheet 18)
***

import excel "raw_data/eurostat/nuts2_demographics_gender.xlsx", sheet("Sheet 18") ///
	cellrange(A13:D36) firstrow	

tempfile population_2016
	
drop if missing(population)
rename population population_2016
drop if _n == 1
drop females

save `population_2016'
clear

***
*** 2) Prepare population data for year 2004 (sheet 6)
***

import excel "raw_data/eurostat/nuts2_demographics_gender.xlsx", sheet("Sheet 6") ///
	cellrange(A13:D36) firstrow	

tempfile population_2004
	
drop if missing(population)
rename population population_2004
drop if _n == 1

save `population_2004'
clear

***
*** 3) Prepare working-age population data for year 2001
***

import excel "raw_data/eurostat/nuts2_demographics_working_age.xlsx", sheet("Sheet 1") ///
	cellrange(A12:AA35) firstrow	

tempfile working_age_pop
	
keep region_code region working_age_pop_2001
rename working_age_pop_2001 working_age_pop
drop if missing(working_age_pop)
drop if _n == 1

save `working_age_pop'
clear

***
*** 4) Prepare education data for year 2001 (sheet 3)
***

import excel "raw_data/eurostat/nuts2_demographics_educ.xlsx", sheet("Sheet 3") ///
	cellrange(A13:E36) firstrow	

tempfile education_pop
	
drop if missing(population) | missing(high_school) | missing(bachelor)
gen high_school_share = high_school / population
gen bachelor_share = bachelor / population 
drop population high_school bachelor
drop if _n == 1

save `education_pop'
clear

***
*** 5) Prepare population data for year 2001 (sheet 3)
***

import excel "raw_data/eurostat/nuts2_demographics_gender.xlsx", sheet("Sheet 3") ///
	cellrange(A13:D36) firstrow	
	
drop if missing(population) | missing(females)
gen female_share = females / population
rename population population_2001
drop if _n == 1
drop females

***
*** 6) Merge data into one data set
***

merge 1:1 region_code using `population_2016', keepusing(population_2016)
drop if _merge == 2
drop _merge

merge 1:1 region_code using `population_2004', keepusing(population_2004)
drop if _merge == 2
drop _merge

merge 1:1 region_code using `working_age_pop', keepusing(working_age_pop)
drop if _merge == 2
drop _merge

merge 1:1 region_code using `education_pop', keepusing(high_school_share bachelor_share)
drop if _merge == 2
drop _merge

save "clean_data/nuts2_demographics.dta", replace
cd "$mydir/do_files/nuts2_data_prep"
log close
