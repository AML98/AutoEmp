clear
global mydir "/Users/aml/AutoEmp"
cd "$mydir/do_files/nuts2_data_prep"

*** ONLY NUTS 2 ANALYSIS

// Data prep
do "ifr_prep.do"
do "wages_prep.do"
do "emp_regions_prep.do"
do "emp_countries_prep.do"
do "demographics_prep.do"
do "nuts_dummies.do"
do "imports_prep.do"
do "big_merge.do"

cd "$mydir/do_files"

// Estimation
do "estimation.do"
