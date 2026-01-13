#' Inventory R files in the current directory
#'
#' This function returns a data frame with the file names and paths of all R files in the current directory.
#'
#' @return A data frame with the file names and paths of all R files in the current directory.
#'
#' @examples
#' inventory_Rfiles()
#'
#' @export
inventory_Rfiles <- function(){
  # get all R files in the current directory
  Rfiles <- list.files(pattern = "\\.R$", recursive = TRUE)
  # get the current directory
  current_dir <- getwd()
  # create a data frame with the file names and paths
  Rfiles_df <- data.frame(
    file_name = basename(Rfiles),
    file_path = file.path(current_dir, Rfiles)
  )
  # return the data frame
  return(Rfiles_df)
}
