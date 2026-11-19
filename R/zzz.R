# Minimum Python package version used by this release.
nos_tlplot_min_version <- "3.0.2"

# Cache the Python module for the session.
.nos_tlplot_env <- new.env(parent = emptyenv())
.nos_tlplot_env$module <- NULL

#' @importFrom reticulate import py_module_available py_require
NULL

#' @noRd
.onLoad <- function(libname, pkgname) {
  # Record the Python requirement before Python starts. Nothing is downloaded
  # at load time, and a failure here must not stop the package from loading.
  try(
    reticulate::py_require(paste0("nos-tlplot>=", nos_tlplot_min_version)),
    silent = TRUE
  )
}

#' @noRd
get_nos_tlplot_version <- function() {
  metadata <- tryCatch(
    reticulate::import("importlib.metadata"),
    error = function(e) NULL
  )
  if (is.null(metadata)) {
    return(NA_character_)
  }

  tryCatch(
    as.character(metadata$version("nos-tlplot")),
    error = function(e) NA_character_
  )
}

#' @noRd
get_nos_tlplot_module <- function() {
  if (!is.null(.nos_tlplot_env$module)) {
    return(.nos_tlplot_env$module)
  }

  # A managed environment can only be created before Python is initialized.
  if (!reticulate::py_available(initialize = FALSE)) {
    try(
      reticulate::py_require(paste0("nos-tlplot>=", nos_tlplot_min_version)),
      silent = TRUE
    )
  }

  if (!reticulate::py_module_available("nos_tlplot")) {
    stop(
      "The 'nos-tlplot' Python package is not available.\n",
      "Install it with:\n",
      "  reticulate::py_install(\"nos-tlplot\", pip = TRUE)\n",
      "or let reticulate manage it by calling:\n",
      "  reticulate::py_require(\"nos-tlplot\")\n",
      "Then restart R and try again. See ?nos.tlplotR for details.",
      call. = FALSE
    )
  }

  version <- get_nos_tlplot_version()
  if (is.na(version) ||
      utils::compareVersion(version, nos_tlplot_min_version) < 0) {
    stop(
      "The 'nos-tlplot' Python package is too old.\n",
      "nos.tlplotR requires nos-tlplot >= ", nos_tlplot_min_version, ".\n",
      if (is.na(version)) {
        "The installed version could not be determined.\n"
      } else {
        paste0("Installed version: ", version, ".\n")
      },
      "Upgrade with:\n",
      "  reticulate::py_install(\"nos-tlplot>=", nos_tlplot_min_version,
      "\", pip = TRUE)\n",
      "Then restart R and try again. See ?nos.tlplotR for details.",
      call. = FALSE
    )
  }

  module <- reticulate::import("nos_tlplot")
  .nos_tlplot_env$module <- module
  module
}
