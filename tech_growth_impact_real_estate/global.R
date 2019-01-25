#setwd("C:/Users/Alex/Google Drive/GIT/Zillow/tech_growth_impact_real_estate")
library(shinydashboard)
library(shiny)
library(shinyWidgets)
library(shinythemes)
library(tidyverse)
library(plotly)
library(ggmap)
library(leaflet)
library(scales)

master_data_non_contiguous <- read_rds("data/master_data_new.rds")

master_data <- master_data_non_contiguous %>% filter(!State %in% c("AK","HI"))

ngslim <- read_rds("data/ng_slim.rds")

ngslim <- ngslim %>% mutate(city_and_state = paste0(as.character(City),", ",as.character(State)))

bls_comp <- read_rds("data/bls_comp.rds")

bls_comp$tot_emp <- as.integer(bls_comp$tot_emp)