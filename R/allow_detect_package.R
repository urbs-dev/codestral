#' Allow codestral to detect package environment
#'
#' @param x A boolean indicating that the user allows the detection of a
#' package environment. Defaulted to `TRUE`.
#'
#' @returns `0` invisible.
#'
#' @details
#' If set to `TRUE`, when codestral is used in a folder with a `DESCRIPTION`
#' file, all R files in the current folder and its subfolders are included
#' in the prompt.
#'
#' @export
allow_detect_package <- function(x = TRUE) {
  Sys.setenv(R_CODESTRAL_DETECT_PACKAGE = x)

  invisible(0)
}
