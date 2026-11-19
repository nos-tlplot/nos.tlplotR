#' Generate the theme radar chart
#'
#' Creates a radar chart of the normalized domain scores per study, with
#' studies coloured by their overall risk-of-bias judgement. Radar plots
#' support at most 5 studies; with more studies no chart is created and a
#' message is returned instead.
#'
#' @param input_file A data frame with NOS data, or a path to a CSV or Excel
#'   file (`.csv`, `.xls`, `.xlsx`) containing it.
#' @param output_file Path where the plot will be saved. The file extension
#'   must be one of `"png"`, `"pdf"`, `"svg"`, or `"tiff"`.
#' @param theme Colour theme. One of `"traffic_light"`, `"gray"`, `"ocean"`,
#'   or `"sage"`.
#' @param verbose If `TRUE`, relay the messages printed by the Python
#'   package to the R console.
#'
#' @return Invisibly returns the normalized path to the created file, or an
#'   invisible `NULL` when the study count exceeds the radar limit.
#'
#' @seealso [nos.tlplotR] for the Python requirement and input data details.
#'
#' @export
#' @examples
#' \dontrun{
#' plot_theme_radar(
#'   input_file = system.file("extdata", "sample_nos.csv",
#'                            package = "nos.tlplotR"),
#'   output_file = tempfile(fileext = ".png")
#' )
#' }
plot_theme_radar <- function(input_file, output_file,
                             theme = "traffic_light", verbose = FALSE) {
  run_nos_plot(input_file, output_file, theme, "plot_theme_radar",
               verbose = verbose, allow_skip = TRUE)
}
