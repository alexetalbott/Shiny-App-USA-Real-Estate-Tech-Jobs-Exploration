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

## clean up zillow data

neighborhood_gathered <- neighborhood_values %>% gather("month_and_year","median_value",X1996.04:X2018.10) %>% separate(col=month_and_year, into=c("year","month"),sep="\\.")

ng <- neighborhood_gathered

ng$year <- gsub("X","",ng$year)

ng$year <- as.integer(ng$year)
ng$month <- as.integer(ng$month)

ng_slim <- drop_na(ng)

sumCity <- ng_slim %>% group_by(City, State, year) %>% summarise(home_value = mean(median_value))

## zillow example: Nashville home values since 96
nville <- sumCity %>% filter(City=="Nashville")
ggplot(nville) + aes(x=year,y=home_value) + geom_line()

##zillow example 2: Austin home values since 96
austin <- sumCity %>% filter(City=="Austin")
ggplot(austin) + aes(x=year, y=home_value) + geom_line()


## USA home values since 96
ggplot(ng_slim %>% group_by(year) %>% summarize(value = mean(median_value))) + aes(x=year, y=value) + geom_line() + labs(title="USA Home Value")


## looking at BLS Data


#example: map of cities with programmer jobs
programmers <- bls_data %>% filter(occ_titl == "Computer Programmers")
str(programmers)
programmers$tot_emp <- as.numeric(programmers$tot_emp)
programmers_by_state <- programmers %>% group_by(year, prim_state) %>% summarise(total_employed = sum(tot_emp))

## geocoding areas -- just an example, need to do for full file
cached_geocodes <- as.character(unique(programmers$area_name)) %>% as.data.frame()
names(cached_geocodes) <- c("area_named")
cached_geocodes$lat <- geocode(as.character(cached_geocodes$area_named),source="dsk")$lat
cached_geocodes$lon <- geocode(as.character(cached_geocodes$area_named),source="dsk")$lon

cached_geocodes_slim <- drop_na(cached_geocodes)


top = 49.3457868 # north lat
left = -124.7844079 # west long
right = -66.9513812 # east long
bottom =  24.7433195 # south lat

cached_geocodes_slim_usOnly <- cached_geocodes_slim %>% filter(lat<top, lat>bottom, lon>left, lon<right)
cached_geocodes_slim_usOnly %>% leaflet %>% addProviderTiles("CartoDB") %>% addMarkers(popup = cached_geocodes_slim$area_named)

## make it interactive - when you click it provides number of jobs
programmers_2017 <- programmers %>% filter(year=="2017") %>% select(area_name, tot_emp)
programmers_2017_merged <- inner_join(programmers_2017,cached_geocodes_slim_usOnly, by = c("area_name"="area_named")) %>% unique()
programmers_2017_by_city_map <- programmers_2017_merged %>% leaflet() %>% addProviderTiles("CartoDB") %>% addMarkers(popup = c(programmers_2017_merged$area_name,as.character(programmers_2017_merged$tot_emp)))
programmers_2017_by_city_map

programmers_2017_top10 <- programmers

### example - playing with setview
library(leaflet)
dsk <- geocode("Nashville, TN",source="dsk")
leaflet() %>% addProviderTiles("CartoDB") %>% setView(lng = dsk$lon[1], lat = dsk$lat[1], zoom=8)

## matching BLS and zillow data -- just an example, need to do for full file

bls_2007 <- bls_data %>% filter(year==2007)
View(bls_2007)

zillow_2007 <- ng_slim %>% filter(year==2007) %>% group_by(year, Metro, State) %>% summarize(median_metro_value = mean(median_value))

zillow_2007 <- zillow_2007 %>% unite(metro_st,Metro:State,sep=", ",remove=FALSE)


## TO DO BEFORE MERGE -- ADD POPULATION DATA TO BLS_SLIM... BUT I don't necessarily need to  add population... could use the "workforce" figure (not 'tech workforce figure') for filtering

bls_2007$tot_emp <- as.numeric(bls_2007$tot_emp)

bls_2007_slim <- bls_2007 %>% group_by(area_name) %>% summarise(workforce = sum(tot_emp))

zillow_bls_2007 <- inner_join(bls_2007_slim,zillow_2007,by=c("area_name"="metro_st"))

## use anti-join to detect which cities are not matching --- we can filter these to a lower number by setting a population limit
anti_zillow_bls_2007 <- anti_join(bls_2007_slim, zillow_2007, by=c("area_name"="metro_st"), keep=TRUE)

## try to match anti file

anti_matcher_2007 <- anti_zillow_bls_2007 %>% separate(area_name,into=c("area","st"),sep=",",remove=FALSE) %>% separate(area,into=c("area1","area2","area3"),sep="-",remove=FALSE)

## to do next: write a function for anti-matcher that iterates through area1:area3, looks for a match in zillow_2007$Metro, and then checks if state fields are equal
