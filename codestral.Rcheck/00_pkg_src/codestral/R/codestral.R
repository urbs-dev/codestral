#' Fill in the middle with Codestral
#'
#' This function completes a given prompt using the Codestral API. It supports
#' different models for fill-in-the-middle, chat with Codestral, and chat with
#' Mamba. The function relies on environment variables for some parameters.
#'
#' @param prompt The prompt to complete.
#'
#' @param mistral_apikey,codestral_apikey The API key to use for accessing
#'   Mamba/Codesstral. Defaults to the value of the `R_MISTRAL_APIKEY`,
#'   `R_CODESTRAL_APIKEY` environment variable.
#'
#' @param fim_model The model to use for fill-in-the-middle. Defaults to the
#'   value of the `R_CODESTRAL_FIM_MODEL` environment variable.
#'
#' @param chat_model The model to use for chat with Codestral. Defaults to the
#'   value of the `R_CODESTRAL_CHAT_MODEL` environment variable.
#'
#' @param mamba_model The model to use for chat with Mamba. Defaults to the
#'   value of the `R_MAMBA_CHAT_MODEL` environment variable.
#'
#' @param temperature The temperature to use. Defaults to the value of the
#'   `R_CODESTRAL_TEMPERATURE` environment variable.
#'
#' @param max_tokens_FIM,max_tokens_chat Integers giving the maximum number of
#'   tokens to generate for FIM and chat. Defaults to the value of the
#'   `R_CODESTRAL_MAX_TOKENS_FIM, R_CODESTRAL_MAX_TOKENS_CHAT` environment
#'   variables.
#'
#' @param role_content The role content to use. Defaults to the value of the
#'   `R_CODESTRAL_ROLE_CONTENT` environment variable.
#'
#' @param suffix The suffix to use. Defaults to an empty string.
#'
#' @return A character string containing the completed text.
#'
#' @export
codestral <- function(prompt,
                      mistral_apikey = Sys.getenv(x = "R_MISTRAL_APIKEY"),
                      codestral_apikey = Sys.getenv(x = "R_CODESTRAL_APIKEY"),
                      fim_model = Sys.getenv(x = "R_CODESTRAL_FIM_MODEL"),
                      chat_model = Sys.getenv(x = "R_CODESTRAL_CHAT_MODEL"),
                      mamba_model = Sys.getenv(x = "R_MAMBA_CHAT_MODEL"),
                      temperature = as.integer(Sys.getenv(x = "R_CODESTRAL_TEMPERATURE")),
                      max_tokens_FIM = Sys.getenv(x = "R_CODESTRAL_MAX_TOKENS_FIM"),
                      max_tokens_chat = Sys.getenv(x = "R_CODESTRAL_MAX_TOKENS_CHAT"),
                      role_content = Sys.getenv(x = "R_CODESTRAL_ROLE_CONTENT"),
                      suffix = "") {
  ENDPOINTS <- codestral::ENDPOINTS
  chatter <- "fim"

  if (mistral_apikey == "" |
      fim_model == "" |
      is.na(temperature) | max_tokens_FIM == "") {
    stop("Looks like you forgot to run codestral_init() once.")
  }

  if (max_tokens_chat == "") {
    max_tokens_chat <- NULL
  }

  # detect chat vs autocompletion
  isAnyChat <- stringr::str_starts(string = prompt, pattern = "c:") |
    stringr::str_starts(string = prompt, pattern = "m:")

  # detect if any file is refered to
  anyFile <- stringr::str_starts(string = prompt, pattern = "ff:")

  if (any(anyFile)) {
    prompt <- include_file(prompt = prompt, anyFile = anyFile)
  }

  # print(prompt)

  if (any(isAnyChat)) {
    messages <- data.frame(role = "system", content = role_content)

    dialog <- compile_dialog(prompt = prompt)

    messages <- rbind.data.frame(messages, dialog$dialog)

    chatter <- dialog$chatter

    # Prepare data for request
    if (is.null(max_tokens_chat)) {
      request_body <- list(
        model = chat_model,
        temperature = temperature,
        messages = messages
      )
    } else {
      request_body <- list(
        model = chat_model,
        temperature = temperature,
        max_tokens = max_tokens_chat,
        messages = messages
      )
    }
  }

  if (chatter == "codestral") {
    apikey <- codestral_apikey

    url <- ENDPOINTS$chatcodestral

  } else if (chatter == "mamba") {
    url <- ENDPOINTS$chatmistral

    apikey <- mistral_apikey

  } else if (chatter == "fim") {
    prompt_ <- paste(prompt, collapse = "\n")
    suffix <- paste(suffix, collapse = "\n")

    apikey <- codestral_apikey

    url <- ENDPOINTS$completion

    # Prepare data for request
    request_body <- list(
      model = fim_model,
      temperature = temperature,
      max_tokens = max_tokens_FIM,
      prompt = prompt_,
      suffix = suffix
    )
  }

  # Add request header
  headers <- c(
    `Authorization` = paste("Bearer", apikey),
    `Content-Type` = "application/json",
    `Accept` = "application/json"
  )

  # print(headers)

  body <- jsonlite::toJSON(request_body, auto_unbox = TRUE)

  # print(body)

  # Sent request
  response <- httr::POST(url,
                         body = body,
                         encode = "json",
                         httr::add_headers(.headers = headers))

  # print(response)

  # Check answer status
  if (httr::status_code(response) == 200) {
    content <- httr::content(response, "text", encoding = "utf8")
    result <- jsonlite::fromJSON(content)

  } else {
    stop(
      "Error during the request: ",
      httr::status_code(response),
      " - ",
      httr::content(response, "text", encoding = "utf8")
    )
  }

  if (any(isAnyChat)) {
    return(paste("\na:", result$choices$message$content))
  } else {
    return(result$choices$message$content)
  }
}
