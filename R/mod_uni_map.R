#' uni_map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList fillPage absolutePanel uiOutput
#' @import leaflet
mod_uni_map_ui <- function(id){
  ns <- NS(id)
  
  tagList(
    uiOutput(ns("main")),
    absolutePanel(
      mod_map_inputs_ui("map_inputs_ui_1"),
      top = 150,
      left = 30,
      height = "auto",
      width = 300, 
      draggable = TRUE,
      style = "z-index: 100;"
      # opacity: .75;
    )
  )
  
}

#' uni_map Server Functions
#'
#' @noRd
#' @import leaflet
mod_uni_map_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    ## Reactives ---
    
    
    ## Create map object
    colorado_counties <- maps::map("county", 'colorado', fill = TRUE, plot = FALSE)
    
    ## Render UI ---
    output$main <- renderUI({
      tagList(
        leafletOutput(ns("coloradoMap"), height = "88vh", width = "98vw")
      )
    })
    
    ## generate leaflet output
    output$coloradoMap <- renderLeaflet({
      degree_count <- dplyr::count(app_data, institutionname)
      
      m <- leaflet(
        data = colorado_counties, 
        options = leafletOptions(
          minZoom = 8,
          maxZoom = 18)
      ) %>%
        addProviderTiles(
          providers$Thunderforest.MobileAtlas
        ) %>%
        addProviderTiles(
          providers$Stamen.TonerLines,
          options = providerTileOptions(opacity = 0.35)
        ) %>%
        addProviderTiles(providers$Stamen.TonerLabels) %>%
        addMarkers(
          app_data$long,
          app_data$lat,
          clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE)
        ) %>%
        addMarkers(
          unique(app_data$long),
          unique(app_data$lat),
          popup = unique(app_data$institutionname)
        ) %>%
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
        ) %>%
        setMaxBounds(
          lng1 = -109.917735,
          lat1 = 41.441283,
          lng2 = -101.265238,
          lat2 = 36.649823
        )
    })
  })
}