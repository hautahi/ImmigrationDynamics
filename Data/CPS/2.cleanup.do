* This program creates my own variables

* Housekeeping
set more off

clear
use "output/ipums_clean.dta"
numlabel, add

keep if age >= 16 
drop age 
drop if year <= 1994

* -----------------------
* Create Migrant Status
* -----------------------

drop if bpl == 99999

gen native = 0
replace native = 1 if bpl==9900

* Label Stuff
label define native_lbl 0 `"Immigrant"'
label define native_lbl 1 `"Native"', add
label values native native_lbl

* -----------------------
* Create Skill Types
* -----------------------

* Drop unknown education
drop if educ99 == 00

*(High Skill = College Degree)
gen skill = 0
replace skill = 1 if educ99>=15

* Label Stuff
label define skill_lbl 0 `"Low"'
label define skill_lbl 1 `"High"', add
label values skill skill_lbl

* -----------------------
* Create Employment Status
* -----------------------

* Drop NIU and military
drop if empstat == 0 | empstat==1

* Create Employment Type
gen status = 0
replace status = 1 if empstat==20 | empstat==21 | empstat ==22 
replace status = 2 if empstat==10 | empstat == 12

* Label Stuff
label define status_lbl 0 `"Not in Labor Force"'
label define status_lbl 1 `"Unemployed"', add
label define status_lbl 2 `"Employed"', add
label values status status_lbl

* -----------------------
* Create Short term unemployment indicator
* -----------------------

gen short = 0
replace short = 1 if durunemp <= 4

* Label Stuff
label define short_lbl 0 `"Not short-term unemployed"'
label define short_lbl 1 `"Short-term unemployed"', add
label values short short_lbl

* -----------------------
* Tidy and Save
* -----------------------

drop cpsid asecflag bpl educ99 empstat labforce durunemp

save "output/cleandata.dta", replace
