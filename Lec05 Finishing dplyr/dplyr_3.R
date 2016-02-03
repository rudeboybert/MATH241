#------------------------------------------------------------------------------
# Lines 1:68 are from last time:
# Load all necessary packages and recompute Washington Post data
#------------------------------------------------------------------------------
# Install necessary packages
pkg <- c("devtools", "rvest", "ggthemes",  "dplyr", "ggplot2", "ggmap",
         "RColorBrewer", "htmlwidgets", "RCurl", "scales")

new.pkg <- pkg[!(pkg %in% installed.packages())]
if (length(new.pkg)) {
  install.packages(new.pkg)
}
# Install rvest and leaflet packages
if (!require("rvest")) {
  devtools::install_github("hadley/rvest")
}
if (!require("leaflet")) {
  devtools::install_github("rstudio/leaflet")
}

# Load all packages
library(rvest)
library(leaflet)
library(devtools)
library(htmlwidgets)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(ggmap)
library(RColorBrewer)
library(magrittr)
library(RCurl)
library(scales)

# Load data
webpage <- html("http://apps.washingtonpost.com/g/page/local/college-grants-for-the-affluent/1526/")
wp_data <- webpage %>% html_nodes("table") %>% .[[1]] %>% html_table()

# Load functions
clean.names <- function(df){
  colnames(df) <- gsub("[^[:alnum:]]", "", colnames(df))
  colnames(df) <- tolower(colnames(df))
  return(df)
}
currency.to.numeric <- function(x){
  x <- gsub('\\$','', as.character(x))
  x <- gsub('\\,','', as.character(x))
  x <- as.numeric(x)
  return(x)
}

# Clean data
wp_data <-
  clean.names(wp_data) %>%
  rename(
    comp_fee = tuitionfeesroomandboard201314,
    p_no_need_grant = percentoffreshmenreceivingnoneedgrantsfromschool,
    ave_no_need_grant = averagenoneedawardtofreshmen,
    p_need_grant = percentreceivingneedbasedgrantsfromschool
  ) %>%
  mutate(
    state = as.factor(state),
    sector = as.factor(sector),
    comp_fee = currency.to.numeric(comp_fee),
    ave_no_need_grant = currency.to.numeric(ave_no_need_grant),
    p_no_need_grant = ifelse(is.na(p_no_need_grant), .5, p_no_need_grant)
    ) %>%
  tbl_df()



#------------------------------------------------------------------------------
# EXERCISE FROM LAST TIME:  Answer question from lecture
#------------------------------------------------------------------------------
# I want to know which states have the highest average no need grants (averaged
# over schools).
# 1. Create the smallest data frame (i.e. least number of rows, least number of
# columns) that answers this question.
# 2. Challenge: create a visualization of this data

# Using the wp_data data frame, create a new data frame called state_means with
# two variables:
# 1) state: the state's abbreviation
# 2) ave_no_need_grant: the state's average no need grant, averaged over schools
# where the entire data frame is sorted in descending order of average no need
# grant.
state.means <- wp_data %>%
  select(state, ave_no_need_grant) %>%
  group_by(state) %>%
  summarise_each(funs(mean)) %>%
  arrange(desc(ave_no_need_grant))
state.means

# There are many different plots one can do.  Here is one.  Click on zoom to get
# a better look
ggplot(data=state.means, aes(x=state, y=ave_no_need_grant)) +
  geom_bar(stat="identity") +
  ylab("avg no need grant")



#------------------------------------------------------------------------------
# Learning the join command
#------------------------------------------------------------------------------
# Let's test out join commands on these data sets.  Setting stringsAsFactors =
# FALSE treats the letters A, B, C, D as character strings, and not factors
# (i.e. categorical variables)
x <- data.frame(x1=c("A","B","C"), x2=c(1,2,3), stringsAsFactors=FALSE)
y <- data.frame(x1=c("A","B","D"), x3=c(TRUE,FALSE,TRUE), stringsAsFactors=FALSE)
z <- data.frame(x1=c("B","C","D"), x2=c(2,3,4), stringsAsFactors = FALSE)

# Compare the outputs of the following 6 commands to the Venn Diagrams from:
# https://twitter.com/yutannihilation/status/551572539697143808
left_join(x, y, by="x1")
right_join(x, y, by="x1")
inner_join(x, y, by="x1")
semi_join(x, y, by="x1")
full_join(x, y, by="x1")
anti_join(x, y, by="x1")

# Other useful set operations, also included on your cheat sheet.
intersect(x, z)
union(x, z)
setdiff(x, z)
bind_rows(x, y)
bind_rows(x, x) %>% distinct()



#------------------------------------------------------------------------------
# Improving the previous plot
#------------------------------------------------------------------------------
# We import the "states" CSV file into R.  First set R's working directory to
# match where the file is:  Files panel -> Navigate to Directory -> More ->
# "Set As Working Directory"
state.info <- read.csv("states.csv", header=TRUE) %>% tbl_df()
state.info

# EXERCISE:
# 1. Merge the state.means data with the new state.info data so that we know
# what region each observation (i.e. university) is in
# 2. Recreate the bar chart from above, but color code the bars by which region
# of the US the state is a member of NE, south, west, midwest.  What trend do
# you notice?



#------------------------------------------------------------------------------
# Maps
#------------------------------------------------------------------------------
# ggplot has a lot of preloaded maps in it, for which you can get the geographic
# coordinates using the map_data() function.  Examples:

# Takes a few seconds:
map_data("county") %>%
  ggplot(aes(long, lat, group = group)) +
  geom_path(color="black")

map_data("world") %>%
  ggplot(aes(long, lat, group = group)) +
  geom_path(color="black")

# We'll use states
map_data("state") %>%
  ggplot(aes(long, lat, group = group)) +
  geom_path(color="black")


# We join the state.means data and the map_data() corresponding to states.
# Notice the "by" argument in the left_join.  Read the help file to understand
# what's going on.  If you can't figure it out, ask me.
state.data <- map_data("state") %>% tbl_df()
state.data

state.data <- left_join(state.data, state.means, by=c("region" = "fullname"))
state.data

# What do you think the grey values mean? Note:  the "\n" is the "return"
# character
ggplot(state.data, aes(long, lat, group = group)) + # Recall "grouping"
  geom_polygon(aes(fill = ave_no_need_grant)) +
  geom_path(color="white") + # outline of states
  scale_fill_gradient(name="Avg. No\nNeed Grant", low='white', high='red')


# EXERCISE:  By changing the left_join() function to another join function,
# change the plot so that states that do not have any data do not get plotted at
# at all



#------------------------------------------------------------------------------
# Exercise
#------------------------------------------------------------------------------
# Recreate the above barchart and map but now split by the sector of the
# university: public or private.



