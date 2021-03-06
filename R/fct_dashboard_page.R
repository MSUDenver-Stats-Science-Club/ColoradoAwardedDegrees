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
      mod_home_ui("home_ui_1")
    ),
    tabPanel(
      title = "University Map",
      # Module here
      mod_uni_map_ui("uni_map_ui_1")
    ),
    tabPanel(
      title = "Degrees Analysis",
      mod_analysis_ui("analysis_ui_1")
    )
  )
  
}