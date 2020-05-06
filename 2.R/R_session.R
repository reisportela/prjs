## R Session with Jupiter
## BPLIM Academy
## May 6, 2020
## M Portela
rm(list = ls())
getwd()
version

## 1. libraries
library(haven)

## data
nlsw88 <- read_dta("data/nlsw88.dta")

