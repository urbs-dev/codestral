#' Fill in the middle or complete
#'
#' This function splits the current script into two parts: the part before the cursor and the part after the cursor.
#'
#' @return A character vector containing the two parts of the script.
#' @export
#'
complete_current_script <- function() {
  # Get the current script path
  context_ <- rstudioapi::getSourceEditorContext()

  path <- context_$path

  # Read the entire script
  content_ <- context_$contents

  # Get the current cursor position
  cursor_position <- rstudioapi::primary_selection(context_)

  start_ <- cursor_position$range$start
  end_ <- cursor_position$range$end

  prompt_ <- content_[1:start_[1]]
  suffix <- content_[start_[1]:length(x = content_)]

  prompt_[start_[1]] <- stringr::str_sub(string = content_[start_[1]],
                                         start = 1,
                                         end = start_[2] - 1)

  suffix[start_[1]] <- stringr::str_sub(string = content_[start_[1]],
                                        start = start_[2],
                                        end = length(x = content_))

  ans <- codestral(prompt = prompt_,
                   suffix = suffix,
                   max_tokens = 100)

  ans
}

