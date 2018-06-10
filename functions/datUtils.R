## How many ships are in HH right now
## Author: D.Kisler <admin@dkisler.de>
# utils functions to opperate with data

# Function to fetch data via API of https://shipahoy.io
# All rights reserved to Maritime Data Systems GmbH and D.Kisler
datFetcher <- function() {
  library(jsonlite, verbose = F, quietly = T)
  
  dat <- tryCatch(fromJSON( gsub("\\@ts\\@", paste0(as.integer(Sys.time()), '000'), "https://shipahoy.io/#####") )$vessels ,
                  error = function(c) return(data.frame())
  ) %>% data.frame()
  return(dat)
}

# data pre-aggregation
datPreparator <- function(df) {
  if (nrow(df) == 0 ) return( NULL )
  
  suppressPackageStartupMessages(library(dplyr, quietly = T))
  # select imo, name, length, width, speed over ground, lon, lat, destination name
  df <- df[, grep('^(i|n|l|w|t|s|x|y|de)$', names(df))]
  
  # define logistic destination: Hamburg/ not Hamburg / NA
  df$arrival[grepl('(ham|hh|^h$)', df$de, ignore.case = T)] <- 'Arrival'
  df$arrival[!grepl('(ham|hh|^h$)', df$de, ignore.case = T)] <- 'Departure'
  df$arrival[grepl('n\\/a', df$de, ignore.case = T)] <- 'Unknown'
  # define the vessels type
  df$type <- 'Other'
  df$type[between(df$t, 80, 89)] <- 'Tanker'
  df$type[between(df$t, 70, 79)] <- 'Cargo'
  df$type[between(df$t, 60, 69)] <- 'Passenger'
  df$type[df$t == 30] <- 'Fishing Vessel'
  df$type[df$t %in% c(31, 33) | between(df$t, 50, 55)] <- 'Tugs and Special Craft'
  df$type[df$t %in% c(36, 37)] <- 'Pleasure Craft'
  df$type[df$t == 40] <- 'High Speed Craft'
  
  df %<>% mutate(link = case_when(i > 0 ~ paste0('<a href="https://www.trusteddocks.com/vessel/', i, '" target="_blank">', n, '</a>'), i == 0 ~ n),
                 popup = paste0('<strong>Name: </strong>', link,
                                '<br><strong>IMO: </strong>', i, '<br><strong>Lengh x Width: </strong>', l, "m x ", w, "m",
                                '<br><strong>Type: </strong>', type, '<br><strong>Speed: </strong>', s, " kn"))
  return(df)
}

# function to aggregate data to plot stats graphs
datAggregator <- function(df) {
  summarizer <- function(df_grouped) {
    df_grouped %>% summarise(n = n()) %>% mutate(share = n/sum(n)*100)
  }
  
  output <- df %>% 
  {
    list(
      # define moving vessels fraction
      length = mutate(., length = cut(l, breaks = c(seq(0, 350, 50), 1e4), labels = c('<50', paste0(seq(50,300,50), '-', seq(100,350,50)), '>350'), include.lowest = T, ordered_result = T)) %>% 
        group_by(length) %>% summarizer(),
      # define arrival ships
      arrival = group_by(.data = ., arrival) %>% summarizer(),
      # types stats
      types = group_by(.data = ., type) %>% summarizer(),
      # speed disttr
      speed = mutate(.data = ., speed = cut(s, breaks = c(0, 1e-3, 1, seq(5, 50, 5), 1e3), labels = c('0', '<1', '1-5', paste0(seq(5, 45, 5), '-', seq(10, 50, 5)), '>50'), include.lowest = T, ordered_result = T)) %>%
        group_by(speed) %>% summarizer()
    )
  }
}
