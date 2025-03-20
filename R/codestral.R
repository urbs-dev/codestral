#' Fill in the middle with Codestral
#'
#' This function completes a given prompt using the Codestral API. It supports different models
#' for fill-in-the-middle, chat with Codestral, and chat with Mamba. The function relies on
#' environment variables for some parameters.
#'
#' @param prompt The prompt to complete.
#' @param codestral_api_key The API key to use for accessing Codestral. Defaults to the value of the
#'   `R_CODESTRAL_APIKEY` environment variable.
#' @param mistral_api_key The API key to use for accessing Mamba. Defaults to the value of the
#'   `R_MISTRAL_APIKEY` environment variable.
#' @param fim_model The model to use for fill-in-the-middle. Defaults to the value of the
#'   `R_CODESTRAL_FIM_MODEL` environment variable.
#' @param chat_model The model to use for chat with Codestral. Defaults to the value of the
#'   `R_CODESTRAL_CHAT_MODEL` environment variable.
#' @param mamba_model The model to use for chat with Mamba. Defaults to the value of the
#'   `R_MAMBA_CHAT_MODEL` environment variable.
#' @param temperature The temperature to use. Defaults to the value of the `R_CODESTRAL_TEMPERATURE`
#'   environment variable.
#' @param max_tokens The maximum number of tokens to generate. Defaults to the value of the
#'   `R_CODESTRAL_MAX_TOKENS` environment variable.
#' @param suffix The suffix to use. Defaults to an empty string.
#' @return A character string containing the completed text.
#' @examples
#' \dontrun{
#' codestral(prompt = "Once upon a time")
#' }
#' @export
codestral <- function(prompt,
                      codestral_api_key = Sys.getenv(x = "R_CODESTRAL_APIKEY"),
                      mistral_api_key = Sys.getenv(x = "R_MISTRAL_APIKEY"),
                      fim_model = Sys.getenv(x = "R_CODESTRAL_FIM_MODEL"),
                      chat_model = Sys.getenv(x = "R_CODESTRAL_CHAT_MODEL"),
                      mamba_model = Sys.getenv(x = "R_MAMBA_CHAT_MODEL"),
                      temperature = as.integer(Sys.getenv(x = "R_CODESTRAL_TEMPERATURE")),
                      max_tokens = Sys.getenv(x = "R_CODESTRAL_MAX_TOKENS"),
                      suffix = "") {
  ENDPOINTS <- codestral::ENDPOINTS
  chatter <- "fim"

  if (codestral_api_key == "" |
      fim_model == "" | is.na(temperature) | max_tokens == "") {
    stop("Looks like you forgot to run codestral_init() once.")
  }

  # detect chat vs autocompletion
  isAnyChat <- stringr::str_starts(string = prompt, pattern = "c:") |
    stringr::str_starts(string = prompt, pattern = "m:")

  # detect if any file is refered to
  anyFile <- stringr::str_starts(string = prompt, pattern = "ff:")

  if(any(anyFile)){
    prompt <- include_file(prompt = prompt, anyFile = anyFile)
  }

  # print(prompt)

  if (any(isAnyChat)) {
    messages <- data.frame(role = "system", content = "You write programs in R language only. You adopt a proper coding approach by strictly naming all the functions' parameters when calling any function with named parameters even when calling nested functions, by being straighforward in your answers.")

    dialog <- compile_dialog(prompt = prompt)

    messages <- rbind.data.frame(messages, dialog$dialog)

    chatter <- dialog$chatter

    # Prepare data for request
    request_body <- list(model = chat_model,
                         temperature = temperature,
                         # max_tokens = max_tokens,
                         messages = messages)
  }

  if (chatter == "codestral") {
    api_key <- codestral_api_key

    url <- ENDPOINTS$chatcodestral

  } else if (chatter == "mamba") {
    url <- ENDPOINTS$chatmistral

    api_key <- mistral_api_key

  } else if (chatter == "fim") {
    prompt_ <- paste(prompt, collapse = "\n")
    suffix <- paste(suffix, collapse = "\n")

    api_key <- codestral_api_key

    url <- ENDPOINTS$completion

    # Prepare data for request
    request_body <- list(
      model = fim_model,
      temperature = temperature,
      max_tokens = max_tokens,
      prompt = prompt_,
      suffix = suffix
    )
  }

  # Add request header
  headers <- c(
    `Authorization` = paste("Bearer", api_key),
    `Content-Type` = "application/json",
    `Accept` = "application/json"
  )

  body <- jsonlite::toJSON(request_body, auto_unbox = TRUE)

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
