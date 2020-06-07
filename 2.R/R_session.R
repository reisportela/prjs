## May 6, 2020
## M Portela

rm(list = ls())

#sink("analysis.txt")

version

setwd("/home/jovyan/2.R")

getwd()

## 1. Libraries
##https://cran.r-project.org/web/packages/dlookr/vignettes/EDA.html


library(haven)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(dlookr)
library(plm)
library(stargazer)

## 2. Read data

data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/1_OneNum.csv", header=TRUE)

nlswork <- read_dta("../data/nlswork.dta")

#  attach(nlsw88)

df <- na.omit(nlswork)

attach(df)

## 3. Data exploration

## 3.1 Statistics

summary(nlswork)

summary(df)

describe(df)

freq <- table(south,union)
freq
prop.table(freq)
prop.table(table(union))

## 3.2 Graphs

# Make the histogram

data %>%
  filter( price<300 ) %>%
  ggplot( aes(x=price)) +
  geom_density(fill="#69b3a2", color="#e9ecef", alpha=0.8)

hist(ln_wage)

png(filename = 'wage_density.png')
plot(density(ln_wage))
dev.off()

plot(density(ln_wage))
ggsave("density.eps")

# 4. REGRESSION ANALYSIS

# 4.1 OLS

ols1 <- lm(ln_wage ~ union)
summary(ols1)

# 4.2 PANEL DATA

fe1 <- plm(ln_wage ~ union,data=df,model="within")
summary(fe1)  

re1 <- plm(ln_wage ~ union,data=df,model="random")
summary(re1)  

stargazer(ols1,fe1,re1,type="text")

#sink()
