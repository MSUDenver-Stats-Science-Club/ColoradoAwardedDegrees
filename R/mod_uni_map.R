#' uni_map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_uni_map_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' uni_map Server Functions
#'
#' @noRd 
mod_uni_map_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_uni_map_ui("uni_map_ui_1")
    
## To be copied in the server
# mod_uni_map_server("uni_map_ui_1")
