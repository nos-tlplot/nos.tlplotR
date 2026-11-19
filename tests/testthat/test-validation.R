test_that("invalid input files are rejected before Python is touched", {
  expect_error(plot_nos_visualization("does-not-exist.csv", "out.png"),
               "Input file does not exist")
  expect_error(plot_nos_visualization(tempdir(), "out.png"),
               "must be a file, not a directory")

  txt <- tempfile(fileext = ".txt")
  writeLines("not a dataset", txt)
  expect_error(plot_nos_visualization(txt, "out.png"),
               "Unsupported input file type")
})

test_that("invalid output files and themes are rejected", {
  input <- sample_file("sample_nos.csv")

  expect_error(plot_nos_visualization(input, "out.gif"),
               "Unsupported output file type")
  expect_error(plot_nos_visualization(input, "out.png", theme = "smiley"),
               "Unknown theme")
  expect_error(plot_nos_visualization(input, "out.png", theme = c("gray",
                                                                  "ocean")),
               "single character string")
})

test_that("data frames are validated", {
  empty <- data.frame()
  expect_error(plot_nos_visualization(empty, "out.png"),
               "at least one column")

  no_names <- data.frame(c(1, 2), c(3, 4))
  names(no_names) <- c("", "")
  expect_error(plot_nos_visualization(no_names, "out.png"),
               "unique, non-empty names")
})

test_that("invalid NOS data is reported by the Python package", {
  skip_if_no_nos_tlplot()

  dat <- read.csv(sample_file("sample_nos.csv"), check.names = FALSE)
  dat[["Total Score"]] <- NULL
  output <- tempfile(fileext = ".png")
  expect_error(plot_nos_visualization(dat, output), "Missing required columns")
})
