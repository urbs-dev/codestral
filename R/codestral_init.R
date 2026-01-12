#' Initialize codestral
#'
#' Create environment variables for operationg FIM and chat.
#'
#' @param mistral_apikey,codestral_apikey The API keys to use for accessing
#'   Codestral Mamba and Codestral. Default to the value of the
#'   `R_MISTRAL_APIKEY`, `R_CODESTRAL_APIKEY` environment variable. Note that
#'   the name of the variable `mistra_apikey` is purposely not mentionning
#'   Codestral Mamba because this key can be use for other Mistral AI models
#'   (except Codestral).
#'
#' @param fim_model A string giving the model to use for FIM.
#'
#' @param chat_model A string giving the model to use for Codestral chat.
#'
#' @param mamba_model A string giving the model to use for Codestral Mamba chat.
#'
#' @param temperature An integer giving the temperature to use.
#'
#' @param max_tokens_FIM,max_tokens_chat Integers giving the maximum
#'   number of tokens to generate for each of these operations.
#'
#' @param role_content A role to assign to the system Default is "You write
#'   programs in R language only. You adopt a proper coding approach by strictly
#'   naming all the functions' parameters when calling any function with named
#'   parameters even when calling nested functions, by being straighforward in
#'   your answers."
#'
#' @returns Invisible `0`.
#'
#' @details The most important paremeters here are the `..._apikey` parameters
#'  without which the Mistral AI API can not be used.
#'
#' To start with, beginners may keep default values for other parameters. It
#' seems sound to use the latest models of each type. However with time, the
#' user may be willing to customize `temperature`, `max_tokens_FIM`, `max_tokens_chat` and
#' `role_content` for his/her own needs.
#'
#' @export
codestral_init <- function(mistral_apikey = Sys.getenv(x = "R_MISTRAL_APIKEY"),
                           codestral_apikey = Sys.getenv(x = "R_CODESTRAL_APIKEY"),
                           fim_model = "codestral-latest",
                           chat_model = "codestral-latest",
                           mamba_model = "open-codestral-mamba",
                           temperature = 0,
                           max_tokens_FIM = 100,
                           max_tokens_chat = "",
                           role_content = NULL) {
  stopifnot('This apikey is not a valid key' = (stringr::str_length(string = mistral_apikey) ==
                                                  32))

  stopifnot('This apikey is not a valid key' = (stringr::str_length(string = codestral_apikey) ==
                                                  32))

  Sys.setenv(R_MISTRAL_APIKEY = mistral_apikey)
  Sys.setenv(R_CODESTRAL_APIKEY = codestral_apikey)
  Sys.setenv(R_CODESTRAL_FIM_MODEL = fim_model)
  Sys.setenv(R_CODESTRAL_CHAT_MODEL = chat_model)
  Sys.setenv(R_CODESTRAL_MAMBA_MODEL = mamba_model)
  Sys.setenv(R_CODESTRAL_TEMPERATURE = temperature)
  Sys.setenv(R_CODESTRAL_MAX_TOKENS_FIM = max_tokens_FIM)
  Sys.setenv(R_CODESTRAL_MAX_TOKENS_CHAT = max_tokens_chat)
  Sys.setenv(R_CODESTRAL_DEBUG = FALSE)

  if (is.null(x = role_content)) {
    role_content <- "You write programs in R language only. You adopt a proper coding approach by strictly naming all the functions' parameters when calling any function with named parameters even when calling nested functions, by being straighforward in your answers."
  }

  Sys.setenv(R_CODESTRAL_ROLE_CONTENT = role_content)

  message("Initialization of codestral completed.")

  invisible(0)
}
