clear
cd "$mydir"
log using "logs/nuts_dummies.txt", replace

use "clean_data/nuts2_demographics.dta"

// Dummies for every NUTS 1 area (12)

gen FRC = region_code == "FRC1" | region_code == "FRC2" |  region_code == "FRB0"

gen FRD = region_code == "FRD1" | region_code == "FRD2"

gen FRE = region_code == "FRE1" | region_code == "FRE2" | region_code == "FR10"

gen FRF = region_code == "FRF1" | region_code == "FRF2" | region_code == "FRF3"

gen FRH = region_code == "FRH0" | region_code == "FRG0"

gen FRI = region_code == "FRI1" | region_code == "FRI2" | region_code == "FRI3"

gen FRJ = region_code == "FRJ1" | region_code == "FRJ2"

gen FRK = region_code == "FRK1" | region_code == "FRK2" | region_code == "FRL0"

gen FRM = region_code == "FRM0"

// Check that each region is assigned to exactly one NUTS 2 area
egen sum_dummies = rowtotal(FRC FRD FRE FRF FRH FRI FRJ FRK FRM)
assert sum_dummies == 1

save "clean_data/nuts2_demographics.dta", replace
cd "$mydir/do_files/nuts2_data_prep"
log close
