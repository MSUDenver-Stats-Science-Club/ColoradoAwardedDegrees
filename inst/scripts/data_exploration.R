app_data <- get_data()

## First I want to organize the data by:
## Ascending year
## Alphabetized institution name
## Remove instances where record count (degrees awarded) is NA
ad_org <- app_data |>
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

