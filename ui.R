## How many ships are in HH right now
## author: D.Kisler <admin@dkisler.de>
# UI code
ui <- bootstrapPage(
  tags$div(class = 'ui',  
           fluidPage(
             #google analytics js
             includeScript("functions/ga.js"),
             fluidRow(
               useShinyjs(),
               includeCSS('www/styles.css'),
               tags$div(id = 'placeholder', tags$div(id = 'dash_area', tags$img(src = "loader.gif", id = "loading-spinner")))
             ))
  )
)

# UI builder
uiBuilder <- function(error = F) {
  # remove existing container
  removeUI(selector = "#dash_area")
  if (error) {
    insertUI(selector = "#placeholder", ui = tags$div(id = "dash_area", uiOutput("status", align = "center")))
  } else {
    insertUI(selector = "#placeholder", 
             ui = tags$div(id = 'dash_area',
                           fluidRow(column(width = 2), 
                                    column(width = 8,
                                           tags$div(id = 'tot_num', align = 'center', uiOutput('total_num'), 
                                                    tags$div(id = 'timer', uiOutput('countdown')) ),
                                           tags$div(id = 'map', leafletOutput('map_location', height = '100%')),
                                           tags$div(id = 'stats', 
                                                    tags$div(id = 'stats_title', h2('Ships in Harbor Stats', align = 'center')),
                                                    fluidRow(
                                                      column(width = 6, plotlyOutput('stats_arrival', width = '90%')),
                                                      column(width = 6, plotlyOutput('stats_types', width = '90%'))
                                                    ),
                                                    fluidRow( column(width = 12, plotlyOutput('stats_speed', width = '98%')) )
                                           )
                                    ),
                                    column(width = 2)),
                           fluidRow(
                             tags$div(id = 'footer', align = "center",
                                      tags$div(id = 'about', actionLink('about', label = 'About')),
                                      tags$div(id = 'copyright',
                                               HTML(paste0("Powered by <a href='https://shipahoy.io' target='blank_'>shipahoy.io</a> - Product of <a href='http://www.maritimedatasystems.com' target='blank_'>Maritime Data Systems GmbH</a><br>",
                                                           format(Sys.Date(), '%Y'), " © <a href='https://www.dkisler.de' target='blank_'>Dmitry Kisler</a>"))
                                      )
                             )
                           ),
                           bsModal('about_popup', title = 'About', trigger = 'about', size = 'large', tags$div(id = 'popup', align = 'left', includeMarkdown('about.md')))
             )
    )
  }
}
