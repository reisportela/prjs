## R Session with Jupiter
## BPLIM Academy
## May 6, 2020
## M Portela

rm(list = ls())
getwd()
version

## 1. Libraries
  library(haven)
  library(ggplot2)
  library(dplyr)

## 2. Read data

  data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/1_OneNum.csv", header=TRUE)
  
  nlsw88 <- read_dta("data/nlsw88.dta")
  nlswork <- read_dta("data/nlswork.dta")

  attach(nlsw88)
  
## 3. Data exploration
  
## 3.1 Statistics
  summary(nlswork)

## 3.2 Graphs
  
  # Make the histogram
  data %>%
    filter( price<300 ) %>%
    ggplot( aes(x=price)) +
    geom_density(fill="#69b3a2", color="#e9ecef", alpha=0.8)
