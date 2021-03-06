#' home UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_home_ui <- function(id){
  ns <- NS(id)
  
  tagList(
    fluidPage(
      fluidRow(
        textOutput(ns("about"))
      )
    )
  )
  
}
    
#' home Server Functions
#'
#' @noRd 
mod_home_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$about <- renderText({
      
      message <- "This is an app meant to explore data pulled from the Colorado Information Marketplace related to degrees awarded by higher education institutions within Colorado between the years of 2001 and 2017."
      
    })
 
  })
}
    
## To be copied in the UI
# mod_home_ui("home_ui_1")
    
## To be copied in the server
# mod_home_server("home_ui_1")
