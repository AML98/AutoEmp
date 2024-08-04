clear
capture log c
cd "/Users/aml/AutoEmp"
log using "logs/nuts_dummies.txt", replace

use "clean_data/demographics.dta"

// Dummies for every NUTS 2 area

gen FR10 = region == "Paris" | region == "Seine-et-Marne" | ///
	region == "Seine-Saint-Denis" | ///
	region == "Hauts-de-Seine" | ///
	region == "Val-de-Marne" | ///
	region == "Yvelines" | ///
	region == "Essonne" | ///
	region == "Val-d'Oise"

gen FRB0 = region == "Cher" | region == "Eure-et-Loir" | ///
	region == "Indre-et-Loire" | ///
	region == "Loir-et-Cher" | ///
	region == "Indre" | ///
	region == "Loiret"

gen FRC1 = region == "Côte-d'Or" | region == "Nièvre" | ///
	region == "Saône-et-Loire" | ///
	region == "Yonne"

gen FRC2 = region == "Doubs" | region == "Jura" | region == "Haute-Saône" | ///
    region == "Territoire de Belfort"

gen FRD1 = region == "Calvados" | region == "Manche" | region == "Orne"

gen FRD2 = region == "Eure" | region == "Seine-Maritime"

gen FRE1 = region == "Nord" | region == "Pas-de-Calais"

gen FRE2 = region == "Aisne" | region == "Oise" | region == "Somme"

gen FRF1 = region == "Bas-Rhin" | region == "Haut-Rhin"

gen FRF2 = region == "Ardennes" | region == "Aube" | region == "Marne" | ///
    region == "Haute-Marne"

gen FRF3 = region == "Meurthe-et-Moselle" | region == "Meuse" | ///
	region == "Moselle" | ///
	region == "Vosges"

gen FRG0 = region == "Loire-Atlantique" | region == "Maine-et-Loire" | ///
	region == "Mayenne" | ///
	region == "Sarthe" | ///
	region == "Vendée"

gen FRH0 = region == "Côtes-d'Armor" | region == "Finistère" | ///
	region == "Ille-et-Vilaine" | ///
	region == "Morbihan"

gen FRI1 = region == "Dordogne" | region == "Gironde" | ///
	region == "Pyrénées-Atlantiques" | ///
	region == "Lot-et-Garonne" | ///
	region == "Landes"

gen FRI2 = region == "Corrèze" | region == "Creuse" | region == "Haute-Vienne"

gen FRI3 = region == "Charente" | region == "Charente-Maritime" | ///
	region == "Deux-Sèvres" | ///
	region == "Vienne"

gen FRJ1 = region == "Aude" | region == "Gard" | region == "Hérault" | ///
	region == "Pyrénées-Orientales" | ///
    region == "Lozère"

gen FRJ2 = region == "Ariège" | region == "Aveyron" | ///
	region == "Hautes-Pyrénées" | ///
	region == "Tarn-et-Garonne" | ///
	region == "Haute-Garonne" | ///
	region == "Gers" | ///
	region == "Lot" | ///
	region == "Tarn"

gen FRK1 = region == "Allier" | region == "Cantal" | ///
	region == "Haute-Loire" | ///
    region == "Puy-de-Dôme"

gen FRK2 = region == "Ain" | region == "Ardèche" | region == "Drôme" | ///
	region == "Isère" | ///
	region == "Loire" | ///
	region == "Rhône" | ///
	region == "Savoie" | ///
	region == "Haute-Savoie"

gen FRL0 = region == "Alpes-de-Haute-Provence" | region == "Hautes-Alpes" | ///
	region == "Bouches-du-Rhône" | ///
	region == "Alpes-Maritimes" | ///
	region == "Vaucluse" | ///
	region == "Var"

gen FRM0 = region == "Corse-du-Sud" | region == "Haute-Corse"

// Stata cannot find this region, so set the dummy manually
replace FRC1 = 1 if _n == 15

// Check that each region is assigned to exactly one NUTS 2 area
egen sum_dummies = rowtotal(FRL0 FR10 FRJ2 FRI1 FRB0 FRK2 FRG0 FRH0 FRI3 ///
	FRJ1 FRC2 FRF3 FRK1 FRC1 FRF2 FRI2 FRM0 FRD1 FRD2 FRF1 FRE1 FRE2)
assert sum_dummies == 1

save "clean_data/demographics.dta", replace
cd "/Users/aml/AutoEmp/do_files/nuts3_data_prep"
log close
