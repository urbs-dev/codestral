## code to prepare `ENDPOINTS` dataset goes here
##
ENDPOINTS <-
  list(completion = "https://codestral.mistral.ai/v1/fim/completions",
       chatcodestral = "https://codestral.mistral.ai/v1/chat/completions",
       chatmistral = "https://api.mistral.ai/v1/chat/completions")


usethis::use_data(ENDPOINTS, overwrite = TRUE)
