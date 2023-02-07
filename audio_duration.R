# For loop extracting audio clip duration --------------------------------------

## Basic Set-up ----------------------------------------------------------------

packages <- c("tidyverse","av","fs", "psych")

lapply(packages, library, character.only = TRUE)

## For loop -------------------------------------------------------------------- 

file_paths <- fs::dir_ls("./Audio") # set file path

file_contents <- rep(NA, length(file_paths))

for (i in seq_along(file_paths)){
  file_contents[i] <- av_media_info(
    file = file_paths[[i]])[[1]]
}

## Creating data frame with ID & Duration --------------------------------------

id_vec <- 1:length(file_paths)

df <- data.frame(id_vec,file_contents)

columns = c("ID", "duration") 

colnames(df) = columns

df$minutes <- df$duration/60

## Some descriptives of duration -----------------------------------------------

duration_desc <- describe(df)

## Export data frame -----------------------------------------------------------

write.csv(
  df,
  "./duration.csv",
  row.names = FALSE
)

