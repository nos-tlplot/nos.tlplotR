test_that("plot_all() creates the full set from the bundled data", {
  skip_if_no_nos_tlplot()

  output <- tempfile(fileext = ".png")
  expect_message(
    result <- plot_all(sample_file("sample_nos.csv"), output),
    "Radar charts were skipped"
  )
  expect_length(result, 11)
  expect_plot_created(result)
  expect_true(any(grepl("_nos_plot\\.png$", basename(result))))
})

test_that("plot_all() creates all thirteen with a 5-study data frame", {
  skip_if_no_nos_tlplot()

  dat <- head(read.csv(sample_file("sample_nos.csv"), check.names = FALSE), 5)
  output <- tempfile(fileext = ".png")
  expect_silent(result <- plot_all(dat, output))
  expect_length(result, 13)
  expect_plot_created(result)
  stems <- tools::file_path_sans_ext(basename(result))
  expect_identical(
    stems[-1],
    paste0(stems[1], c("_radar", "_theme_radar", "_heatmap", "_item_heatmap",
                       "_dot_profile", "_table", "_donut", "_line_ordered",
                       "_lollipop", "_pie", "_stacked_area", "_nos_plot"))
  )
})

test_that("plot_all() validates arguments", {
  expect_error(plot_all(sample_file("sample_nos.csv"), "out.gif"),
               "Unsupported output file type")
  expect_error(plot_all(sample_file("sample_nos.csv"), "out.png", theme = "blue"),
               "Unknown theme")
})
