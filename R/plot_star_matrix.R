#' Generate the star ratings matrix
#'
#' Creates an item-level matrix of the individual NOS stars, ordered by
#' total score, with domain bands and a total column.
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
#' plot_star_matrix(
#'   input_file = system.file("extdata", "sample_nos.csv",
#'                            package = "nos.tlplotR"),
#'   output_file = tempfile(fileext = ".png")
#' )
#' }
plot_star_matrix <- function(input_file, output_file,
                             theme = "traffic_light", verbose = FALSE) {
  run_nos_plot(input_file, output_file, theme, "plot_line_ordered_scores",
               verbose = verbose)
}
