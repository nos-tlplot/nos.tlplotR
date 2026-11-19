#' nos.tlplotR: Visualize Newcastle-Ottawa Scale Risk-of-Bias Assessments with 'nos-tlplot'
#'
#' `nos.tlplotR` is an R interface to the Python package
#' [`nos-tlplot`](https://nos-tlplot.github.io). It creates publication-ready
#' traffic-light plots and thirteen specialized visualizations for
#' Newcastle-Ottawa Scale (NOS) risk-of-bias assessments in systematic
#' reviews and meta-analyses.
#'
#' \if{html}{\figure{logo.png}{options: width=180 alt="nos.tlplotR logo"}}
#'
#' The package supports:
#'
#' * every plot at once, via [plot_all()];
#' * the NOS visualization grid, via [plot_nos_visualization()];
#' * the traffic-light bubble plot, via [plot_traffic_light()];
#' * domain and theme radar charts, via [plot_domain_radar()] and
#'   [plot_theme_radar()];
#' * domain and item-level star heatmaps, via [plot_domain_heatmap()] and
#'   [plot_item_heatmap()];
#' * stacked domain stars, via [plot_dot_profile()];
#' * the score table, via [plot_score_table()];
#' * the risk donut chart, via [plot_donut()];
#' * the star ratings matrix, via [plot_star_matrix()];
#' * the total score lollipop chart, via [plot_lollipop()];
#' * the overall risk pie chart, via [plot_risk_pie()];
#' * the stacked area risk chart, via [plot_stacked_area()].
#'
#' ## Python requirement
#'
#' A Python installation (>= 3.12) with the `nos-tlplot` package is required.
#' On first load, `nos.tlplotR` declares `nos-tlplot` as a Python requirement
#' with [reticulate::py_require()], so `reticulate` can provide it
#' automatically. To use an existing Python installation instead, install the
#' module yourself:
#'
#' ```r
#' reticulate::py_install("nos-tlplot", pip = TRUE)
#' ```
#'
#' Use [reticulate::py_config()] to check which Python interpreter is in use
#' and [reticulate::py_module_available()] to check that `nos_tlplot` is
#' available.
#'
#' ## Input data
#'
#' Every plotting function accepts a data frame or a path to a CSV (`.csv`)
#' or Excel (`.xls`/`.xlsx`) file with the NOS columns expected by the
#' corresponding `nos-tlplot` function. The package README lists the column
#' names and accepted values. Bundled example files are available through
#' [system.file()], for example:
#'
#' ```r
#' system.file("extdata", "sample_nos.csv", package = "nos.tlplotR")
#' ```
#'
#' ## Citation
#'
#' If you use the plots in a publication, please cite the original NOS-TLPlot
#' software (Sahu, 2026, \doi{10.5281/zenodo.24380517}). To cite the R
#' interface itself as well, use `citation("nos.tlplotR")`.
#'
#' @keywords internal
"_PACKAGE"
