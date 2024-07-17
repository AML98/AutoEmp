clear
capture log close
cd "/Users/aml/AutoEmp/do_files"

// Data prep
do "ifr_prep.do"
do "emp_regions_prep.do"
do "emp_countries_prep.do"
do "merge.do"

// Estimation
do "estimation.do"
