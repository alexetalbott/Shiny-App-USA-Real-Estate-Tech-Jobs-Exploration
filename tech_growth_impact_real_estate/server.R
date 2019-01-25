shinyServer(function(input, output, session) {
  
  yearInput <- reactive({
    if(input$dfcolumn == "median_metro_value"){
      master_data %>% filter(year == input$year) %>% arrange(desc(median_metro_value))
    } else {
      master_data %>% filter(year == input$year) %>% arrange(desc(math_and_programming_jobs))
    }
    
  })

  topbottomInput <- reactive({
    input$top_or_bottom})
  
  nrowsInput <- reactive({
    if (topbottomInput() == "bottom"){
    switch(input$n_rows_map,
           "5" = yearInput() %>% tail(5),
           "10" = yearInput() %>% tail(10),
           "20" = yearInput() %>% tail(20),
           "50" = yearInput() %>% tail(50),
           "100" = yearInput() %>% tail(100)
    )} 
    else {
   
    switch(input$n_rows_map,
           "5" = yearInput() %>% head(5),
           "10" = yearInput() %>% head(10),
           "20" = yearInput() %>% head(20),
           "50" = yearInput() %>% head(50),
           "100" = yearInput() %>% head(100)
    )}
  })
  

  output$mymap <- renderLeaflet({
    
    mapdata <- nrowsInput()
    
    radiusValue <- reactive({
      switch(input$dfcolumn,
             "median_metro_value" = mapdata$median_metro_value/100000,
             "math_and_programming_jobs" = mapdata$math_and_programming_jobs/10000
             
      )
    })

    mapdata %>% leaflet() %>% addProviderTiles(providers$Stamen.TonerLite,options = providerTileOptions(noWrap = TRUE)) %>%
      addCircleMarkers(lng=mapdata$lon, lat=mapdata$lat, radius= ~ radiusValue(), popup = paste0(mapdata$city_state,"<br>","Median Home Value: $",as.character(comma(mapdata$median_metro_value)),"<br>"," Tech Jobs: ",as.character(comma(mapdata$math_and_programming_jobs))))
    
})  
  output$maptable <- renderTable({
    
    tableshow <- nrowsInput() %>% select(Metro, State, math_and_programming_jobs, median_metro_value, year) %>% rename(`Tech Jobs`= math_and_programming_jobs, "Zestimate" = median_metro_value)
    tableshow
  })  
  
  ### page 2 tab 1
  

  observe({
    updateSelectInput(session = session, inputId = "state_scatter", choices = sort(unique(master_data$State)))
  })

  
  
  output$scatterplot_year <- renderPlotly({
    
    validate(need(input$state_scatter != "","     Please select at least one state"))
    
    grouped_year <- master_data %>% filter(year== as.integer(input$year_scatter) & State %in% input$state_scatter) %>% select(State,city_state, math_and_programming_jobs, median_metro_value)

    grouped_year$pc <- predict(prcomp(~math_and_programming_jobs, grouped_year))[,1]
    
    maxy <- master_data %>% filter(State %in% input$state_scatter) %>% select(median_metro_value) %>% max()
    
    maxx <- master_data %>% filter(State %in% input$state_scatter) %>% select(math_and_programming_jobs) %>% max()
    
    
    scatteryear <- ggplot(grouped_year, aes(math_and_programming_jobs, median_metro_value, color = State, label=city_state)) + 
      geom_point(shape=16, size=5, show.legend = FALSE, alpha=.4) + theme_minimal()  + 
      scale_y_continuous(labels=comma, limits = c(0,max(maxy)*1.2)) + #scale_color_gradient(low = "#0091ff", high = "#f0650e") +
      labs(title = paste0("Zestimate by Tech Jobs for the Year ", input$year_scatter), x="# of Tech Jobs", y="Zestimate") +
      #scale_x_log10() + # + coord_flip()
    ylim(0,max(maxy)*1.2) + 
    xlim(0,max(maxx)*1.2)
    
    if (input$checkbox == TRUE){
      scatteryear2 <- scatteryear + scale_x_continuous(trans="log10",limits=(c(NA,1e6)))
      ggplotly(scatteryear2)
    } else {
      ggplotly(scatteryear)
    }
    
  })
  
  ## page 2 tab 2

  
  observe({
    updateSelectInput(session = session, inputId = "cities", choices = sort(unique(master_data$city_state)))
  })
  
  observe({
    updateSelectInput(session = session, inputId = "cities2", choices = sort(unique(master_data$city_state)))
  })
  
  output$value_plot <- renderPlot({
    
    dfn <- master_data %>% mutate(math_and_programming_jobs = math_and_programming_jobs*5)
    dfnn <- dfn %>% gather(metric,value,math_and_programming_jobs:median_metro_value) %>% filter(city_state == input$cities) %>% select(city_state,year,metric,value)
    
    
    ggplot(dfnn) + aes(x=year, y=value) + geom_bar(aes(fill=metric), stat="identity", position= position_dodge(width=0.65), width=0.9)+
      scale_y_continuous(sec.axis = sec_axis(~.*.2))  + labs(title=paste0(input$cities," Real Estate & Tech Jobs"))
    
  })   
  
  output$value_plot2 <- renderPlot({
    
    dfn <- master_data %>% mutate(math_and_programming_jobs = math_and_programming_jobs*5)
    dfnn <- dfn %>% gather(metric,value,math_and_programming_jobs:median_metro_value) %>% filter(city_state == input$cities2) %>% select(city_state,year,metric,value)
    
    
    ggplot(dfnn) + aes(x=year, y=value) + geom_bar(aes(fill=metric), stat="identity", position= position_dodge(width=0.65), width=0.9)+
      scale_y_continuous(sec.axis = sec_axis(~.*.2))  + labs(title=paste0(input$cities2," Real Estate & Tech Jobs"))

  })   
  
  observe({
    updateSelectInput(session = session, inputId = "cityLine_city", choices = sort(unique(ngslim$city_and_state)))
  })

  observe({
    updateSelectInput(session = session, inputId = "cityLine_city2", choices = sort(unique(ngslim$city_and_state)))
  })


  output$cityLine_plot <- renderPlot({
    sumCity <- ngslim %>% group_by(city_and_state, City, State, year) %>% summarise(home_value = mean(median_value))

    cityLineOutput <- sumCity %>% filter(city_and_state==as.character(input$cityLine_city))

    ggplot(cityLineOutput) + aes(x=year,y=home_value) + geom_line() + geom_point(shape=21, size=3) + scale_fill_manual(values="white") + ylab("Zestimate") +
      labs(title=paste0(as.character(input$cityLine_city)," Home Values"))
  })

  output$cityLine_plot2 <- renderPlot({
    sumCity2 <- ngslim %>% group_by(city_and_state, City, State, year) %>% summarise(home_value = mean(median_value))

    cityLineOutput2 <- sumCity2 %>% filter(city_and_state==as.character(input$cityLine_city2))
    
    ggplot(cityLineOutput2) + aes(x=year,y=home_value) + geom_line() + geom_point(shape=21, size=3) + scale_fill_manual(values="black") + ylab("Zestimate") +
      labs(title=paste0(as.character(input$cityLine_city2)," Home Values"))

  })
  # begin blsLine
  # observe({
  #   updateSelectInput(session = session, inputId = "blsLine_city", choices = sort(unique(ngslim$city_and_state)))
  # })
  # 
  # observe({
  #   updateSelectInput(session = session, inputId = "blsLine_city2", choices = sort(unique(ngslim$city_and_state)))
  # })
  # 
  # 
  # output$cityLine_plot <- renderPlot({
  #   sumCity <- ngslim %>% group_by(city_and_state, City, State, year) %>% summarise(home_value = mean(median_value))
  #   
  #   cityLineOutput <- sumCity %>% filter(city_and_state==as.character(input$cityLine_city))
  #   
  #   ggplot(cityLineOutput) + aes(x=year,y=home_value) + geom_line() + geom_point() + ylab("Zestimate")
  #   
  # })
  # 
  # output$cityLine_plot2 <- renderPlot({
  #   sumCity2 <- ngslim %>% group_by(city_and_state, City, State, year) %>% summarise(home_value = mean(median_value))
  #   
  #   cityLineOutput2 <- sumCity2 %>% filter(city_and_state==as.character(input$cityLine_city2))
  #   ggplot(cityLineOutput2) + aes(x=year,y=home_value) + geom_line() + geom_point() + ylab("Zestimate")
  #   
  # })
  # 

})