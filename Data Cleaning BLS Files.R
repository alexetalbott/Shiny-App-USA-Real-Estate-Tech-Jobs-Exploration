setwd("C:/Users/Alex/Google Drive/GIT/zillow/data/metro")
library(readxl)
library(tidyverse)
metro97 <- read_excel("metro_1997_one.xlsx", skip=32)
metro97_2 <- read_excel("metro_1997_two.xlsx", skip=32)
metro_98 <- read_excel("metro_1998_one.xlsx", skip=42)
metro_98_3 <- read_excel("metro_1998_three.xlsx", skip=42)
metro_98_2 <- read_excel("metro_1998_two.xlsx", skip=42)
metro_99_1 <- read_excel("metro_1999_one.xlsx", skip=43)
metro_99_2 <- read_excel("metro_1999_two.xlsx", skip=43)
metro_2000_1 <- read_excel("metro_2000_one.xlsx", skip=42)
metro_2000_2 <- read_excel("metro_2000_two.xlsx", skip=34)
metro_2001_1<- read_excel("metro_2001_one.xlsx")
metro_2001_3<- read_excel("metro_2001_three.xlsx")
metro_2001_2<- read_excel("metro_2001_two.xlsx")
metro_2002_1<- read_excel("metro_2002_one.xlsx")
metro_2002_2<- read_excel("metro_2002_two.xlsx")
metro_2003_1<- read_excel("metro_2003_one.xlsx")
metro_2003_2<- read_excel("metro_2003_two.xlsx")
metro_2004_1<- read_excel("metro_2004_one.xlsx")
metro_2004_3<- read_excel("metro_2004_three.xlsx")
metro_2004_2<- read_excel("metro_2004_two.xlsx")
metro_2005_1<- read_excel("metro_2005_one.xlsx")
metro_2005_3<- read_excel("metro_2005_three.xlsx")
metro_2005_2<- read_excel("metro_2005_two.xlsx")
metro_2006_1<- read_excel("metro_2006_one.xlsx")
metro_2006_3<- read_excel("metro_2006_three.xlsx")
metro_2006_2<- read_excel("metro_2006_two.xlsx")
metro_2007_1<- read_excel("metro_2007_one.xlsx")
metro_2007_3<- read_excel("metro_2007_three.xlsx")
metro_2007_2<- read_excel("metro_2007_two.xlsx")
metro_2008_1<- read_excel("metro_2008_one.xlsx")
metro_2008_3<- read_excel("metro_2008_three.xlsx")
metro_2008_2<- read_excel("metro_2008_two.xlsx")
metro_2009_1<- read_excel("metro_2009_one.xlsx")
metro_2009_3<- read_excel("metro_2009_three.xlsx")
metro_2009_2<- read_excel("metro_2009_two.xlsx")
metro_2010_1<- read_excel("metro_2010_one.xlsx")
metro_2010_3<- read_excel("metro_2010_three.xlsx")
metro_2010_2<- read_excel("metro_2010_two.xlsx")
metro_2011_1<- read_excel("metro_2011_one.xlsx")
metro_2011_3<- read_excel("metro_2011_three.xlsx")
metro_2011_2<- read_excel("metro_2011_two.xlsx")
metro_2012_1<- read_excel("metro_2012_one.xlsx")
metro_2012_3<- read_excel("metro_2012_three.xlsx")
metro_2012_2<- read_excel("metro_2012_two.xlsx")
metro_2013_1<- read_excel("metro_2013_one.xlsx")
metro_2013_2<- read_excel("metro_2013_two.xlsx")
metro_2014_1<- read_excel("metro_2014_one.xlsx")
metro_2015_1<- read_excel("metro_2015_one.xlsx")
metro_2016_1<- read_excel("metro_2016_one.xlsx")
metro_2017_1<- read_excel("metro_2017_one.xlsx")

metro_list <- list(metro97,metro97_2,metro_98,metro_98_2,metro_98_3,metro_99_1,metro_99_2,metro_2000_1,metro_2000_2,metro_2001_1,metro_2001_3,metro_2001_2,metro_2002_1,metro_2002_2,metro_2003_1,metro_2003_2,metro_2004_1,metro_2004_3,metro_2004_2,metro_2005_1,metro_2005_3,metro_2005_2,metro_2006_1,metro_2006_3,metro_2006_2,metro_2007_1,metro_2007_3,metro_2007_2,metro_2008_1,metro_2008_3,metro_2008_2,metro_2009_1,metro_2009_3,metro_2009_2,metro_2010_1,metro_2010_3,metro_2010_2,metro_2011_1,metro_2011_3,metro_2011_2,metro_2012_1,metro_2012_3,metro_2012_2,metro_2013_1,metro_2013_2,metro_2014_1,metro_2015_1,metro_2016_1,metro_2017_1)

#metro_list_names <- list("metro_2000_1","metro_2000_2","metro_2001_1","metro_2001_3","metro_2001_2","metro_2002_1","metro_2002_2","metro_2003_1","metro_2003_2","metro_2004_1","metro_2004_3","metro_2004_2","metro_2005_1","metro_2005_3","metro_2005_2","metro_2006_1","metro_2006_3","metro_2006_2","metro_2007_1","metro_2007_3","metro_2007_3","metro_2008_1","metro_2008_3","metro_2008_2","metro_2009_1","metro_2009_3","metro_2009_2","metro_2010_1","metro_2010_3","metro_2010_2","metro_2011_1","metro_2011_3","metro_2011_2","metro_2012_1","metro_2012_3","metro_2012_2","metro_2013_1","metro_2013_2","metro_2014_1","metro_2015_1","metro_2016_1","metro_2017_1")

metro_append_year <- mget(ls(pattern = '^metro_\\d{4}'))




addYear <- function(data, name){
  
  data %>% 
    mutate(year = substr(name,7,10))
  
}

results <- lapply(names(metro_append_year), function(nm) addYear(metro_append_year[[nm]], nm))

names(results) <- names(metro_append_year)

colnames_new <- colnames(results[[34]])

colnames_new <- replace(colnames_new,6,'GROUP')

colnames_new

results[34:41]<- lapply(results[34:41], setNames, colnames_new)

View(results)

group_4 <- results[1:2]
group_5 <- results[3:9]
group_6 <- results[10:24]
group_7 <- results[25:27]
group_8 <- results[28:42]


View(group_4)

group_4_new <- map(group_4, ~(.x %>% select(-release)))
group_6_new <- map(group_6, ~(.x %>% select(-HOURLY)))
group_7_new <- map(group_7, ~(.x %>% select(-c(HOURLY,JOBS_1000))))
group_8_new <- map(group_8, ~(.x %>% select(-c(HOURLY, JOBS_1000,'LOC QUOTIENT'))))

library(data.table)
group_4_df <- bind_rows(group_4_new, .id="column_label")
group_6_df <- bind_rows(group_6_new, .id="column_label")
group_7_df <- bind_rows(group_7_new, .id="column_label")
group_8_df <- bind_rows(group_8_new, .id="column_label")
group_5_df <- rbindlist(group_5)

group_8_df <- group_8_df %>% select(-OCC_GROUP)

new_group <- list(group_4_df,group_6_df,group_7_df,group_8_df)

new_master <- rbindlist(new_group)
new_master <- new_master %>% select(-column_label)
new_master <- rbindlist(list(new_master,group_5_df))

write.csv(new_master, file="bls_master.csv")

