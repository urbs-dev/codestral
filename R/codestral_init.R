#' Initialize codestral
#'
#' @param apikey Your codestral API key
#' @param model The model to use
#' @param temperature The temperature to use
#' @param max_tokens The maximum number of tokens to generate
#'
#' @export
codestral_init <- function(apikey = NULL,
                           model = "codestral-latest",
                           temperature = 0,
                           max_tokens = 100) {
  currentkey <- Sys.getenv("R_CODESTRAL_APIKEY")

  if (currentkey == "") {
    stopifnot('This apikey is not a valid key' = (stringr::str_length(string = apikey) ==
                                                    32))

    Sys.setenv(R_CODESTRAL_APIKEY = apikey)
  }

  Sys.setenv(R_CODESTRAL_MODEL = model)
  Sys.setenv(R_CODESTRAL_TEMPERATURE = 0)
  Sys.setenv(R_CODESTRAL_MAX_TOKENS = 100)

  return("Codestral ready. Anywhere in your script, click Addins>Codestral code completion in the Rstudio tool barto fill in the middle the code at the cursor position on the current script. You can assign a shortcut to this addin from Tools>Addins")
}

