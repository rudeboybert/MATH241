# This tutorial was adapted from the materials from STAT 545 @ University of
# British Columbia, a course in data wrangling, exploration, and analysis with
# R.  https://github.com/STAT545-UBC/STAT545-UBC.github.io

# In this tutorial, we will use the Gapminder data and file names in our [class repository](https://github.com/STAT545-UBC/STAT545-UBC.github.io) as examples to demonstrate using regular expression in R. First, let's start off by cloning the class repository, getting the list of file names with `list.files()`, and load the Gapminder dataset into R.

library(stringr)
library(dplyr)

world <- read.delim("gapminderDataFiveYear.txt") %>% tbl_df()


countries <- unique(world$country) %>% as.character()




# Regular expression is a pattern that describes a specific set of strings with
# a common structure. It is heavily used for string matching / replacing in all
# programming languages, although specific syntax may differ a bit. It is truly
# the heart and soul for string operations. In R, many string functions in
# base R as well as in stringr package use regular expressions, even
# Rstudio's search and replace allows regular expressions.

# -Identify match to a pattern:
#   grep(..., value = FALSE), grepl(), stringr::str_detect()
# -Extract match to a pattern:
#   grep(..., value = TRUE), stringr::str_extract(), stringr::str_extract_all()
# -Locate pattern within a string, i.e. give the start position of matched patterns.
#   regexpr(), gregexpr(), stringr::str_locate(), stringr::str_locate_all()
# -Replace a pattern:
#   sub(), gsub(), stringr::str_replace(), stringr::str_replace_all()
# -Split a string using a pattern:
#   strsplit(), stringr::str_split()