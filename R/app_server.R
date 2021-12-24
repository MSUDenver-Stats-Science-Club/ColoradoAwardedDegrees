#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  
  app_data <- get_data()
  
  clean_data <- clean_data(app_data)
  
  rv <- reactiveValues()
  rv$data <- clean_data
  
  ## Modules here
  mod_home_server("home_ui_1", rv = rv)
  mod_analysis_server("analysis_ui_1", rv = rv)
  
}
