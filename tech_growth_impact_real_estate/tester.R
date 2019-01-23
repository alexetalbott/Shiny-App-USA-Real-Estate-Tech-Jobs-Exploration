library(shinydashboard)
library(shinythemes)
library(tidyverse)
library(ggmap)
library(leaflet)
library(scales)

master_data <- read_csv("data/master_data.csv")


grouped_2000 <- master_data %>% filter(year==2000) %>% select (city_state, math_and_programming_jobs, median_metro_value)

grouped_2000$pc <- predict(prcomp(~math_and_programming_jobs, grouped_2000))[,1]


scatter2000 <- ggplot(grouped_2000, aes(math_and_programming_jobs, median_metro_value, color = pc)) + 
  geom_point(shape=16, size=5, show.legend = FALSE, alpha=.4) + theme_minimal()  + 
  scale_y_continuous(labels=comma) + scale_color_gradient(low = "#0091ff", high = "#f0650e") +
  labs(title = paste0("Zestimate by Tech Jobs for the Year ", "2000"), x="# of Tech Jobs", y="Zestimate")

scatter2000
scatter2000 + scale_x_log10()

grouped_2000$math_and_programming_jobs <- as.double(grouped_2000$math_and_programming_jobs)

write_rds(master_data, "data/master_data.rds")
