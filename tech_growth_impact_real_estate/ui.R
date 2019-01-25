shinyUI(
  fluidPage(
    titlePanel("Home Value and Tech Worker Growth"),
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
                                 selected="10"),
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
                       fluidRow(column(4,
                         pickerInput(inputId = "state_scatter", label = "Select State(s)", 
                                     choices= NULL, options = list(`actions-box` = TRUE),multiple = T
                                     )),column(8,
                         sliderInput(inputId = "year_scatter",
                                     label = "Select Year",
                                     min = 2000,
                                     max = 2016,
                                     value = 2000,
                                     sep = "",
                                     animate=TRUE
                                     )
                       )),
                       checkboxInput("checkbox", label = "scale x axis?", value = FALSE),
                       fluidRow(
                         plotlyOutput(outputId = "scatterplot_year")
                       )
              ), 
              # tabPanel("City Comparison",
              #   fluidRow(
              #    mainPanel(
              #      fluidRow(
              #          selectInput(inputId = "cities", label = "Select City",
              #                      choices= NULL)
              #      ),
              #      fluidRow(
              #           plotOutput(outputId = "value_plot")
              #      ),
              #      fluidRow(
              #        selectInput(inputId = "cities2", label = "Select City",
              #                    choices= NULL)
              #      ),
              #      fluidRow(
              #        plotOutput(outputId = "value_plot2")
              #      )
              #   )
              #  )
              # ), ## end of tabItem 2
              tabPanel("City Zestimate Over Time",
                fluidRow(
                 mainPanel(
                   fluidRow(
                       selectInput(inputId = "cityLine_city", label = "Select City",
                                   choices= NULL)
                   ),
                   fluidRow(
                        plotOutput(outputId = "cityLine_plot")
                   ),
                   fluidRow(
                     selectInput(inputId = "cityLine_city2", label = "Select City",
                                 choices= NULL)
                   ),
                   fluidRow(
                     plotOutput(outputId = "cityLine_plot2")
                   )
                )
               )
              ) ## end of cityZestimate tab
              # tabPanel("City Zestimate Over Time",
              #          fluidRow(
              #            mainPanel(
              #              fluidRow(
              #                selectInput(inputId = "blsLine_city", label = "Select City",
              #                            choices= NULL)
              #              ),
              #              fluidRow(
              #                plotOutput(outputId = "blsLine_plot")
              #              ),
              #              fluidRow(
              #                selectInput(inputId = "blsLine_city2", label = "Select City",
              #                            choices= NULL)
              #              ),
              #              fluidRow(
              #                plotOutput(outputId = "blsLine_plot2")
              #              )
              #            )
              #          )
              # ) ## end of BLS tab
            ) ## end of secondary tabs
        ) ## end of Chart tabPanel
      ) ## of main TabsetPanel
    ) ## end of fluidPage
  ) ## end of Shiny UI
