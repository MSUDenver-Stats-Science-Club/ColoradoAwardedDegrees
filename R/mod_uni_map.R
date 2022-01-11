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
    titlePanel("Degrees Awarded by Region"),
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
                minZoom = 6,
                maxZoom = 18)
      ) |>
        addProviderTiles(providers$Thunderforest.MobileAtlas) |>
        addProviderTiles(providers$Stamen.TonerLines,
                         options = providerTileOptions(opacity = 0.35)) |>
        addProviderTiles(providers$Stamen.TonerLabels) |>
        addMarkers(rv$map_data()$long,
                   rv$map_data()$lat,
                   clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE)
                   ) |>
        addAwesomeMarkers(lng = unique(rv$map_data()$long),
                   lat = unique(rv$map_data()$lat), 
                   icon = awesomeIcons(icon = 'fa-university', 
                                       markerColor = 'green', 
                                       iconColor = 'black', 
                                       library = "fa"),
                   popup = unique(rv$map_data()$institutionname),
                   options = markerOptions(opacity = .6, 
                                           riseOnHover = TRUE)
                   ) |>
        addPolygons(
          color = "#444444",
          weight = 1.5,
          smoothFactor = 1, 
          fillColor = RColorBrewer::brewer.pal(11, "Spectral"),
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
