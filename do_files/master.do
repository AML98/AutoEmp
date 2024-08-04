clear
capture log close
cd "/Users/aml/AutoEmp/do_files/nuts2_data_prep"

// Data prep
do "ifr_prep.do"
do "emp_regions_prep.do"
do "emp_countries_prep.do"
do "merge.do"

cd "/Users/aml/AutoEmp/do_files"

// Estimation
do "estimation.do"
