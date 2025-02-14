#' Analyses a prompt to re-buid the dialog
#'
#' @param prompt The prompt to analyse
#'
#' @return A list with the chatter (mamba or codestral) and the dialog in a data.frame.
#'
#' @export
#'
compile_dialog <- function(prompt) {
  marker <- list(
    codestralStart = which(x = stringr::str_starts(string = prompt, pattern = "c:")),
    mambaStart = which(x = stringr::str_starts(string = prompt, pattern = "m:")),
    answerStart = which(x = stringr::str_starts(string = prompt, pattern = "a:")),
    systemStart = which(x = stringr::str_starts(string = prompt, pattern = "s:"))
  )

  anyMarker <- which(x = sapply(X = marker, FUN = \(x) {
    length(x = x) > 0
  }))

  breaks <- lapply(X = anyMarker, FUN = \(k) {
    if (k == 1) {
      res <- data.frame(type = "c", ind = marker[[k]])
    } else if (k == 2) {
      res <- data.frame(type = "m", ind = marker[[k]])
    } else if (k == 3) {
      res <- data.frame(type = "a", ind = marker[[k]])
    } else {
      res <- data.frame(type = "s", ind = marker[[k]])
    }

    res
  }) %>%
    do.call(what = rbind.data.frame)

  breaks  %<>% dplyr::arrange(ind)

  nBreaks <- nrow(x = breaks)

  # print(breaks)

  if (breaks$ind[1] > 1) {
    # Ignore what is before the start of the dialog

    prompt <- tail(x = prompt, -(breaks$ind[1] - 1))
  }

  while ((breaks$type[nBreaks] == "a") & (nBreaks >0)) {
    print("Answer ignored")
    # the user expects a new answer to the same question
    prompt <- head(x = prompt, -(length(x = prompt) - breaks$ind[nBreaks] + 1))

    breaks <- head(x = breaks, -1)

    nBreaks <- nrow(x = breaks)
  }

  if(nBreaks==0){
    stop("Malformed request")
  }

  chatter <- "codestral"

  if (breaks$type[nBreaks] == "m") {
    chatter <- "mamba"
  }

  content <- sapply(X = 1:nrow(x = breaks), FUN = \(k) {
    type_ <- breaks$type[k]
    ind_ <- breaks$ind[k]

    ind_next <- breaks$ind[k + 1] - 1

    if (k == nBreaks) {
      ind_next <- length(x = prompt)
    }

    res <- paste(prompt[ind_:ind_next], collapse = "\n")

    res <- stringr::str_sub(string = res, start = 3, end = -1)
  })

  role <- ifelse(
    test = (breaks$type == "c") |
      (breaks$type == "m"),
    yes = "user",
    no = ifelse(breaks$type == "s", yes = "system", no = "assistant")
  )


  res <- list(chatter = chatter,
              dialog = data.frame(role = role, content = content))

  # print(res)

  res
}
