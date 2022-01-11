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
    sidebarLayout(
      sidebarPanel = mod_inputs_ui("inputs_ui_1"),
      mainPanel = mainPanel(
        uiOutput(ns("main"))
      ),
      position = "left"
    )
  )
  
}
    
#' analysis Server Functions
#'
#' @noRd 
mod_analysis_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    ## Reactives ----
    
    ## Render UI ----
    output$main <- renderUI({
      
      tagList(
        fluidPage(
          fluidRow(
            column(
              width = 3,
              uiOutput(ns("box_1"))
            ),
            column(
              width = 3,
              uiOutput(ns("box_2"))
            ),
            column(
              width = 3,
              uiOutput(ns("box_3"))
            ),
            column(
              width = 3,
              uiOutput(ns("box_4"))
            )
          ),
          br(),
          fluidRow(
            bs4Dash::box(
              width = 12,
              maximizable = TRUE,
              elevation = 1,
              plotly::plotlyOutput(ns("plot_1"))
            )
          )
        )
      )
      
    })
    
    output$box_1 <- renderUI({
      req(rv$data())
      req(rv$focus())
      
      bs4Dash::descriptionBlock(
        number = 0,
        numberColor = "olive",
        numberIcon = icon("caret-up"),
        header = "Header Text",
        text = "Box 1",
        rightBorder = TRUE
      )
      
    })
    
    output$box_2 <- renderUI({
      req(rv$data())
      req(rv$focus())
      
      bs4Dash::descriptionBlock(
        number = 0,
        numberColor = "olive",
        numberIcon = icon("caret-up"),
        header = "Header Text",
        text = "Box 2",
        rightBorder = TRUE
      )
      
    })
    
    output$box_3 <- renderUI({
      req(rv$data())
      req(rv$focus())
      
      bs4Dash::descriptionBlock(
        number = 0,
        numberColor = "olive",
        numberIcon = icon("caret-up"),
        header = "Header Text",
        text = "Box 3",
        rightBorder = TRUE
      )
      
    })
    
    output$box_4 <- renderUI({
      req(rv$data())
      req(rv$focus())
      
      bs4Dash::descriptionBlock(
        number = 0,
        numberColor = "olive",
        numberIcon = icon("caret-up"),
        header = "Header Text",
        text = "Box 4",
        rightBorder = FALSE
      )
      
    })
    
    output$plot_1 <- plotly::renderPlotly({
      req(rv$data())
      req(rv$focus())
      
      ## Need to incorporate options for yearly vs range views
      if (rv$focus() == "Yearly") {
        
        ad_count_by_uni <- rv$data() |>
          dplyr::group_by(
            year,
            institutionname
          ) |>
          dplyr::summarise(
            total_awarded = sum(recordcount, na.rm = TRUE)
          ) |>
          dplyr::ungroup() |>
          dplyr::arrange(
            total_awarded
          )

        plt <- plotly::plot_ly(
          type = "bar"
        ) |>
          plotly::add_trace(
            x = ~total_awarded,
            y = ~institutionname,
            data = ad_count_by_uni,
            marker = list(
              color = "#4F000B",
              line = list(
                color = "#000000",
                width = 1.5
              )
            ),
            hovertemplate = paste(
              "%{y}<br>",
              "Degrees Awarded: %{x}"
            ),
            showlegend = FALSE
          ) |>
          plotly::layout(
            title = "Total Degrees Awarded by University by Year",
            xaxis = list(title = "Degrees Awarded"),
            yaxis = list(title = "Institution")
          ) |>
          plotly::config(
            displayModeBar = FALSE
          )

        plt
        
      }
      
      ## TODO - Make plot for time series analysis of degrees awarded by selections
      
    })
    
    ## Observe Events ----
    
    ## Misc ----
 
  })
}
    
## To be copied in the UI
# mod_analysis_ui("analysis_ui_1")
    
## To be copied in the server
# mod_analysis_server("analysis_ui_1")
