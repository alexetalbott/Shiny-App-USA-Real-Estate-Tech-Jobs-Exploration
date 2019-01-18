setwd("C:/Users/Alex/Google Drive/GIT/zillow")

## read in data

library(tidyverse)
library(ggmap)
library(leaflet)

## zillow data Apr 1996- Oct 2018 by month
neighborhood_values <- read.csv("data/Neighborhood_Zhvi_AllHomes.csv")

## bls data 2000 - 2017 by year
bls_data <- read.csv("data/metro/bls_master.csv")
bls_data$area_name <- sub(" MSA","",bls_data$area_name)
bls_data$area_name <- sub(" PMSA","",bls_data$area_name)
bls_data$area_name <- sub(" Metropolitan Division","",bls_data$area_name)
bls_allOccupations <- bls_data %>% filter(as.character(occ_titl) == "All Occupations")
bls_allOccupations$occ_titl <- tolower(bls_allOccupations$occ_titl)
bls_majorGroups <- bls_data %>% filter(as.character(group) == "major" & as.character(occ_titl) != "All Occupations")
bls_majorGroups$occ_titl <- tolower(bls_majorGroups$occ_titl)
bls_data_jobLevel <- bls_data %>% filter(as.character(occ_titl) != "All Occupations" & tot_emp != "**" & is.na(group))
bls_data_jobLevel$occ_titl <- tolower(bls_data_jobLevel$occ_titl)


bls_majorGroups_summ <- bls_majorGroups %>% select(area_name, year, prim_state, occ_titl, tot_emp) %>% group_by(area_name, occ_titl)
bls_comp <- bls_majorGroups %>% select(area_name, year, prim_state, occ_titl, tot_emp) %>% group_by(area_name, occ_titl) %>% filter(grepl("computer",occ_titl) & tot_emp != "**")

## clean up zillow data

neighborhood_gathered <- neighborhood_values %>% gather("month_and_year","median_value",X1996.04:X2018.10) %>% separate(col=month_and_year, into=c("year","month"),sep="\\.")

ng <- neighborhood_gathered

ng$year <- gsub("X","",ng$year)

ng$year <- as.integer(ng$year)
ng$month <- as.integer(ng$month)

ng_slim <- drop_na(ng)

## matching BLS and zillow data -- just an example, need to do for full file

zillow_annualLevel <- ng_slim %>% group_by(year, Metro, State) %>% summarize(median_metro_value = mean(median_value))

zillow_annualLevel <- zillow_annualLevel %>% unite(metro_st,Metro:State,sep=", ",remove=FALSE) %>% arrange(desc(median_metro_value))


## TO DO BEFORE MERGE -- ADD POPULATION DATA TO BLS_SLIM... BUT I don't necessarily need to  add population... could use the "workforce" figure (not 'tech workforce figure') for filtering

bls_data_jobLevel$tot_emp <- as.numeric(bls_data_jobLevel$tot_emp)

bls_slim <- bls_data_jobLevel %>% group_by(area_name) %>% summarise(workforce = sum(tot_emp)) %>% arrange(desc(workforce))

zillow_bls <- inner_join(bls_slim,zillow_annualLevel,by=c("area_name"="metro_st"))

zillow_bls_comp <- inner_join(bls_comp,zillow_annualLevel,by=c("area_name"="metro_st","year"="year"))

## use anti-join to detect which cities are not matching --- we can filter these to a lower number by setting a population limit
anti_zillow_bls <- anti_join(bls_slim, zillow_annualLevel, by=c("area_name"="metro_st"), keep=TRUE)

anti_zillow_comp <- anti_join(bls_comp,zillow_annualLevel,by=c("area_name"="metro_st","year"="year"), keep=TRUE)

## try to match anti file

anti_matcher <- anti_zillow_bls %>% separate(area_name,into=c("area","st"),sep=",",remove=FALSE) %>% separate(area,into=c("area1","area2","area3"),sep="-",remove=FALSE)

anti_matcher_comp <- anti_zillow_comp %>% separate(area_name,into=c("area","st"),sep=",",remove=FALSE) %>% separate(area,into=c("area1","area2","area3"),sep="-",remove=FALSE)

## to do next: write a function for anti-matcher that iterates through area1:area3, looks for a match in zillow_2007$Metro, and then checks if state fields are equal

# this function iterates through anti_matcher_comp$area1 and looks for a match within zillow_bls_comp$Metro; 
# IF there is a match (match1) THEN check anti_matcher_comp$st at the same row as match1 for a match at the zillow_bls_comp$State column; ELSE move on
# IF there is a match (match2) THEN check anti_matcher_comp$year at the some row as match1 for a match at the zillow_bls_comp$year column; 
# IF all three match, THEN add the value of zillow_bls_comp$median_metro_value to anti_matcher_comp,
# ELSE move onto next row of anti_matcher_comp$area1
##skipping for now

#matchy <- function(input) {
#  x <- grepl()
#}

master_data <- zillow_bls_comp %>% ungroup %>% select(Metro, State, tot_emp, median_metro_value, year)
names(master_data)[3] <- "math_and_programming_jobs"
master_data <- master_data %>% mutate(city_state = paste0(Metro,", ",State))
master_data$lat <- geocode(as.character(master_data$city_state),source="dsk")$lat
master_data$lon <- geocode(as.character(master_data$city_state),source="dsk")$lon

master_data %>% filter(year==2011) %>% leaflet %>% addProviderTiles("CartoDB") %>% addMarkers(popup = c(master_data$city_state,master_data$median_metro_value,master_data$math_and_programming_jobs))  


write_csv(master_data,"data/master_data.csv")

dataSelect <- master_data %>% filter(as.character(city_state) == "Austin-Round Rock, TX")


ggplot(master_data %>% filter(as.character(city_state) == "Austin-Round Rock, TX")) + aes(x=year, y=median_metro_value) + geom_line()

