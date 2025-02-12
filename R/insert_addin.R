
#' Insert the addin
#'
#' This function inserts a Codestral fim into the current script.
#'
#' @return `NULL` (invisible).
#' @export
insert_addin <- function() {
  ans <- complete_current_script()
  rstudioapi::insertText(text = ans)
  invisible()
}
