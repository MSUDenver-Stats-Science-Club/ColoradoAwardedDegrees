#' Dashboard Page for CAD
#' 
#' Contains all dashboard page and body elements used within the UI of the dashboard.
#'
#' @return A list.
#' @export
dashboard_page <- function() {
  
  navbarPage(
    title = "Degrees Awarded in Colorado",
    id = "tab",
    selected = "Home",
    inverse = TRUE,
    theme = bslib::bs_theme(bootswatch = "flatly"),
    tabPanel(
      title = "Home",
      # Module here
      mod_home_ui("home_ui_1")
    ),
    tabPanel(
      title = "University Map"
    ),
    tabPanel(
      title = "Degrees Analysis",
      # Module here
      mod_analysis_ui("analysis_ui_1")
    ),
    tabPanel(
      title = "Report"
    )
  )
  
}