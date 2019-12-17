clear all
set more off
set rmsg on

quietly{
cd /Users/miguelportela/Documents/GitHub/prjs/chunks

use nipcs, clear
compress
contract nipc
drop _freq
drop if nipc == .
format %12.0f nipc
}

codebook nipc

list in 1/5

// ESTIMATE THE 'High Dimensional Fixed-Effects'

use /Users/miguelportela/Documents/GitHub/prjs/data/data_short, clear

timer on 1

	reghdfe lnrealwage education lnsales,absorb(workerid firmid year)

timer off 1
timer list 1
timer clear 1

// PUTEXCEL

cd "/Users/miguelportela/Documents/GitHub/prjs/logs"

quiet use ../data/graph_data, clear
	codebook, compact

			putexcel clear
			putexcel set descriptives.xlsx, sheet("Avg. Educ. & desc.") replace
			

gen first = substr(country,1,1)

	levelsof first,local(ff)
	
	foreach vv of local ff {
	
		di _new(3) "Country's first letter:	`vv'"
		
		preserve
		quiet keep if first == "`vv'"
		
		quiet unique country
			
			if r(unique) > 5 {
			di _new(2) "	Number of countries:	" r(unique) _new(1)
			quietly {
				collapse (mean) lngdp education,by(country)
					putexcel set descriptives.xlsx, sheet("FIRST LETTER `vv'") modify
					
					regress lngdp education
						
							matrix list r(table)
						
						matrix results = r(table)
							mat l results
						
						mat b = results[1,1...]'
						mat t = results[3,1...]'
						
						putexcel C2="Coef." F2="t"
						putexcel B3 = matrix(b), rownames nformat(number_d2) right
						putexcel D3 = matrix(t),nformat("0.00")
				}
			}
			
			if r(unique) <= 5 {
				di _new(2) "	Insufficient number of countries; n countries = " r(unique) _new(1)
			}
			
		restore
}

// tabulate, summarize() -- EXAMPLE

tabulate first year, summarize(education) nost nof noob

collapse (mean) education,by(first year)

reshape wide education,i(first) j(year)
mkmat education*,matrix(mean_educ) rownames(first)

putexcel set descriptives.xlsx, sheet("Mean Education") modify

	putexcel C2="1960" D2="1965" E2="1970" F2="1975" G2="1980" H2="1985" I2="1990" J2="1995" K2="2000"
	putexcel B3 = matrix(mean_educ), rownames nformat(number_d2) right

				
						
// RD

clear all
set more off
set linesize 200
cd /Users/miguelportela/Dropbox/1.miguel/1.formacao/NIPESS2019/lectures/
** Load Data: U.S. Senate
use senate, clear
gl x demmv
gl y demvoteshfor2

sum demmv

********************************************************************************
** Summary Stats & Diff-in-means
********************************************************************************
sum $y $x demvoteshlag1 demvoteshlag2 dopen
gen T= ($x>=0)
ttest $y, by(T)
sum demmv

********************************************************************************
** RD Plots
********************************************************************************
** Mimicking variance
rdplot $y $x, scheme(mono)

** IMSE-optimal
rdplot $y $x, binselect(es)

des

** Undersmoothed & graphs options
local tmp = 300
rdplot $y $x, ///
    numbinl(`tmp') numbinr(`tmp') p(4) ///
    graph_options(title(RD Plot - Senate Elections Data) ///
                  ytitle(Vote Share in Election at time t+1) ///
                  xtitle(Vote Share in Election at time t))

