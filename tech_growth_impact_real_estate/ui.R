shinyUI(
  fluidPage(
    theme = shinytheme("sandstone"),
      tabsetPanel(
        tabPanel("Map",
                 sidebarLayout(
                   sidebarPanel(
                     selectInput(inputId = "top_or_bottom", label = "Select:", 
                                 choices=list("Top" = "top", "Bottom" = "bottom"),
                                 selected="Top"),
                     selectInput(inputId = "n_rows_map", label = "(Choose a quantity)", 
                                 choices=list("5", "10", "20", "50", "100"),
                                 selected="5"),
                     sliderInput(inputId = "year",
                                 label = "from the year",
                                 min = 2000,
                                 max = 2016,
                                 value = 2007,
                                 sep = ""
                     ),
                     selectInput(inputId = "dfcolumn", label = "by", 
                                 choices=list("Median Zestimate"= "median_metro_value", "Total Programming Jobs" = "math_and_programming_jobs"),
                                 selected="Median Zestimate"),
                     actionButton("recalculate","Recalculate")
                   ),
                   mainPanel(
                     fluidRow(
                       box(
                         leafletOutput("mymap",width=950)
                       )
                     ),
                     fluidRow(
                       box(
                         tableOutput(outputId = "maptable")
                       )
                     )
                   )
                 )       
        ),
        tabPanel("Charts",
            tabsetPanel(
              tabPanel("State Scatterplot",
                       sliderInput(inputId = "year_scatter",
                                   label = "Select Year",
                                   min = 2000,
                                   max = 2016,
                                   value = 2000,
                                   sep = "",
                                   animate=TRUE
                       ),
                       pickerInput(inputId = "state_scatter", label = "Select State", 
                                   choices= NULL, options = list(`actions-box` = TRUE),multiple = T),
                       checkboxInput("checkbox", label = "scale x axis?", value = FALSE),
                       fluidRow(
                         plotlyOutput(outputId = "scatterplot_year")
                       )
              ), 
              tabPanel("City Comparison",     
                fluidRow(
                 mainPanel(
                   fluidRow(
                       selectInput(inputId = "cities2", label = "Select City", 
                                   choices= NULL)
                   ),
                   fluidRow(
                        plotOutput(outputId = "value_plot")
                   ),
                   fluidRow(
                     selectInput(inputId = "cities2", label = "Select City", 
                                 choices= NULL)
                   ),
                   fluidRow(
                     plotOutput(outputId = "value_plot2")
                   )
                )
               )
              ) ## end of tabItem 2
            ) ## end of second page tabItems
        ) ## end of Chart tabPanel
      ) ## of main TabsetPanel
    ) ## end of fluidPage
  ) ## end of Shiny UI
