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
              tabPanel("City Comparison",     
                fluidRow(
                 mainPanel(
                   fluidRow(
                    selectInput(inputId = "cities", label = "Select City", 
                                choices=list("Austin-Round Rock, TX" = "Austin-Round Rock, TX",
                                             "Columbus, OH"="Columbus, OH","Pittsburgh, PA"="Pittsburgh, PA"),
                                selected="Austin-Round Rock, TX")
                   ),
                   fluidRow(
                        plotOutput(outputId = "value_plot")
                   ),
                   fluidRow(
                     selectInput(inputId = "cities2", label = "Select City", 
                                 choices=list("Austin-Round Rock, TX" = "Austin-Round Rock, TX",
                                              "Columbus, OH"="Columbus, OH","Pittsburgh, PA"="Pittsburgh, PA"),
                                 selected="Columbus, OH")
                   ),
                   fluidRow(
                     plotOutput(outputId = "value_plot2")
                   )
                )
               )
              ),
              tabPanel("Scatterplot",
                selectInput(inputId = "year_scatter", label = "Select Year", 
                            choices=list("2000" = "2000","2005"="2005","2010"="2010","2015"="2015"),
                            selected="2000"),
                 fluidRow(
                   plotlyOutput(outputId = "scatterplot_year")
                 )
              ) ## end of tabItem 2
            ) ## end of tabItems
        ) ## end of Chart tabPanel
      ) ## of main TabsetPanel
    ) ## end of fluidPage
  ) ## end of Shiny UI
