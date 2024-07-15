clear
capture log close
cd "/Users/aml/Documents/KU/Seminar 2"
log using "logs/ifr_prep.txt", replace

import excel "raw_data/ifr/Stock_by_ctry_1997-2011.xlsx", sheet("Sheet2") firstrow

rename A year

* Use the same countries as Acemuglo and Restrepo 
* for instrument, but replace Norway with 
* Netherland (Norway not available)
keep year DK FR FI DE IT NL ES SE GB

gen foreign_robot_stock = DK + FI + DE + IT + NL + ES + SE + GB

save "clean_data/ifr_clean.dta", replace

log close
