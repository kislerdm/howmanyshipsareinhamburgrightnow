## How many ships are in HH right now
## author: D.Kisler <admin@dkisler.de>
## inspired by https://shipahoy.io
#app logic
source('app_settings.R', verbose = F, echo = F)
# the app's 'backend'
server <- function(input, output, session) {
  source("functions/datUtils.R", echo = F, local = T)
  source("functions/plotter.R", echo = F, local = T)
  # requests delay time in ms
  t_delay <<- 60000
  # fetch data every t_delay ms
  d <- reactive({ 
    invalidateLater(t_delay)
    datPreparator( datFetcher() )
  })
  # build initial interface 
  uiBuilder()
  output$map_location <- renderLeaflet(isolate(
    leaflet(d()) %>% 
      addTiles(options = tileOptions(maxZoom = 18, minZoom = 9)) %>%
      setMaxBounds(8, 53, 11, 55) %>% 
      addMarkers(lng = ~x, lat = ~y, group = 'ships', layerId = 'ships', icon = ship_icon, popup = ~popup, clusterOptions = markerClusterOptions(zoomToBoundsOnClick = T))  
  ))
  # update
  observe({
    if( nrow(d()) == 0) {
      # no data fetched
      uiBuilder(error = T)      
      output$status <- renderUI( HTML(paste0("<strong><em>Cannot fetch the data from AIS</em><strong>
                                       <br>Please send a report via <a href='mailto:admin@dkisler.de?subject=No data from AIS&body=%0D%0A%0D%0ATech data (DO NOT REMOVE):%0D%0Ats: ",
                                             as.character(Sys.time()),"%0D%0AError: no data found' target='blank_'>email</a>.")))
      t_delay <<- 1e10
    } else {
      # total numb. of ships in HH
      output$total_num <- renderUI( HTML( nrow(d()) ))
      # countdow to next data update
      t0 <<- Sys.time() + t_delay/1e3
      output$countdown <- renderUI({ HTML( "<strong>Next data update in ", round(difftime(t0, Sys.time(), 'secs'), 0), " sec." ) })    
      # update the map
      leafletProxy('map_location', data = d()) %>%
        clearMarkers() %>% clearGroup('ships') %>% 
        addMarkers(lng = ~x, lat = ~y, group = 'ships', layerId = 'ships', icon = ship_icon, popup = ~popup, clusterOptions = markerClusterOptions(zoomToBoundsOnClick = T))  
      # agg data for stats
      d_stats <- datAggregator(d()) %>% plotter()
      # draw stats plots
      output$stats_arrival <- renderPlotly(d_stats$arrival)
      output$stats_types <- renderPlotly(d_stats$types)
      output$stats_speed <- renderPlotly(d_stats$speed)
    }
  })
  # countdown to next data update
  observe({
    invalidateLater(t_delay/10)
    output$countdown <- renderUI({ HTML( "<strong>Next data update in ", round(difftime(t0, Sys.time(), 'secs'), 0), " sec." ) })    
  })
}

shinyApp(ui, server, enableBookmarking = 'url')