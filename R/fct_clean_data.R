#' Clean App Data
#'
#' @param .data A data frame. Should be data provided by [get_data()].
#'
#' @description Cleans app data for use in the shiny application.
#'
#' @return A data frame.
#' @export
clean_data <- function(.data) {
  
  ## Clean/Organize data
  ad_org <- .data |>
    dplyr::arrange(
      year,
      institutionname
    ) |>
    dplyr::filter(
      !is.na(recordcount)
    ) |>
    dplyr::mutate(
      programname = ifelse(
        test = is.na(programname),
        yes = "General",
        no = programname
      )
    )
  
  print("Data cleaned!")
  
  return(ad_org)
  
}
