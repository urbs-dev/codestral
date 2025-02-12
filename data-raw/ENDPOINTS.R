## code to prepare `ENDPOINTS` dataset goes here
##
ENDPOINTS <-
  list(completion = "https://codestral.mistral.ai/v1/fim/completions",
       chat = "https://codestral.mistral.ai/v1/chat/completions")


usethis::use_data(ENDPOINTS, overwrite = TRUE)
