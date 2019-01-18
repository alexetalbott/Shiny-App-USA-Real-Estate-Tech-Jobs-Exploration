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
            selectInput(inputId = "n_rows_map", label = "Select Top:", 
                        choices=list("5" =5, "10"=10, "20"=20, "50"=50, "100"=100),
                        selected="5"),
            sliderInput(inputId = "year",
                        label = "Select Year",
                        min = 2000,
                        max = 2017,
                        value = 2000,
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