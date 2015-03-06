library(dplyr)
library(stringr)
library(lubridate)

# Read in raw data, clean-up filenames, and count the number of slashes. If
# there are
# -3 slashes, that means where was no subfolder with the album name
# -4 slashes, that means where was a subfolder with the album name
# We remove a few cases that had 2 or 5 slashes, i.e. weird formatting of the
# filename
jukebox <- read.csv("mp3log.csv", header=FALSE) %>% tbl_df() %>%
  rename("date_time"=V1, "file"=V2) %>%
  mutate(
    file = gsub("/home/jukebox/tracks/", "", file),
    file = gsub(".mp3", "", file),
    num.slash = sapply(str_split(file, "/"), length)
    ) %>%
  filter(num.slash %in% c(3, 4))

# Split each filename at each "/".  The data is stored in a list (similar to a
# vector)
filename <- str_split(jukebox$file, "/")

# The artist is always the 2nd element of each list, the album is either the
# 3rd or 4th element of each list element, the track is always the last element
jukebox <-
  mutate(jukebox,
         artist = sapply(filename, function(x){x[[2]]}),
         album = ifelse(num.slash==4, sapply(filename, function(x){x[[3]]}), ""),
         track = sapply(filename, function(x){x[[length(x)]]})
  ) %>%
  select(-file, -num.slash)

# Write to a new CSV file
write.csv(jukebox, "jukebox.csv", row.names=FALSE)