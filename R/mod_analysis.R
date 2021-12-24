#' analysis UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_analysis_ui <- function(id){
  ns <- NS(id)
  
  tagList(
    fluidPage(
      fluidRow(
        DT::dataTableOutput(ns("table"))
      )
    )
  )
  
}
    
#' analysis Server Functions
#'
#' @noRd 
mod_analysis_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$table <- DT::renderDataTable({
      
      rv$data
      
    })
 
  })
}
    
## To be copied in the UI
# mod_analysis_ui("analysis_ui_1")
    
## To be copied in the server
# mod_analysis_server("analysis_ui_1")
