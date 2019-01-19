shinyServer(function(input, output) {
  output$value_plot <- renderPlot({
    
    dfn <- master_data %>% mutate(math_and_programming_jobs = math_and_programming_jobs*5)
    dfnn <- dfn %>% gather(metric,value,math_and_programming_jobs:median_metro_value) %>% filter(city_state == input$cities) %>% select(city_state,year,metric,value)
    
    
    ggplot(dfnn) + aes(x=year, y=value) + geom_bar(aes(fill=metric), stat="identity", position= position_dodge(width=0.65), width=0.9)+
      scale_y_continuous(sec.axis = sec_axis(~.*.2))  + labs(title=paste0(input$cities," Real Estate & Tech Jobs"))
    
    
    
#    dfn <- master_data %>% gather(metric,value,math_and_programming_jobs:median_metro_value) %>% select(city_state,year,metric,value) %>% filter(as.character(city_state == input$cities))
#    ggplot(dfn) + aes(x=year, y=value) + geom_bar(aes(fill=metric), stat="identity", position="dodge") + labs(title=paste0(input$cities," Real Estate & Tech Jobs"))+
#    geom_bar(data=master_data %>% filter(as.character(city_state) == input$cities),aes(x=year, y=math_and_programming_jobs),stat="identity",fill="tan1", position="dodge") +
#    scale_y_continuous(sec.axis = sec_axis(~.*0.5))
  })   
  
  output$value_plot2 <- renderPlot({
    
    dfn <- master_data %>% mutate(math_and_programming_jobs = math_and_programming_jobs*5)
    dfnn <- dfn %>% gather(metric,value,math_and_programming_jobs:median_metro_value) %>% filter(city_state == input$cities2) %>% select(city_state,year,metric,value)
    
    
    ggplot(dfnn) + aes(x=year, y=value) + geom_bar(aes(fill=metric), stat="identity", position= position_dodge(width=0.65), width=0.9)+
      scale_y_continuous(sec.axis = sec_axis(~.*.2))  + labs(title=paste0(input$cities2," Real Estate & Tech Jobs"))

  })   
  
  # output$tech_plot <- renderPlot({
  #   
  #   ggplot(master_data %>% filter(as.character(city_state) == input$cities)) + aes(x=year, y=math_and_programming_jobs) + geom_bar(stat="identity") + labs(title=paste0(input$cities," Tech Jobs"))
  #   
  # })   
  
 output$maptable <- renderTable({
   
   t <- master_data %>% select(Metro,State,math_and_programming_jobs,median_metro_value,year) %>% filter(year == input$year)
     
   if
   (input$dfcolumn == 1){
     t <- t %>% arrange(desc(math_and_programming_jobs))
   }
   else {
     t <- t %>% arrange(desc(median_metro_value))
   }
   
   if
   (input$top_or_bottom == 1){
     t <- t %>% head(input$n_rows_map)
   }
   else {
     t <- t %>% tail(input$n_rows_map)
   }
   
  t 
   
 })
 
 points <- eventReactive(input$recalc, {
   cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
 }, ignoreNULL = FALSE)
  
 output$mymap <- renderLeaflet({
   
   map_data <- master_data %>% filter(year == input$year) %>% arrange(desc(median_metro_value))

   if
   (input$dfcolumn == 1){
     map_data <- map_data %>% arrange(desc(as.integer(map_data$math_and_programming_jobs)))
   }
   else {
     map_data <- map_data %>% arrange(desc(map_data$median_metro_value))
   }
   
   if
   (input$top_or_bottom == 1){
     map_data <- map_data %>% head(input$n_rows_map)
   }
   else {
     map_data <- map_data %>% tail(input$n_rows_map)
   }
   
   map_data %>% leaflet() %>% addProviderTiles(providers$Stamen.TonerLite,options = providerTileOptions(noWrap = TRUE)) %>% addMarkers(popup = c(map_data$Metro,as.character(map_data$median_metro_value)))
   
 })
  
  
  
  
})