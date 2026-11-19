# nos.tlplotR 0.3.0

* Initial CRAN submission.
* R interface to the Python package 'nos-tlplot' (>= 3.0.2) for
  Newcastle-Ottawa Scale (NOS) risk-of-bias assessments.
* `plot_all()` generates the complete set of thirteen visualizations in
  one call, mirroring the nos-tlplot command line.
* Thirteen visualizations: NOS visualization grid, traffic-light bubble
  plot, domain and theme radars, domain and item-level star heatmaps,
  stacked dot profile, score table, risk donut, star ratings matrix,
  lollipop chart, overall risk pie and stacked area chart.
* Four colour themes: `traffic_light` (default), `gray`, `ocean`, `sage`.
* Output to `png`, `pdf`, `svg` and `tiff`.
* Input from data frames or CSV/Excel files; bundled example data.
