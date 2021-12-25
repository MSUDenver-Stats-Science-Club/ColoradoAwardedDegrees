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

## I want to start looking at specific colleges to gather insights
## Maybe we can look at time series of enrollment, total degrees awarded by university and university location, demographics, degree levels
ad_count_by_uni <- ad_org |>
  dplyr::group_by(
    year,
    institutionname
  ) |>
  dplyr::summarise(
    total_awarded = sum(recordcount, na.rm = TRUE)
  ) |>
  dplyr::ungroup()

ad_degree_levels <- ad_org |>
  dplyr::group_by(
    year,
    # institutionname,
    degreelevel
  ) |>
  dplyr::summarise(
    total_awarded = sum(recordcount, na.rm = TRUE)
  ) |>
  dplyr::ungroup()