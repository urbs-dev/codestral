#' Set debug mode
#'
#' @param debug A logical value. If `TRUE`, the debug mode is activated.
#'
#' @return Invisible `0`.
#'
#' @details When the debug mode is activated, the function `codestral()` will
#'   print the request body and the response body.
#'
debug_mode <- function(debug = TRUE) {
  Sys.setenv(R_CODESTRAL_DEBUG = debug)

  # feedback for user
  if (debug) {
    message("Debug mode activated.")
  } else {
    message("Debug mode deactivated.")
  }

  invisible(0)
}
