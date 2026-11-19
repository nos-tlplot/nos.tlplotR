# Themes accepted by every plot function.
nos_tlplot_themes <- c("traffic_light", "gray", "ocean", "sage")

check_input_file <- function(input_file) {
  if (!is.character(input_file) || length(input_file) != 1L ||
      is.na(input_file) || !nzchar(input_file)) {
    stop("`input_file` must be a single, non-empty file path.", call. = FALSE)
  }
  if (!file.exists(input_file)) {
    stop("Input file does not exist: ", input_file, call. = FALSE)
  }
  if (dir.exists(input_file)) {
    stop("`input_file` must be a file, not a directory: ", input_file,
         call. = FALSE)
  }
  ext <- tolower(tools::file_ext(input_file))
  if (!ext %in% c("csv", "xls", "xlsx")) {
    stop("Unsupported input file type '.", ext,
         "'. Use a CSV or Excel (.xls/.xlsx) file.", call. = FALSE)
  }
  invisible(input_file)
}

# Accept a data frame or a path to a CSV/Excel file. Data frames and legacy
# .xls files are converted to a temporary CSV for the Python functions.
prepare_input <- function(input) {
  if (!is.data.frame(input)) {
    check_input_file(input)

    if (tolower(tools::file_ext(input)) == "xls") {
      if (!requireNamespace("readxl", quietly = TRUE)) {
        stop(
          "Reading .xls files requires the 'readxl' package.\n",
          "Install it with install.packages(\"readxl\"), or save the file ",
          "as .xlsx.",
          call. = FALSE
        )
      }
      input <- readxl::read_excel(input, .name_repair = "minimal")
      input <- input[rowSums(is.na(input)) < ncol(input), , drop = FALSE]
    }
  }

  if (is.data.frame(input)) {
    if (!ncol(input)) {
      stop("`input_file` must have at least one column.", call. = FALSE)
    }
    if (!nrow(input)) {
      stop("`input_file` must have at least one row.", call. = FALSE)
    }
    nms <- names(input)
    if (is.null(nms) || anyNA(nms) || any(!nzchar(nms)) || anyDuplicated(nms)) {
      stop("All columns in `input_file` must have unique, non-empty names.",
           call. = FALSE)
    }
    atomic <- vapply(input, is.atomic, logical(1))
    if (!all(atomic)) {
      stop("All columns in `input_file` must be atomic vectors.",
           call. = FALSE)
    }
    path <- tempfile(fileext = ".csv")
    utils::write.csv(input, path, row.names = FALSE, na = "",
                     fileEncoding = "UTF-8")
    return(structure(path, nos_tlplot_temp = TRUE))
  }

  structure(input, nos_tlplot_temp = FALSE)
}

cleanup_input <- function(input) {
  if (isTRUE(attr(input, "nos_tlplot_temp"))) {
    unlink(input)
  }
  invisible(NULL)
}

check_output_file <- function(output_file) {
  if (!is.character(output_file) || length(output_file) != 1L ||
      is.na(output_file) || !nzchar(output_file)) {
    stop("`output_file` must be a single, non-empty file path.", call. = FALSE)
  }
  ext <- tolower(tools::file_ext(output_file))
  if (!ext %in% c("png", "pdf", "svg", "tiff")) {
    stop("Unsupported output file type '.", ext,
         "'. Use one of: png, pdf, svg, tiff.", call. = FALSE)
  }
  if (!dir.exists(dirname(output_file))) {
    stop("Output directory does not exist: ", dirname(output_file),
         call. = FALSE)
  }
  invisible(output_file)
}

check_theme <- function(theme, allowed) {
  if (!is.character(theme) || length(theme) != 1L || is.na(theme)) {
    stop("`theme` must be a single character string.", call. = FALSE)
  }
  if (!theme %in% allowed) {
    stop("Unknown theme '", theme, "'. Available themes: ",
         paste(allowed, collapse = ", "), ".", call. = FALSE)
  }
  theme
}

# Capture Python output so emoji in status messages do not break ASCII
# locales. With verbose = TRUE the captured text is relayed as an R message.
run_nos_tlplot <- function(expr, verbose = FALSE) {
  output <- reticulate::py_capture_output(expr)
  if (isTRUE(verbose)) {
    output <- output[nzchar(output)]
    if (length(output)) {
      message(paste(output, collapse = "\n"))
    }
  }
  invisible(output)
}

# Shared runner for the plot functions: validate the arguments, read and
# validate the data through the Python package, then call `plot_name` and
# check what was written. Radar plots support at most five studies; for them
# `allow_skip = TRUE` turns a skipped chart into a message instead of an
# error.
run_nos_plot <- function(input, output_file, theme, plot_name,
                         verbose = FALSE, allow_skip = FALSE) {
  check_output_file(output_file)
  theme <- check_theme(theme, nos_tlplot_themes)
  input <- prepare_input(input)
  on.exit(cleanup_input(input), add = TRUE)
  mod <- get_nos_tlplot_module()

  df <- mod$read_input_file(input)
  df <- mod$process_detailed_nos(df)

  run_nos_tlplot(mod[[plot_name]](df, output_file, theme = theme),
                 verbose = verbose)

  if (!file.exists(output_file)) {
    if (allow_skip) {
      message("No chart was created: radar plots support at most 5 studies.")
      return(invisible(NULL))
    }
    stop("nos-tlplot did not create the expected output file: ", output_file,
         call. = FALSE)
  }
  invisible(normalizePath(output_file))
}
