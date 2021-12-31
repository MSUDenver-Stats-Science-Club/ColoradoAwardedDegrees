#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  
  ## Load in my data and set reactive values list
  app_data <<- get_data()
  rv <- reactiveValues()
  
  ## Modules here
  mod_home_server("home_ui_1", rv = rv)
  mod_analysis_server("analysis_ui_1", rv = rv)
  mod_inputs_server("inputs_ui_1", rv = rv)
  mod_uni_map_server("uni_map_ui_1", rv = rv)
  
}
