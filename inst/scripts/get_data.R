## Read in our data (to be converted into a function)
data_url <- "https://data.colorado.gov/resource/hxf8-ab6k.csv?$limit=250000"

degrees_data <- httr::GET(data_url) |> httr::content()
