#' @noRd
skip_if_no_nos_tlplot <- function() {
  testthat::skip_on_cran()

  if (!reticulate::py_available(initialize = TRUE)) {
    testthat::skip("Python is not available")
  }
  if (!reticulate::py_module_available("nos_tlplot")) {
    testthat::skip("Python package 'nos-tlplot' is not available")
  }
}

#' @noRd
sample_file <- function(name) {
  path <- system.file("extdata", name, package = "nos.tlplotR")
  if (!nzchar(path)) {
    testthat::skip(paste("Sample file not found:", name))
  }
  path
}

#' @noRd
expect_plot_created <- function(path) {
  testthat::expect_type(path, "character")
  testthat::expect_true(all(file.exists(path)))
  testthat::expect_true(all(file.size(path) > 0))
}
