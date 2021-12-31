#' uni_map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 

library(leaflet)
mod_uni_map_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      uiOutput(ns("main"))
    )
  )
}
    
#' uni_map Server Functions
#'
#' @noRd 
mod_uni_map_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    ## Reactives ---
    
    ## Experimental Code ---
    
    ## Read in location dataset
    location_df <- readRDS("data/institution_locations.rds")
    
    ## Create map object
    colorado_counties <- maps::map("county", 'colorado', fill = TRUE, plot = FALSE)
    
    ## Render UI ---
    output$main <- renderUI({
      tagList(
        leafletOutput(ns("coloradoMap"))
      )
    })
    
    ## generate map output
    output$coloradoMap <- renderLeaflet({
      
      leaflet(data = colorado_counties, 
              options = leafletOptions(
                minZoom = 6.4,
                maxZoom = 12.5)
      ) |>
        addProviderTiles(providers$Thunderforest.MobileAtlas) |>
        addProviderTiles(providers$Stamen.TonerLines,
                         options = providerTileOptions(opacity = 0.35)) |>
        addProviderTiles(providers$Stamen.TonerLabels) |>
        addMarkers(~location_df$long, 
                   ~location_df$lat, 
                   popup = location_df$institutionname) |>
        addPolygons(
          color = "#444444",
          weight = 1.5,
          smoothFactor = 1,
          fillColor = RColorBrewer::brewer.pal(12, "Paired"),
          stroke = TRUE,
          highlightOptions = highlightOptions(
            stroke = TRUE,
            color = "white",
            weight = 5,
            bringToFront = TRUE)
        )
    })

  })
}
    
## To be copied in the UI
# mod_uni_map_ui("uni_map_ui_1")
    
## To be copied in the server
# mod_uni_map_server("uni_map_ui_1")

### Working on bringing everything over. 
