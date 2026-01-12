## code to prepare `ALLMARKERS` dataset goes here

ALLMARKERS <-
  data.frame(
    marker = c("c:", "m:", "a:", "s:", "ff:"),
    decription = c("Codestral chat", "Codestral Mamba chat", "Answer", "System", "File")
  )

usethis::use_data(ALLMARKERS, overwrite = TRUE)
