## R CMD check results

Local (`--as-cran`, macOS Sequoia 15.7.3, R 4.5.1, aarch64): 0 errors,
0 warnings, 1 note.

* The standard "New submission" note from the CRAN incoming feasibility check.

## Windows and Linux

Submitted to win-builder. The check on R-devel (R Under development
unstable, 2026-11-17 r90926 ucrt, Windows Server 2022) reports 0 errors,
0 warnings and one NOTE: the standard "New submission" note. The package is
pure R, so no compilation is involved. The only platform-specific
requirement is Python (>= 3.12) with `nos-tlplot`, which is declared under
`SystemRequirements`.

Checked in the R-hub containers (linux, windows and macos on R-devel):
results recorded below.

## Submission notes

`nos.tlplotR` is an R interface to the Python package `nos-tlplot`
(<https://pypi.org/project/nos-tlplot/>), installed from PyPI. The package
uses `reticulate`; the Python dependency is declared with
`reticulate::py_require()` in `.onLoad()` and imported on first use. Nothing
is downloaded when the package loads; reticulate provisions the environment
only when a plotting function is first called. The minimum version is
`nos-tlplot` 3.0.2; pip installs the newest release that satisfies this
minimum.

The documentation asks users to cite the original NOS-TLPlot software.
`citation("nos.tlplotR")` returns that citation together with the optional
citation for the R interface.

The package name uses a dot because CRAN package names cannot contain
hyphens; the GitHub repository and the Python package are `nos-tlplot` /
`nos-tlplotR`.

Legacy `.xls` input is converted with the suggested `readxl` package. CSV and
`.xlsx` input need no extra R packages.

Examples are wrapped in `\dontrun{}` because they need Python and write image
files. Tests that need Python call `testthat::skip_on_cran()` and skip when
the module is unavailable; argument-validation tests run everywhere.

## Test environments

* local: macOS Sequoia 15.7.3, R 4.5.1 (aarch64-apple-darwin24.4.0)
* win-builder: R-devel and R-release (see above)
* Linux: R-hub containers (see above)
