test_that("plot_nos_visualization() creates a PNG from CSV and Excel input", {
  skip_if_no_nos_tlplot()

  for (ext in c("csv", "xlsx")) {
    output <- tempfile(fileext = ".png")
    result <- plot_nos_visualization(sample_file(paste0("sample_nos.", ext)),
                                    output)
    expect_identical(result, normalizePath(output))
    expect_plot_created(result)
  }
})

test_that("every plot function creates a PNG from the bundled data", {
  skip_if_no_nos_tlplot()

  five_studies <- function() {
    dat <- read.csv(sample_file("sample_nos.csv"), check.names = FALSE)
    head(dat, 5)
  }

  cases <- list(
    list(plot_traffic_light, "sample_nos.csv"),
    list(plot_domain_heatmap, "sample_nos.csv"),
    list(plot_item_heatmap, "sample_nos.csv"),
    list(plot_dot_profile, "sample_nos.csv"),
    list(plot_score_table, "sample_nos.csv"),
    list(plot_donut, "sample_nos.csv"),
    list(plot_star_matrix, "sample_nos.csv"),
    list(plot_lollipop, "sample_nos.csv"),
    list(plot_risk_pie, "sample_nos.csv"),
    list(plot_stacked_area, "sample_nos.csv"),
    list(plot_domain_radar, five_studies),
    list(plot_theme_radar, five_studies)
  )

  for (case in cases) {
    input <- if (is.function(case[[2]])) case[[2]]() else sample_file(case[[2]])
    output <- tempfile(fileext = ".png")
    result <- case[[1]](input, output)
    expect_plot_created(result)
  }
})

test_that("every plot function accepts a data frame", {
  skip_if_no_nos_tlplot()

  dat <- read.csv(sample_file("sample_nos.csv"), check.names = FALSE)
  original <- dat

  output <- tempfile(fileext = ".png")
  result <- plot_nos_visualization(dat, output)
  expect_plot_created(result)
  expect_identical(dat, original)
})

test_that("radar plots skip cleanly beyond the 5-study limit", {
  skip_if_no_nos_tlplot()

  for (fn in list(plot_domain_radar, plot_theme_radar)) {
    output <- tempfile(fileext = ".png")
    expect_message(
      expect_null(fn(sample_file("sample_nos.csv"), output)),
      "at most 5 studies"
    )
    expect_false(file.exists(output))
  }
})

test_that("all themes accepted by the plot functions work", {
  skip_if_no_nos_tlplot()

  input <- sample_file("sample_nos.csv")
  for (theme in nos_tlplot_themes) {
    output <- tempfile(fileext = ".png")
    expect_silent(plot_nos_visualization(input, output, theme = theme))
    expect_true(file.exists(output))
  }
})

test_that("verbose = TRUE relays the Python messages", {
  skip_if_no_nos_tlplot()

  output <- tempfile(fileext = ".png")
  expect_message(
    plot_nos_visualization(sample_file("sample_nos.csv"), output,
                           verbose = TRUE)
  )
})

test_that("plot functions are silent by default", {
  skip_if_no_nos_tlplot()

  output <- tempfile(fileext = ".png")
  expect_silent(plot_nos_visualization(sample_file("sample_nos.csv"), output))
})
