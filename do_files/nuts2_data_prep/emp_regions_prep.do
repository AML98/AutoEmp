clear
cd "$mydir"
log using "logs/nuts2_emp_regions_prep.txt", replace

***
*** 1) Combine LFS and SBS data
***

import excel "raw_data/eurostat/nuts2_emp_lfs_9908.xlsx", sheet("Sheet 3") ///
	cellrange(A13:D36) firstrow
	
tempfile lfs_emp
save `lfs_emp'
clear

import excel "raw_data/eurostat/nuts2_emp_sbs_9507.xlsx", sheet("Sheet 7") ///
	cellrange(A70:Q93) firstrow

tempfile lfs_sbs_emp

merge 1:1 region_code using `lfs_emp'
drop _merge

save `lfs_sbs_emp'
clear

***
*** 2) Employment data in year 2001
***

// i) National employment (employment base)
use `lfs_sbs_emp'

tempfile emp_national_2001

drop total_emp_2001
keep if _n == 1
gen id = 1
drop D

foreach v in AB C E F ind* {
	rename `v' fr_emp_base_`v'
}

save `emp_national_2001'
clear

// ii) Regional employment (employment shares)
use `lfs_sbs_emp'
	
tempfile emp_regions_2001

drop if missing(AB) | missing(C) | missing(D) | missing(E) | missing(F)
drop if _n == 1

local varlist ind10_12 ind13_15 ind16 ind17_18 ind19_22 ind23 ind24_25 ind26_27 ///
	ind28 ind29_30 ind91 AB C D E F

foreach var of local varlist {
	gen emp_share_`var' = `var' / total_emp_2001
	gen diff_robots_`var' = .
	gen emp_base_`var' = .
	drop `var'
}

save `emp_regions_2001'
clear

***
*** 3) Employment data in year 2016
***

import excel "raw_data/eurostat/nuts2_emp_lfs_0823.xlsx", sheet("Sheet 1") ///
	cellrange(A12:R35) firstrow	
	
keep region_code region total_emp_2016
drop if _n == 1

tempfile emp_regions_2016
save `emp_regions_2016'
clear

***
*** 4) Employment data in year 2004
***

import excel "raw_data/eurostat/nuts2_emp_lfs_9908.xlsx", sheet("Sheet 6") ///
	cellrange(A13:C36) firstrow	

keep region_code region total_emp_2004
drop if _n == 1

tempfile emp_regions_2004
save `emp_regions_2004'
clear

***
*** 5) Placebo check
***

import excel "raw_data/eurostat/placebo_check.xlsx", sheet("Sheet 1") ///
	cellrange(M11:O32) firstrow	
	
tempfile placebo_check
save `placebo_check'
clear

***
*** 6) Merge into one data set
***

use `emp_regions_2001'

gen id = 1

merge m:1 id using `emp_national_2001'
drop _merge

merge 1:1 region_code using `emp_regions_2004'
drop if _merge == 2
drop _merge

merge 1:1 region_code using `emp_regions_2016'
drop if _merge == 2
drop _merge

merge 1:1 region_code using `placebo_check'
drop if _merge == 2
drop _merge

order region_code region total_emp_* emp_share_* diff_robots_* emp_base_* fr_emp_base_* emp_to_pop_diff_9601 id

save "clean_data/nuts2_emp_regions.dta", replace
cd "$mydir/do_files/nuts2_data_prep"
log close
