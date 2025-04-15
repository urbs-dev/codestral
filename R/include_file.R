#' Read and include files in a prompt
#'
#' @param prompt A vector of strings.
#'
#' @param anyFile A boolean of the same length of prompt indicating that an instruction `"ff:"` has been detected in a string.
#'
#' @returns A vector of strings containing prompt augmented by the files refered to in the original prompt.
#'
#' @details If `anyFile[i]` is `TRUE` then the sequence of characters following the instruction `"ff:"` in `prompt[i]` is read until the next space or the end of the string. This extracted string is assumed to be a file name. This file is looked for in the current working directory or any of its sub-directories. Once detected, the file is read with `readLines()` and this content is inserted in `prompt` between `prompt[i-1]` and `prompt[i+1]`. Note that `prompt[i]` is therefore deleted.
#'
#' The result is returned.
#'
#'@export
include_file <- function(prompt, anyFile) {
  if (any(anyFile)) {
    ind <- which(anyFile)

    message(paste("Files detected at indeces", ind, ".\n"))

    files <- sapply(X = ind, FUN = \(i) {
      stringr::str_extract(string = prompt[i], pattern = "(?<=ff:).+?(?= |$)")
    })

    dirAll <- dir(recursive = TRUE, full.names = TRUE)

    for (i in 1:length(ind)) {
      filePath <- ""
      ff <- files[i]
      ii <- ind[i]

      detectFile <- stringr::str_ends(string = dirAll, pattern = ff)

      if (!any(detectFile)) {
        warning(paste(ff, "has not been detected"))
      } else {
        filePath <- dirAll[which(detectFile)[1]]

        message(paste(ff, "has been detected as", filePath))

        prompt <- c(prompt[1:(ii - 1)], readLines(filePath), prompt[(ii + 1):length(prompt)])
      }
    }
  }

  return(prompt)
}
