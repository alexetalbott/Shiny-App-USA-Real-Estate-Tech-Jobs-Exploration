shinyServer(function(input, output) {
  output$value_plot <- renderPlot({
    
    ggplot(master_data %>% filter(as.character(city_state) == input$cities)) + aes(x=year, y=median_metro_value) + geom_bar(stat="identity") + labs(title=paste0(input$cities," Real Estate"))
   
  })   
  
  output$tech_plot <- renderPlot({
    
    ggplot(master_data %>% filter(as.character(city_state) == input$cities)) + aes(x=year, y=math_and_programming_jobs) + geom_bar(stat="identity") + labs(title=paste0(input$cities," Tech Jobs"))
    
  })   
  
 output$maptable <- renderTable({
   
   master_data %>% filter(year == input$year) %>% arrange(desc(median_metro_value)) %>% head(input$n_rows_map)
#   %>% leaflet() %>% addProviderTiles("CartoDB") %>% addMarkers(popup = c(master_data$Metro,as.character(master_data$median_metro_value)))
   
   
 })
 
 points <- eventReactive(input$recalc, {
   cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
 }, ignoreNULL = FALSE)
  
 output$mymap <- renderLeaflet({
   
   map_data <- master_data %>% filter(year == input$year) %>% arrange(desc(median_metro_value))
   if
    (input$top_or_bottom == 1){
      map_data <- map_data %>% head(input$n_rows_map)
    }
   else {
     map_data <- map_data %>% tail(input$n_rows_map)
   }
   g <- map_data %>% leaflet() %>% addProviderTiles(providers$Stamen.TonerLite,options = providerTileOptions(noWrap = TRUE)) %>% addMarkers(popup = c(map_data$Metro,as.character(map_data$median_metro_value)))
   
   #
   #
   
   g
 })
  
  
  
  
})