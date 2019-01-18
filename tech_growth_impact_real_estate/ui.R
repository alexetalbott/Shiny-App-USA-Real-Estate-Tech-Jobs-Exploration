shinyUI(
  fluidPage(
    tabsetPanel(
      tabPanel("Charts",
        sidebarLayout(
          sidebarPanel(
            "This is the sidebar"
          ),
          mainPanel(
            selectInput(inputId = "cities", label = "Select City", 
                        choices=list("Austin-Round Rock, TX" = "Austin-Round Rock, TX",
                                     "Columbus, OH"="Columbus, OH","Pittsburgh, PA"="Pittsburgh, PA"),
                        selected="Austin-Round Rock, TX"),
            box(
              plotOutput(outputId = "value_plot")
            ),
            box(
              plotOutput(outputId = "tech_plot")
            )
          )
        )
      ),
      tabPanel("Map",
        sidebarLayout(
          sidebarPanel(
            "This is another sidebar"
          ),
          mainPanel(
            selectInput(inputId = "top_or_bottom", label = "Select:", 
                        choices=list("Top" = 1, "Bottom" = 0),
                        selected="Top"),
            selectInput(inputId = "n_rows_map", label = "(Choose a quantity)", 
                        choices=list("5" =5, "10"=10, "20"=20, "50"=50, "100"=100),
                        selected="5"),
            sliderInput(inputId = "year",
                        label = "from the year",
                        min = 2000,
                        max = 2017,
                        value = 2007,
                        sep = ""
                        ),
            box(
              leafletOutput("mymap")
            ),
            box(
              tableOutput(outputId = "maptable")
            )
          )
        )       
      )
    )
  )
  
  
)