#' map_inputs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_map_inputs_ui <- function(id){
  ns <- NS(id)
  
  tagList(
    sidebarPanel(
      uiOutput(ns("sidebar"))
  )
 
  )
}
    
#' map_inputs Server Functions
#'
#' @noRd 
mod_map_inputs_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    ## Reactives ----
    rv$degreelevel <- reactive(input$degreelevel)
    # rv$ethnicity <- reactive(input$ethnicity)
    # rv$gender <- reactive(input$gender)
    
    rv$map_data <- eventReactive({
      input$update
    }, {
      
      ## Modify data ----
      #ad <- app_data
      
      validate(
        need(
          !is.null(rv$degreelevel()),
          glue::glue("Please select a degree level from the available choices!")
        )
      )
      
      #print("begin modifying data -----")
      ad <- app_data |>
        dplyr::filter(
          degreelevel %in% rv$degreelevel()
        )
      
    })
    
    ## Render UI ----
    output$sidebar <- renderUI({
      
      degreeLevels <- sort(unique(app_data$degreelevel))
      
      tagList(
        h3("Filters"),
        hr(),
        selectInput(
          ns("degreelevel"),
          label = "Degree Level",
          choices = degreeLevels,
          multiple = TRUE
        ),
        br(),
        hr(),
        actionButton(
          ns("update"),
          label = "Update Data",
          icon = icon("redo-alt", class = "solid")
        )
      )
      
    })
    
    
    
  })
}
    
## To be copied in the UI
# mod_map_inputs_ui("map_inputs_ui_1")
    
## To be copied in the server
# mod_map_inputs_server("map_inputs_ui_1")
