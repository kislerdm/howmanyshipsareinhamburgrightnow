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
    layout(title = 'Arrival Status', font = list(size = 18, color = 'black'), 
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
    layout(title = 'Ships Types', font = list(size = 18, color = 'black'), 
           margin = list(t = 50, l = 10, r = 10, b = 50),
           xaxis = list(title = '%', showgrid = T, zeroline = T, showticklabels = T),
           yaxis = list(title = F, showgrid = F, zeroline = F, showticklabels = F))
  # speed distr 
  p_speed <- df_agg$speed %>%
    plot_ly(x = ~speed, y  = ~share, color = ~speed, type = 'bar',
            hoverinfo = 'text',
            marker = list(colors = colors, line = list(color = '#000', width = 1)),
            textfont = list(size = 16),
            text = ~paste0("Speed Range: ", speed, " kn<br>N ships: ", n , " (", round(share, 2), "%)" ), 
            showlegend = F) %>% 
    layout(title = F, autosize = T, margin = list(t = 50, l = 40, r = 10, b = 110),
           xaxis = list(title = "Speed Over Ground [kn]", showgrid = T, zeroline = T, showticklabels = T, titlefont = list(size = 14)),
           yaxis = list(title = '%', showgrid = T, zeroline = T, showticklabels = T))
  
  # length distr 
  p_length <- df_agg$length %>%
    plot_ly(x = ~length, y  = ~share, color = ~length, type = 'bar',
            hoverinfo = 'text',
            marker = list(colors = colors, line = list(color = '#000', width = 1)),
            textfont = list(size = 16),
            text = ~paste0("Length Range: ", length, " m<br>N ships: ", n , " (", round(share, 2), "%)" ), 
            showlegend = F) %>% 
    layout(title = F, autosize = T, margin = list(t = 70, l = 40, r = 10, b = 80),
           xaxis = list(title = "Ship Length [m]", showgrid = T, zeroline = T, showticklabels = T, titlefont = list(size = 14)),
           yaxis = list(title = '%', showgrid = T, zeroline = T, showticklabels = T))
  
  p <- subplot(p_speed, p_length, nrows = 1, shareY = T, titleX = T, titleY = T) %>% 
    layout(annotations = list(
      list(x = 0.2, y = 1.2, text = 'Ships Speed', font = list(size = 18, color = 'black'), showarrow = F, xref = 'paper', yref = 'paper'),
      list(x = 0.8, y = 1.2, text = 'Ships Length', font = list(size = 18, color = 'black'), showarrow = F, xref = 'paper', yref = 'paper')),
      margin = list(t = 70, l = 40, r = 10, b = 100)      
    )
  
  return(list(
    arrival = p_arrive,
    types = p_types,
    length_speed = p
  ))
}
