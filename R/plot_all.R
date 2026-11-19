#' Generate every NOS plot at once
#'
#' Creates the complete set of thirteen visualizations in one call,
#' mirroring the `nos-tlplot` command line: the traffic-light bubble plot
#' is written to `output_file` and the twelve companion figures are written
#' next to it with suffixed names (`_radar`, `_theme_radar`, `_heatmap`,
#' `_item_heatmap`, `_dot_profile`, `_table`, `_donut`, `_line_ordered`,
#' `_lollipop`, `_pie`, `_stacked_area`, `_nos_plot`).
#'
#' Radar charts support at most 5 studies; with more studies they are
#' skipped and a message says so.
#'
#' @param input_file A data frame with NOS data, or a path to a CSV or Excel
#'   file (`.csv`, `.xls`, `.xlsx`) containing it.
#' @param output_file Path that sets the stem and format of the traffic-light
#'   bubble plot. The file extension must be one of `"png"`, `"pdf"`,
#'   `"svg"`, or `"tiff"`; every companion figure shares it.
#' @param theme Colour theme. One of `"traffic_light"`, `"gray"`, `"ocean"`,
#'   or `"sage"`.
#' @param verbose If `TRUE`, relay the messages printed by the Python
#'   package to the R console.
#'
#' @return Invisibly returns the normalized paths of the files that were
#'   created.
#'
#' @seealso [nos.tlplotR] for the Python requirement and input data details.
#'
#' @export
#' @examples
#' \dontrun{
#' plot_all(
#'   input_file = system.file("extdata", "sample_nos.csv",
#'                            package = "nos.tlplotR"),
#'   output_file = tempfile(fileext = ".png")
#' )
#' }
plot_all <- function(input_file, output_file, theme = "traffic_light",
                     verbose = FALSE) {
  check_output_file(output_file)
  theme <- check_theme(theme, nos_tlplot_themes)
  input <- prepare_input(input_file)
  on.exit(cleanup_input(input), add = TRUE)
  mod <- get_nos_tlplot_module()

  df <- mod$read_input_file(input)
  df <- mod$process_detailed_nos(df)

  base <- tools::file_path_sans_ext(output_file)
  ext <- tolower(tools::file_ext(output_file))

  # Same set and order as the nos-tlplot command line.
  plots <- list(
    c("", "professional_plot"),
    c("_radar", "plot_domain_radar"),
    c("_theme_radar", "plot_theme_radar"),
    c("_heatmap", "plot_domain_heatmap"),
    c("_item_heatmap", "plot_item_heatmap"),
    c("_dot_profile", "plot_dot_profile"),
    c("_table", "plot_score_table"),
    c("_donut", "plot_donut_domain_risk"),
    c("_line_ordered", "plot_line_ordered_scores"),
    c("_lollipop", "plot_lollipop_total"),
    c("_pie", "plot_pie_overall_rob"),
    c("_stacked_area", "plot_stacked_area_risk"),
    c("_nos_plot", "plot_nos_visualization")
  )

  created <- character(0)
  radars_created <- 0
  for (p in plots) {
    path <- paste0(base, p[[1]], ".", ext)
    output <- reticulate::py_capture_output(
      mod[[p[[2]]]](df, path, theme = theme)
    )
    if (isTRUE(verbose)) {
      output <- output[nzchar(output)]
      if (length(output)) {
        message(paste(output, collapse = "\n"))
      }
    }
    if (file.exists(path)) {
      created <- c(created, normalizePath(path))
      if (grepl("_radar$", p[[1]])) {
        radars_created <- radars_created + 1
      }
    }
  }

  if (radars_created == 0) {
    message("Radar charts were skipped: radar plots support at most 5 studies.")
  }

  invisible(created)
}
