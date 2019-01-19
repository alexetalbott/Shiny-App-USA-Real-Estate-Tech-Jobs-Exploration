shinyUI(
  fluidPage(
    tabsetPanel(
      tabPanel("Map",
               sidebarLayout(
                 sidebarPanel(
                   selectInput(inputId = "top_or_bottom", label = "Select:", 
                               choices=list("Top" = 1, "Bottom" = 0),
                               selected="Top"),
                   selectInput(inputId = "n_rows_map", label = "(Choose a quantity)", 
                               choices=list("5" =5, "10"=10, "20"=20, "50"=50, "100"=100),
                               selected="5"),
                   sliderInput(inputId = "year",
                               label = "from the year",
                               min = 2000,
                               max = 2016,
                               value = 2007,
                               sep = ""
                   ),
                   selectInput(inputId = "dfcolumn", label = "by", 
                               choices=list("Median Zillow Home Value Estimate" = 0, "Total Programming Jobs" = 1),
                               selected="Median Zillow Home Value Estimate")
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
      )
    )
  )
)
