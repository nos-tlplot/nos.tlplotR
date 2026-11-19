## R CMD check results

Local (`--as-cran`, macOS Sequoia 15.7.3, R 4.5.1, aarch64): 0 errors,
0 warnings, 1 note.

* The standard "New submission" note from the CRAN incoming feasibility check.

## Windows and Linux

Submitted to win-builder. Both checks report 0 errors, 0 warnings and one
NOTE: the standard "New submission" note.

* R-devel (R Under development unstable, 2026-11-17 r90926 ucrt, Windows
  Server 2022)
* R-release (R 4.6.2, 2026-10-29 ucrt, Windows Server 2022)

The package is pure R, so no compilation is involved. The only
platform-specific requirement is Python (>= 3.12) with `nos-tlplot`, which is
declared under `SystemRequirements`.

Checked in the R-hub containers on R-devel for windows and linux: 0 errors,
0 warnings. The macos container stayed queued for several hours, so that run
was cancelled; macOS was covered by the local check above instead.

## Submission notes

`nos.tlplotR` is an R interface to the Python package `nos-tlplot`
(<https://pypi.org/project/nos-tlplot/>), installed from PyPI. The package
uses `reticulate`; the Python dependency is declared with
`reticulate::py_require()` in `.onLoad()` and imported on first use. Nothing
is downloaded when the package loads; reticulate provisions the environment
only when a plotting function is first called. The minimum version is
`nos-tlplot` 3.0.2; pip installs the newest release that satisfies this
minimum.

The documentation asks users to cite the NOS-TLPlot metapaper in the Journal
of Open Research Software (preferred), or the NOS-TLPlot software and the R
interface if they want to cite the code specifically.
`citation("nos.tlplotR")` returns these citations.

The package name uses a dot because CRAN package names cannot contain
hyphens; the GitHub repository and the Python package are `nos-tlplotR` /
`nos-tlplot`.

Legacy `.xls` input is converted with the suggested `readxl` package. CSV and
`.xlsx` input need no extra R packages.

Examples are wrapped in `\dontrun{}` because they need Python and write image
files. Tests that need Python call `testthat::skip_on_cran()` and skip when
the module is unavailable; argument-validation tests run everywhere.

## Test environments

* local: macOS Sequoia 15.7.3, R 4.5.1 (aarch64-apple-darwin24.4.0)
* win-builder: R-devel and R-release
* Linux and Windows: R-hub containers on R-devel
