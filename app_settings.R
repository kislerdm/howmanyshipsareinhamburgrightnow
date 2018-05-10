## How many ships are in HH right now
## author: D.Kisler <admin@dkisler.de>
# App settings
suppressPackageStartupMessages({
  library(dplyr, verbose = F, warn.conflicts = F, quietly = T)
  library(magrittr, verbose = F, warn.conflicts = F, quietly = T)
  library(shiny, verbose = F, warn.conflicts = F, quietly = T)
  library(shinyBS, verbose = F, warn.conflicts = F, quietly = T)
  library(shinyjs, verbose = F, warn.conflicts = F, quietly = T)
  library(jsonlite, verbose = F, warn.conflicts = F, quietly = T)
  library(leaflet, verbose = F, warn.conflicts = F, quietly = T)
  library(plotly, verbose = F, warn.conflicts = F, quietly = T)
  library(rmarkdown, verbose = F, warn.conflicts = F, quietly = T)
})

## ship icon
ship_icon <- makeIcon('www/ship.png')

## UI
source("ui.R")
