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
      sidebarPanel = sidebarPanel(
        uiOutput(ns("sidebar"))
      ),
      mainPanel = mainPanel(
        uiOutput(ns("main"))
      ),
      position = "left"
    )
  )
  
  # fluidPage(
  # fluidRow(
  # DT::dataTableOutput(ns("table"))
  # )
  # )
  
}
    
#' analysis Server Functions
#'
#' @noRd 
mod_analysis_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$sidebar <- renderUI({
      
      years <- sort(unique(rv$data$year))
      unis <- sort(unique(rv$data$institutionname))
      
      tagList(
        selectInput(
          ns("year"),
          label = "Award Year",
          choices = years,
          selected = years[1]
        ),
        br(),
        selectInput(
          ns("unis"),
          label = "Universities",
          choices = unis,
          selected = unis[1],
          multiple = TRUE,
        )
      )
      
    })
    
    output$main <- renderUI({
      
      tagList(
        plotly::plotlyOutput(ns("plot_1"))
      )
      
    })
    
    output$plot_1 <- plotly::renderPlotly({
      
      ad_count_by_uni <- rv$data |>
        dplyr::group_by(
          year,
          institutionname
        ) |>
        dplyr::summarise(
          total_awarded = sum(recordcount, na.rm = TRUE)
        ) |>
        dplyr::ungroup() |>
        dplyr::filter(
          year == input$year
        ) |>
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
      
    })
    
    # output$table <- DT::renderDataTable({
    #   
    #   rv$data
    #   
    # })
 
  })
}
    
## To be copied in the UI
# mod_analysis_ui("analysis_ui_1")
    
## To be copied in the server
# mod_analysis_server("analysis_ui_1")
