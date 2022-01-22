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
    mainPanel = mainPanel(
          uiOutput(ns("main"))
        ),
    absolutePanel(
      tagList(
        #h3("Testing!"),
        mod_map_inputs_ui("map_inputs_ui_1")
      ),
      
      top = "75px", left = "55px", 
      height = "auto", width = "1000px", 
      draggable = TRUE, 
      style = "opacity: 0.65; z-index:10;"
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
        leafletOutput(ns("coloradoMap"), height = "100vh", width = "100vw")
      )
    })
    
    ## generate leaflet output
    output$coloradoMap <- renderLeaflet({
      degree_count <- dplyr::count(app_data, institutionname)
      
      leaflet(data = colorado_counties, 
              options = leafletOptions(
                minZoom = 8,
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