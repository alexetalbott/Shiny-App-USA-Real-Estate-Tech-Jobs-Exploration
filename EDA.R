setwd("C:/Users/Alex/Google Drive/GIT/zillow")

library(tidyverse)
library(ggmap)

neighborhood_values <- read.csv("data/Neighborhood_Zhvi_AllHomes.csv")

bls_data <- read.csv("data/metro/bls_master.csv")

neighborhood_gathered <- neighborhood_values %>% gather("month_and_year","median_value",X1996.04:X2018.10) %>% separate(col=month_and_year, into=c("year","month"),sep="\\.")

ng <- neighborhood_gathered

ng$year <- gsub("X","",ng$year)

ng$year <- as.integer(ng$year)
ng$month <- as.integer(ng$month)

ng_slim <- drop_na(ng)

sumCity <- ng_slim %>% group_by(City,year) %>% summarise(home_value = mean(median_value))

nville <- sumCity %>% filter(City=="Nashville")

ggplot(nville) + aes(x=year,y=home_value) + geom_line()

austin <- sumCity %>% filter(City=="Austin")

ggplot(austin) + aes(x=year, y=home_value) + geom_line()

ggplot(ng_slim %>% group_by(year) %>% summarize(value = mean(median_value))) + aes(x=year, y=value) + geom_line() + labs(title="USA Home Value")
