using ReadStat
using StatFiles
using StatsBase
using DataFrames
using FixedEffectModels

@time results_hdfe1 = reg(DataFrame(load("/Users/miguelportela/Documents/GitHub/prjs/data/data_short.dta")), @formula(lnrealwage ~ education + lnsales + fe(workerid) + fe(year)));

@time results_hdfe2 = reg(DataFrame(load("/Users/miguelportela/Documents/GitHub/prjs/data/data_short.dta")), @formula(lnrealwage ~ education + lnsales + fe(workerid) + fe(firmid) + fe(year)));



using RegressionTables
regtable(results_hdfe1,results_hdfe2; renderSettings = latexOutput("/Users/miguelportela/Documents/GitHub/prjs/logs/hdfe_output.tex"))
