#' Analyses a prompt to re-buid the dialog
#'
#' @param prompt The prompt to analyse. A vector of strings.
#'
#' @return A list with the chatter (Codestral or Codestral Mamba) and the dialog in a data.frame whith columns `role` and `content`.
#'
compile_dialog <- function(prompt) {
  ind <- NULL

  # Find indeces of markers for each marker
  marker <- list(
    codestralStart = which(x = stringr::str_starts(string = prompt, pattern = "c:")),
    mambaStart = which(x = stringr::str_starts(string = prompt, pattern = "m:")),
    answerStart = which(x = stringr::str_starts(string = prompt, pattern = "a:")),
    systemStart = which(x = stringr::str_starts(string = prompt, pattern = "s:"))
  )

  # Which markers have been found among the 4.
  anyMarker <- which(x = sapply(X = marker, FUN = \(x) {
    length(x = x) > 0
  }))

  # Create a data frame type/ind with markers and their indeces in increasing order of indeces
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
    do.call(what = rbind.data.frame) %>%
    dplyr::arrange(ind)

  nBreaks <- nrow(x = breaks)

  if (nBreaks == 0) {
    stop("Malformed request")
  }

  # print(breaks)

  if ( breaks$ind[1] > 1) {
    # Ignore what is before the start of the dialog

    prompt <- utils::tail(x = prompt, -(breaks$ind[1] - 1))

    breaks$ind <- breaks$ind -(breaks$ind[1] - 1)
  }


  if (breaks$type[nBreaks] == "a") {
    message(
      "No new prompt since the last answer. The last answer(s) are ignored and a fresh answer is generated from the last prompt."
    )
  }

  while ((breaks$type[nBreaks] == "a") & (nBreaks > 0)) {
    # the user expects a new answer to the same question, remove the last answers from the dialog
    prompt <- utils::head(x = prompt, -(length(x = prompt) - breaks$ind[nBreaks] + 1))

    breaks <- utils::head(x = breaks, -1)

    nBreaks <- nrow(x = breaks)
  }

  if (nBreaks == 0) {
    stop("Malformed request")
  }

  chatter <- "codestral"

  nc <- length(x = marker[[1]])
  nm <- length(x = marker[[2]])

  maxc <- 0
  maxm <- 0

  if (nc > 0) {
    maxc <- max(marker[[1]])
  }

  if (nm > 0) {
    maxm <- max(marker[[2]])
  }

  if (maxm > maxc) {
    chatter <- "mamba"
  }

  # rebuild the dialog block by block
  content <- sapply(X = 1:nrow(x = breaks), FUN = \(k) {
    type_ <- breaks$type[k]
    ind_ <- breaks$ind[k]

    ind_next <- breaks$ind[k + 1] - 1

    if (k == nBreaks) {
      ind_next <- length(x = prompt)
    }

    res <- paste(prompt[ind_:ind_next], collapse = "\n")

    # Remove the marker
    res <- stringr::str_sub(string = res,
                            start = 3,
                            end = -1)
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
