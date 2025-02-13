#' Initialize codestral
#'
#' @param apikey Your codestral API key.
#' @param fim_model The model to use for FIM.
#' @param chat_model The model to use for chat.
#' @param mamba_model The model to use for mamba.
#' @param temperature The temperature to use.
#' @param max_tokens The maximum number of tokens to generate.
#'
#' @export
codestral_init <- function(apikey = NULL,
                           fim_model = "codestral-latest",
                           chat_model = "codestral-latest",
                           mamba_model = "open-codestral-mamba",
                           temperature = 0,
                           max_tokens = 100) {
  currentkey <- Sys.getenv("R_CODESTRAL_APIKEY")

  if (currentkey == "") {
    stopifnot('This apikey is not a valid key' = (stringr::str_length(string = apikey) ==
                                                    32))

    Sys.setenv(R_CODESTRAL_APIKEY = apikey)
  }

  Sys.setenv(R_CODESTRAL_FIM_MODEL = fim_model)
  Sys.setenv(R_CODESTRAL_CHAT_MODEL = chat_model)
  Sys.setenv(R_CODESTRAL_MAMBA_MODEL = mamba_model)
  Sys.setenv(R_CODESTRAL_TEMPERATURE = 0)
  Sys.setenv(R_CODESTRAL_MAX_TOKENS = 100)

  return("Initialization of codestral completed.")
}

