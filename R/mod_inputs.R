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
      ## None currently needed
      
      ## Modify data ----
      if (rv$focus() == "Yearly") {
        ## Filter down the data to the year in focus
        ad <- app_data %>%
          dplyr::select(
            -county:long
          ) %>%
          dplyr::filter(
            year %in% as.integer(rv$year())
          )
      } else {
        ## Filter data to range selected
        ad <- app_data %>%
          dplyr::filter(
            dplyr::between(year, rv$year()[1], rv$year()[2])
          )
      }
      
      if (!is.null(rv$university())) {
        ad <- ad %>%
          dplyr::filter(
            institutionname %in% rv$university()
          )
      }
      
      if (!is.null(rv$program())) {
        ad <- ad %>%
          dplyr::filter(
            programname %in% rv$program()
          )
      }
      
      return(ad)
      
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
        
        unis <- app_data %>%
          dplyr::filter(year %in% rv$year()) %>%
          dplyr::pull(institutionname) %>%
          unique() %>%
          sort()

        selectInput(
          ns("unis"),
          label = "Universities",
          choices = unis,
          multiple = TRUE
        )
        
      } else {
        
        unis <- app_data %>%
          dplyr::filter(dplyr::between(year, rv$year()[1], rv$year()[2])) %>%
          dplyr::pull(institutionname) %>%
          unique() %>%
          sort()
        
        selectInput(
          ns("unis"),
          label = "Universities",
          choices = unis,
          multiple = TRUE
        )
        
      }
      
    })
    
    output$prog_sel <- renderUI({
      req(rv$focus())
      req(rv$year())
      req(rv$university())

      if (rv$focus() == "Yearly") {
      
        program <- app_data %>%
          dplyr::filter(
            year %in% rv$year(),
            institutionname %in% rv$university()
          ) %>%
          dplyr::pull(programname) %>%
          unique() %>%
          sort()
        
        selectInput(
          ns("program"),
          label = "Program Name",
          choices = program,
          multiple = TRUE
        )
      
      } else {
        
        program <- app_data %>%
          dplyr::filter(
            dplyr::between(year, rv$year()[1], rv$year()[2]),
            institutionname %in% rv$university()
          ) %>%
          dplyr::pull(programname) %>%
          unique() %>%
          sort()
        
        selectInput(
          ns("program"),
          label = "Program Name",
          choices = program,
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
