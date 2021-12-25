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
  dplyr::ungroup() |>
  dplyr::filter(
    year == 2001
  ) |>
  dplyr::arrange(
    total_awarded
  )

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

## Since we have time series data we can also look at predicting future outcomes and comparing them to actual results. We may not have actual results to compare to for the foreseeable future - depends on when data set is updated. We can at least create a prediction for 2018-2019 with a certain degree of confidence.


## Visualization
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
