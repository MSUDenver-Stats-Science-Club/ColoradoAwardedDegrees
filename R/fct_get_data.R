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
  
  degrees_data <- httr::GET(data_url) |> httr::content()
  
  print("Found data!")
  
  return(degrees_data)
  
}
