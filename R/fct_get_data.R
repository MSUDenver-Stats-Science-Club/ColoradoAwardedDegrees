#' Get App Data
#'
#' @description A function to send requests to the Colorado Information Marketplace. This will access app data for use in the Shiny dashboard.
#'
#' @return A data frame. Contains app data.
#' @references For more information on our data visit: https://data.colorado.gov/resource/hxf8-ab6k
#' @export
get_data <- function() {
  
  ## Read in our data (to be converted into a function)
  data_url <- "https://data.colorado.gov/resource/hxf8-ab6k.csv?$limit=250000"
  
  print("Fetching data from url...")
  
  degrees_data <- data_url %>%
    httr::GET() %>%
    httr::content(show_col_types = FALSE)
  
  print("Found data!")
  
  ## Clean/Organize data
  ad_org <- degrees_data %>%
    dplyr::select(
      -cobased,
      -division,
      -institutionlevelid,
      -institutiontype,
      -taxtype,
      -agemin,
      -agemax,
      -residencyid,
      -cip,
      -cip2
    ) %>%
    dplyr::arrange(
      year,
      institutionname
    ) %>%
    dplyr::filter(
      !is.na(recordcount)
    ) %>%
    dplyr::mutate(
      programname = ifelse(
        test = is.na(programname),
        yes = "General",
        no = programname
      )
    )
  
  print("Data cleaned and ready for use!")
  
  return(ad_org)
  
}
