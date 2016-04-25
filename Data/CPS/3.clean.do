* This program produces time series of hourly wages, unemployment rates
* and labor force numbers by nativity skill types, as well as flows and
* job finding rates for skill types.

set more off 

* --------------------
* Calculate wages for nativity-skill types
* --------------------

clear 
use "output/cleandata.dta"
numlabel, add

drop if hourwage >= 99.98
drop if year < 1996

* Create panel
gen cm = ym(year, month) 
format cm %tm
drop if cpsidp == . 
xtset cpsidp cm

* Find average wage for each nativity-skill group by time
gen wt = round(earnwt, 1)
collapse (mean) hourwage [fw=wt], by(skill native cm) 

* Create seasonally adjusted wage series
egen grouping = group(native skill), label
xtset grouping cm 
gen MA_wage=.5*L6.hourwage + L5.hourwage + L4.hourwage+ L3.hourwage + L2.hourwage /*
*/ + L.hourwage + hourwage + F.hourwage + F2.hourwage + F3.hourwage + F4.hourwage + F5.hourwage /*
 */ + .5*F6.hourwage
replace MA_wage = MA_wage / 12
drop grouping

* Save
outsheet * using "output/wagedata.csv", comma replace

* --------------------
* Calculate flows and job finding rates for skill types
* --------------------

clear 
use "output/cleandata.dta"
numlabel, add
drop if year < 1996

* Create panel
gen cm = ym(year, month) 
format cm %tm
drop if cpsidp == . 
xtset cpsidp cm 

* Create stock and flow measures
gen statusF1 = F1.status
drop if statusF1 == . 

gen E = .
replace E = 1 if status ==2

gen U = .
replace U = 1 if status ==1

gen UE = . 
replace UE = 1 if status == 1 & statusF1 == 2

gen EU=.
replace EU = 1 if status == 2 & statusF1 == 1

gen US=.
replace US = 1 if short == 1

gen wt = round(wtfinl, 1)

* Save a tempfile
save "output/temp.dta", replace

collapse (sum) UE EU U E US [fw=wt], by(skill cm) 

* Calculate job finding rates
xtset skill cm 
gen F_flows = 1 - (F1.U - F1.EU)/U
gen f_flows = -log(1-F)

gen F_short = 1 - (F1.U - F1.US)/U
gen f_short = -log(1-F_short)

* Seasonally adjust
gen MA_F_flows=.5*L6.F_flows + L5.F_flows + L4.F_flows+ L3.F_flows + L2.F_flows + L.F_flows + F_flows + F.F_flows + F2.F_flows + F3.F_flows + F4.F_flows + F5.F_flows + .5*F6.F_flows
replace MA_F_flows = MA_F_flows / 12

gen MA_f_flows=.5*L6.f_flows + L5.f_flows + L4.f_flows+ L3.f_flows + L2.f_flows + L.f_flows + f_flows + F.f_flows + F2.f_flows + F3.f_flows + F4.f_flows + F5.f_flows + .5*F6.f_flows
replace MA_f_flows = MA_f_flows / 12

gen MA_F_short=.5*L6.F_short + L5.F_short + L4.F_short+ L3.F_short + L2.F_short + L.F_short + F_short + F.F_short + F2.F_short + F3.F_short + F4.F_short + F5.F_short + .5*F6.F_short
replace MA_F_short = MA_F_short / 12

gen MA_f_short=.5*L6.f_short + L5.f_short + L4.f_short+ L3.f_short + L2.f_short + L.f_short + f_short + F.f_short + F2.f_short + F3.f_short + F4.f_short + F5.f_short + .5*F6.f_short
replace MA_f_short = MA_f_short / 12

* Save
outsheet * using "output/flowdata.csv", comma replace

* --------------------
* Calculate stocks for all types
* --------------------

clear 
use "output/temp.dta"

collapse (sum) U E [fw=wt], by(native skill cm)

gen LF = U + E
gen u = U/LF

* Seasonally adjust
egen grouping = group(native skill), label
xtset grouping cm 
gen MA_LF=.5*L6.LF + L5.LF + L4.LF+ L3.LF + L2.LF + L.LF + LF + F.LF + F2.LF + F3.LF + F4.LF + F5.LF + .5*F6.LF
replace MA_LF = MA_LF / 12

gen MA_u=.5*L6.u + L5.u + L4.u+ L3.u + L2.u + L.u + u + F.u + F2.u + F3.u + F4.u + F5.u + .5*F6.u
replace MA_u = MA_u / 12

* Save
drop grouping
outsheet * using "output/stocks.csv", comma replace

* Remove temporary file
erase "output/temp.dta"

* --------------------
* Additional stuff not used
* --------------------

*gen nUE = UE/U
*gen nEU = EU/E

*gen f_in = nUE*(-log(1-nEU-nUE))/(nEU+nUE)
*gen s_in = nEU*(-log(1-nEU-nUE))/(nEU+nUE)

*gen F = 1-exp(-f_in)
*gen S = 1-exp(-s_in)

*gen s = EU/U
