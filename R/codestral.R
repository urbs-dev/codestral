#' Fill in the middle with Codestral
#' @param prompt The prompt to complete.
#' @param api_key Your Codestral API key.
#' @param model The model to use.
#' @param temperature The temperature to use.
#' @param max_tokens The maximum number of tokens to generate.
#' @param suffix The suffix to use.
#' @param ENDPOINTS The endpoints to use.
#' @return The completed text.
#' @examples
#' # codestral(prompt = "Once upon a time")
#' @export
codestral <- function(prompt,
                      api_key = Sys.getenv(x = "R_CODESTRAL_APIKEY"),
                      model = Sys.getenv(x = "R_CODESTRAL_MODEL"),
                      temperature = as.integer(Sys.getenv(x = "R_CODESTRAL_TEMPERATURE")),
                      max_tokens = Sys.getenv(x = "R_CODESTRAL_MAX_TOKENS"),
                      suffix = "",
                      ENDPOINTS = ENDPOINTS) {

  if(api_key=="" | model == "" |is.na(temperature) | max_tokens==""){
    stop("Looks like you forgot to run codestral_init() once.")
  }

  # if (is.null(x = suffix)) {
    url <- ENDPOINTS$completion

  # } else {
  #   url <- ENDPOINTS$chat
  # }

  # Prepare data for request
  request_body <- list(
    model = model,
    temperature = temperature,
    max_tokens = max_tokens,
    prompt = prompt,
    suffix = suffix
  )

  # Add request header
  headers <- c(
    `Authorization` = paste("Bearer", api_key),
    `Content-Type` = "application/json",
    `Accept` = "application/json"
  )

  # Sent request
  response <- httr::POST(
    url,
    body = jsonlite::toJSON(request_body, auto_unbox = TRUE),
    encode = "json",
    httr::add_headers(.headers = headers)
  )

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

  return(result$choices$message$content)
}
