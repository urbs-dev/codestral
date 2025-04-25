#' Insert the model's answer
#'
#' @description This function inserts a Codestral FIM into the current script.
#'
#' @return `0` (invisible).
#' @export
insert_addin <- function() {
  ans <- complete_current_script()
  rstudioapi::insertText(text = ans)
  invisible(0)
}

