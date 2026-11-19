# Regenerate the README/pkgdown gallery figures from the bundled example data.
# Run: Rscript -e 'library(nos.tlplotR); source("figures-gallery.R")'

fig <- function(name) file.path("man", "figures", name)
inp <- function(f) system.file("extdata", f, package = "nos.tlplotR")

# Radar plots support at most 5 studies; the bundled sample has 6.
five_studies <- head(
  read.csv(inp("sample_nos.csv"), check.names = FALSE),
  5
)

jobs <- list(
  list("nos-visualization.png", "sample_nos.csv", "traffic_light", plot_nos_visualization),
  list("traffic-light.png",     "sample_nos.csv", "traffic_light", plot_traffic_light),
  list("domain-heatmap.png",    "sample_nos.csv", "traffic_light", plot_domain_heatmap),
  list("item-heatmap.png",      "sample_nos.csv", "traffic_light", plot_item_heatmap),
  list("dot-profile.png",       "sample_nos.csv", "traffic_light", plot_dot_profile),
  list("score-table.png",       "sample_nos.csv", "traffic_light", plot_score_table),
  list("donut.png",             "sample_nos.csv", "traffic_light", plot_donut),
  list("star-matrix.png",       "sample_nos.csv", "traffic_light", plot_star_matrix),
  list("lollipop.png",          "sample_nos.csv", "traffic_light", plot_lollipop),
  list("risk-pie.png",          "sample_nos.csv", "traffic_light", plot_risk_pie),
  list("stacked-area.png",      "sample_nos.csv", "traffic_light", plot_stacked_area),
  # Theme variants, so users can compare palettes at a glance
  list("nos-visualization-gray.png",  "sample_nos.csv", "gray",  plot_nos_visualization),
  list("nos-visualization-ocean.png", "sample_nos.csv", "ocean", plot_nos_visualization),
  list("nos-visualization-sage.png",  "sample_nos.csv", "sage",  plot_nos_visualization)
)

for (j in jobs) {
  cat("Generating", j[[1]], "...\n")
  res <- j[[4]](inp(j[[2]]), fig(j[[1]]), theme = j[[3]])
  cat("  ->", res, "\n")
}

# Radar plots from the 5-study subset
cat("Generating domain-radar.png ...\n")
res <- plot_domain_radar(five_studies, fig("domain-radar.png"))
cat("  ->", res, "\n")

cat("Generating theme-radar.png ...\n")
res <- plot_theme_radar(five_studies, fig("theme-radar.png"))
cat("  ->", res, "\n")

cat("Done.\n")
