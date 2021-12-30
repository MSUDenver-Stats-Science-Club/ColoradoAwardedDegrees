## Load App Data ----
app_data <<- get_data()

## Reactives ----
rv <- list()
rv$year <- 2001
rv$university <- "Adams State University"

## Code to Test ----
unis <- app_data |>
  dplyr::filter(year == rv$year) |>
  dplyr::pull(institutionname) |>
  unique() |>
  sort()

program <- app_data |>
  dplyr::filter(
    year == rv$year,
    institutionname %in% rv$university
  ) |>
  dplyr::pull(programname) |>
  unique() |>
  sort()
