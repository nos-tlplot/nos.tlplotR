#' Generate the traffic-light bubble plot
#'
#' Creates the classic NOS traffic-light bubble plot: one row per study,
#' one column per domain, with bubbles sized by the stars earned and
#' joined across domains.
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
#' @return Invisibly returns the normalized path to the created file.
#'
#' @seealso [nos.tlplotR] for the Python requirement and input data details.
#'
#' @export
#' @examples
#' \dontrun{
#' plot_traffic_light(
#'   input_file = system.file("extdata", "sample_nos.csv",
#'                            package = "nos.tlplotR"),
#'   output_file = tempfile(fileext = ".png")
#' )
#' }
plot_traffic_light <- function(input_file, output_file,
                               theme = "traffic_light", verbose = FALSE) {
  run_nos_plot(input_file, output_file, theme, "professional_plot",
               verbose = verbose)
}
