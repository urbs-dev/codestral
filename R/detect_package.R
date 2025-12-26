#' Detect whether the working directory is that of a package
#'
#' @return TRUE if the working directory is that of a package, FALSE otherwise
#'
#' @export
detect_package <- function() {
  if (file.exists("DESCRIPTION")) {
    res <- TRUE
  } else {
    res <- FALSE
  }

  res
}
