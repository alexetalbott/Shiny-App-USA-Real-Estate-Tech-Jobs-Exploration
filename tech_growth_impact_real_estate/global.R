library(shinydashboard)
library(shiny)
library(shinyWidgets)
library(shinythemes)
library(tidyverse)
library(plotly)
library(ggmap)
library(leaflet)
library(scales)

master_data_non_contiguous <- read_rds("data/master_data.rds")

master_data <- master_data_non_contiguous %>% filter(!State %in% c("AK","HI"))

