#' Include package files in the prompt
#'
#' This function includes R files from a package in the prompt when a package is detected.
#' It handles the inclusion of file contents and path-specific exclusions.
#'
#' @param prompt The current prompt to which package files should be added.
#' @param path Current file path to exclude from the included files.
#'
#' @return The modified prompt with package file contents included.
#'
#' @export
include_package_files <- function(prompt, path) {
  cat("Package has been detected, include R files.")

  Rfiles <- inventory_Rfiles()

  # remove path from Rfiles
  Rfiles <- Rfiles[!stringr::str_detect(string = Rfiles$file_path, pattern = path), ]

  prompt <- c(paste("# Content of file", path), "", prompt)


  for (ff in Rfiles$file_path) {
    filecontent <- c(
      paste("# Content of file", ff, ""),
      readLines(ff),
      ""
    )

    prompt <- c(filecontent, prompt)
  }

  return(prompt)
}
