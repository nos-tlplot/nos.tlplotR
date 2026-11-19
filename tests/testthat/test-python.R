test_that("the installed nos-tlplot version meets the minimum", {
  skip_if_no_nos_tlplot()

  version <- get_nos_tlplot_version()
  expect_false(is.na(version))
  expect_true(utils::compareVersion(version, nos_tlplot_min_version) >= 0)
})
