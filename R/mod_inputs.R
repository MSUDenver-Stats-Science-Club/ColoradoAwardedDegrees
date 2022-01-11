#' inputs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_inputs_ui <- function(id){
  ns <- NS(id)
  
  tagList(
    sidebarPanel(
      uiOutput(ns("sidebar"))
    )
  )
  
}
    
#' inputs Server Functions
#'
#' @noRd 
mod_inputs_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    ## Reactives ----
    rv$focus <- reactive(input$focus)
    rv$year <- reactive(input$year)
    rv$university <- reactive(input$unis)
    rv$program <- reactive(input$program)
    
    rv$data <- eventReactive({
      input$update
    }, {
      
      ## Validations ----
      validate(
        need(
          (!is.null(rv$university()) | nchar(rv$university()) > 0) & (!is.null(rv$program()) | nchar(rv$program()) > 0 ),
          glue::glue("Please select a university and program from the available choices!")
        )
      )
      
      ## Modify data ----
      if (rv$focus() == "Yearly") {
        
        ad <- app_data |>
        dplyr::filter(
          year %in% rv$year()
        )
      
        ## TODO - University and Program need to be modified so that if an option isn't selected all results are returned
        
        ad <- ad |>
          dplyr::filter(
            institutionname %in% rv$university()
          )
        
        ad <- ad |>
          dplyr::filter(
            programname %in% rv$program()
          )
        
      } else {
        
        ad <- app_data |>
          dplyr::filter(
            dplyr::between(year, rv$year()[1], rv$year()[2])
          )
        
        ## TODO - University and Program need to be modified so that if an option isn't selected all results are returned
        
        ad <- ad |>
          dplyr::filter(
            institutionname %in% rv$university()
          )
        
        ad <- ad |>
          dplyr::filter(
            programname %in% rv$program()
          )
        
      }
      
    })
    
    ## Render UI ----
    output$sidebar <- renderUI({
      
      tagList(
        h5("Options"),
        hr(),
        shinyWidgets::radioGroupButtons(
          ns("focus"),
          label = "Focus",
          choices = c("Yearly", "All"),
          selected = "Yearly",
          justified = TRUE
        ),
        hr(),
        uiOutput(ns("focus_options")),
        hr(),
        actionButton(
          ns("update"),
          label = "Update Data",
          icon = icon("redo-alt", class = "solid")
        )
      )
      
    })
    
    output$focus_options <- renderUI({
      req(rv$focus())
      
      if (rv$focus() == "Yearly") {
        
        ## Yearly Focus
        years <- sort(unique(app_data$year))
        
        tagList(
          selectInput(
            ns("year"),
            label = "Award Year",
            choices = years,
            selected = years[1]
          ),
          br(),
          uiOutput(ns("uni_sel")),
          br(),
          uiOutput(ns("prog_sel"))
        )
        
      } else {
        
        ## All Focus
        years <- sort(unique(app_data$year))
        
        tagList(
          shinyWidgets::sliderTextInput(
            ns("year"),
            label = "Award Years",
            choices = years,
            selected = c(min(years), max(years))
          ),
          br(),
          uiOutput(ns("uni_sel")),
          br(),
          uiOutput(ns("prog_sel"))
        )
        
      }

    })
    
    output$uni_sel <- renderUI({
      req(rv$focus())
      req(rv$year())

      if (rv$focus() == "Yearly") {
        
        unis <- app_data |>
          dplyr::filter(year %in% rv$year()) |>
          dplyr::pull(institutionname) |>
          unique() |>
          sort()

        selectInput(
          ns("unis"),
          label = "Universities",
          choices = unis,
          selected = unis[1],
          multiple = TRUE
        )
        
      } else {
        
        unis <- app_data |>
          dplyr::filter(dplyr::between(year, rv$year()[1], rv$year()[2])) |>
          dplyr::pull(institutionname) |>
          unique() |>
          sort()
        
        selectInput(
          ns("unis"),
          label = "Universities",
          choices = unis,
          selected = unis[1],
          multiple = TRUE
        )
        
      }
      
    })
    
    output$prog_sel <- renderUI({
      req(rv$focus())
      req(rv$year())
      req(rv$university())

      if (rv$focus() == "Yearly") {
      
        program <- app_data |>
          dplyr::filter(
            year %in% rv$year(),
            institutionname %in% rv$university()
          ) |>
          dplyr::pull(programname) |>
          unique() |>
          sort()
        
        selectInput(
          ns("program"),
          label = "Program Name",
          choices = program,
          selected = program[1],
          multiple = TRUE
        )
      
      } else {
        
        program <- app_data |>
          dplyr::filter(
            dplyr::between(year, rv$year()[1], rv$year()[2]),
            institutionname %in% rv$university()
          ) |>
          dplyr::pull(programname) |>
          unique() |>
          sort()
        
        selectInput(
          ns("program"),
          label = "Program Name",
          choices = program,
          selected = program[1],
          multiple = TRUE
        )
        
      }
      
    })
 
  })
}
    
## To be copied in the UI
# mod_inputs_ui("inputs_ui_1")
    
## To be copied in the server
# mod_inputs_server("inputs_ui_1")
