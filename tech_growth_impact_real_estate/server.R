shinyServer(function(input, output) {
  
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
           "5" = yearInput() %>% tail(),
           "10" = yearInput() %>% tail(10),
           "20" = yearInput() %>% tail(20),
           "50" = yearInput() %>% tail(50),
           "100" = yearInput() %>% tail(100)
    )} 
    else {
   
    switch(input$n_rows_map,
           "5" = yearInput() %>% head(),
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
             "math_and_programming_jobs" = mapdata$math_and_programming_jobs/5000
             
      )
    })

    mapdata %>% leaflet() %>% addProviderTiles(providers$Stamen.TonerLite,options = providerTileOptions(noWrap = TRUE)) %>%
      addCircleMarkers(lng=mapdata$lon, lat=mapdata$lat, radius= ~ radiusValue(), popup = paste0("Median Home Value: $",as.character(comma(mapdata$median_metro_value)),"<br>"," Tech Jobs: ",as.character(comma(mapdata$math_and_programming_jobs))))
    
})  
  output$maptable <- renderTable({
    
    tableshow <- nrowsInput()
    tableshow
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

})