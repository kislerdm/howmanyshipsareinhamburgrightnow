## How many ships are in HH right now
## Author: D.Kisler <admin@dkisler.de>
# plotter function

plotter <- function(df_agg) {
  # arrival ships
  p_arrive <- df_agg$arrival %>% 
    plot_ly(labels = ~arrival, values  = ~n, type = 'pie',
            textposition = 'inside', textinfo = 'label+percent', insidetextfont = list(color = '#000'),
            hoverinfo = 'text',
            marker = list(colors = colors, line = list(color = '#000', width = 1)),
            textfont = list(size = 16),
            text = ~paste0(arrival, "<br>N ships: ", n , " (", round(share, 2), "%)" ), 
            showlegend = F) %>% 
    layout(title = 'Arrival Status', font = list(size = 18), 
           margin = list(t = 50, l = 10, r = 10, b = 20),
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  # ship types
  p_types <- df_agg$types %>%
    plot_ly(y = ~reorder(type, n), x  = ~n, color = ~type, type = 'bar',
            textposition = 'auto', insidetextfont = list(color = '#000'),
            hoverinfo = 'text',
            marker = list(colors = colors, line = list(color = '#000', width = 1)),
            textfont = list(size = 16),
            text = ~paste0(type, "<br>N ships: ", n , " (", round(share, 2), "%)" ), 
            showlegend = F) %>% 
    layout(title = 'Ships Types', font = list(size = 18), 
           margin = list(t = 50, l = 10, r = 10, b = 20),
           xaxis = list(title = F, showgrid = T, zeroline = T, showticklabels = T),
           yaxis = list(title = F, showgrid = F, zeroline = F, showticklabels = F))
  # speed distr 
  p_speed <- df_agg$speed %>%
    plot_ly(x = ~speed, y  = ~n, color = ~speed, type = 'bar',
            hoverinfo = 'text',
            marker = list(colors = colors, line = list(color = '#000', width = 1)),
            textfont = list(size = 16),
            text = ~paste0("Speed Range: ", speed, " kn<br>N ships: ", n , " (", round(share, 2), "%)" ), 
            showlegend = F) %>% 
    layout(title = 'Ships Speed', font = list(size = 18), 
           autosize = T, margin = list(t = 50, l = 40, r = 10, b = 80),
           xaxis = list(title = "Speed Over Ground [kn]", showgrid = T, zeroline = T, showticklabels = T, titlefont = list(size = 14)),
           yaxis = list(title = F, showgrid = T, zeroline = T, showticklabels = T))
  return(list(
    arrival = p_arrive,
    types = p_types,
    speed = p_speed
  ))
}
