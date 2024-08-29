clear
global mydir "/Users/aml/AutoEmp"

*** 1) NUTS 2 data prep
cd "$mydir/do_files/nuts2_data_prep"

do "ifr_prep.do"
do "wages_prep.do"
do "emp_regions_prep.do"
do "emp_countries_prep.do"
do "demographics_prep.do"
do "nuts_dummies.do"
do "imports_prep.do"
do "big_merge.do"

*** 2) NUTS 3 data prep
cd "$mydir/do_files/nuts3_data_prep"

do "ifr_prep.do"
do "emp_regions_prep.do"
do "emp_countries_prep.do"
do "demographics_prep.do"
do "nuts_dummies.do"
do "imports_prep.do"
do "big_merge.do"

*** 3) Descriptive stats
cd "$mydir/do_files"
do "descriptive_stats.do"

*** 4) Estimation
do "estimation.do"
