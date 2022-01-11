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
    sidebarLayout(
      sidebarPanel = mod_map_inputs_ui("map_inputs_ui_1"),
      mainPanel = mainPanel(
        uiOutput(ns("main"))
      ),
      position = "left"
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
    
    ## Create map object
    colorado_counties <- maps::map("county", 'colorado', fill = TRUE, plot = FALSE)
    
    ## Render UI ---
    output$main <- renderUI({
      tagList(
        leafletOutput(ns("coloradoMap"))
      )
    })
    
    ## generate leaflet output
    output$coloradoMap <- renderLeaflet({
      degree_count <- dplyr::count(app_data, institutionname)
      
      leaflet(data = colorado_counties, 
              options = leafletOptions(
                minZoom = 6.4,
                maxZoom = 18)
      ) |>
        addProviderTiles(providers$Thunderforest.MobileAtlas) |>
        addProviderTiles(providers$Stamen.TonerLines,
                         options = providerTileOptions(opacity = 0.35)) |>
        addProviderTiles(providers$Stamen.TonerLabels) |>
        addMarkers(app_data$long,
                   app_data$lat,
                   clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE)
                   ) |>
        addMarkers(unique(app_data$long),
                   unique(app_data$lat),
                   popup = unique(app_data$institutionname)
                   ) |>
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
