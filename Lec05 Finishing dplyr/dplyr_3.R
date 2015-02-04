#------------------------------------------------------------------------------
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
# Using the join command
#------------------------------------------------------------------------------
x <- data.frame(x1=c("A","B","C"), x2=c(1,2,3), stringsAsFactors=FALSE)
y <- data.frame(x1=c("A","B","D"), x3=c(TRUE,FALSE,TRUE), stringsAsFactors=FALSE)
z <- data.frame(x1=c("B","C","D"), x2=c(2,3,4), stringsAsFactors = FALSE)

# Compare these to the Venn Diagrams from:
# https://twitter.com/yutannihilation/status/551572539697143808
left_join(x, y, by="x1")
right_join(x, y, by="x1")
inner_join(x, y, by="x1")
semi_join(x, y, by="x1")
full_join(x, y, by="x1")
anti_join(x, y, by="x1")

# Other set operations
intersect(x, z)
union(x, z)
setdiff(x, z)



#------------------------------------------------------------------------------
# Improving the previous plot
#------------------------------------------------------------------------------
# We import the "states" CSV file into R.  First set R's working directory to
# match where the file is:  Files panel -> Navigate to Directory -> More ->
# "Set As Working Directory"
state.info <- read.csv("states.csv", header=TRUE) %>% tbl_df()

# EXERCISE: Merge the state.means data with the new state.info data and color
# code the barchart by region: NE, south, west, midwest



#------------------------------------------------------------------------------
# Maps
#------------------------------------------------------------------------------
# Get geographic coordinates of each state using the map_data() function in
# ggplot.  Examples:
map_data("county") %>% ggplot(aes(long, lat, group = group)) +
  geom_path(color="black")
map_data("world") %>% ggplot(aes(long, lat, group = group)) +
  geom_path(color="black")

# We join the state.means data and the map_data corresponding to states
state.data <- map_data("state") %>%
  left_join(state.means, by=c("region" = "fullname")) %>%
  tbl_df()
state.data

# What do you think the grey values mean? Note:  the "\n" is the "return"
# character
ggplot(state.data, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = ave_no_need_grant)) +
  geom_path(color="white") +
  scale_fill_gradient(name="Avg. No\nNeed Grant", low='white', high='red')


# EXERCISE:  Changing one word from above, change the plot so that states
# that do not have any data do not get plotted at at all
