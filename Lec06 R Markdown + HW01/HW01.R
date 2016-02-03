#------------------------------------------------------------------------------
# Lines 1:77 are from last time:
# Make sure the directory is set to where states.csv is
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

state.means <- wp_data %>%
  select(state, ave_no_need_grant) %>%
  group_by(state) %>%
  summarise_each(funs(mean)) %>%
  arrange(desc(ave_no_need_grant))

state.info <- read.csv("states.csv", header=TRUE) %>% tbl_df()





#------------------------------------------------------------------------------
# EXERCISE FROM LAST TIME:
# 1. Merge the state.means data with the new state.info data so that we know
# what region each observation (i.e. university) is in

# ANSWER:  I use left_join here.  We only want to append info that exists in
# state.means
state.means <- left_join(state.means, state.info, by="state")
state.means



# 2. Recreate the bar chart from above, but color code the bars by which region
# of the US the state is a member of NE, south, west, midwest.  What trend do
# you notice?

# ANSWER:  We add fill=region (color=region) only does the outlines
ggplot(data=state.means, aes(x=state, y=ave_no_need_grant, fill=region)) +
  geom_bar(stat="identity") +
  ylab("avg no need grant")



# Somebody asked how do we rearrange the ordering of the states on the x-axis.
# Unfortunately there doesn't seem to be a clean dplyr way to do this.  Here is
# the hacky solution.  We first arrange the state.means data.frame in the order
# we want the states to show:  first by region, then descending order of
# average no need grant.
state.means <- arrange(state.means, region, desc(ave_no_need_grant))
state.means

# Then we "factor" the state variable to be a categorial variable whose
# "levels" determine the order.  If no levels are specified, then alphabetical
# is the default.  Note the $ sign is used to quickly access a variable from the
# data frame
factor(state.means$state)
factor(state.means$state, levels = state.means$state)

# Assign the latter
state.means$state <- factor(state.means$state, levels = state.means$state)

# Now we plot
ggplot(data=state.means, aes(x=state, y=ave_no_need_grant, fill=region)) +
  geom_bar(stat="identity") +
  ylab("avg no need grant")



# EXERCISE:  By changing the left_join() function to another join function,
# change the plot so that states that do not have any data do not get plotted at
# at all

# ANSWER:  We use inner_join instead() of left_join(), that way only states
# that exist in both data frames are plotted
state.data <- map_data("state") %>% tbl_df()
state.data <- inner_join(state.data, state.means, by=c("region" = "fullname"))

ggplot(state.data, aes(long, lat, group = group)) + # Recall "grouping"
  geom_polygon(aes(fill = ave_no_need_grant)) +
  geom_path(color="white") + # outline of states
  scale_fill_gradient(name="Avg. No\nNeed Grant", low='white', high='red')



# EXERCISE:  Recreate the above barchart and map but now split by the sector of the
# university: public or private.

# ANSWER:  We also group_by() sector as well as state:
state.means <- wp_data %>%
  select(state, sector, ave_no_need_grant) %>%
  group_by(state, sector) %>%
  summarise_each(funs(mean)) %>%
  arrange(desc(ave_no_need_grant)) %>%
  left_join(state.info, by="state")
state.means

ggplot(data=state.means, aes(x=state, y=ave_no_need_grant, fill=region)) +
  geom_bar(stat="identity") +
  ylab("avg no need grant") + facet_wrap(~sector, ncol=1)





#------------------------------------------------------------------------------
# Homework Data
#------------------------------------------------------------------------------
flights <- read.csv("flights.csv", stringsAsFactors = FALSE) %>%
  tbl_df() %>%
  mutate(date=as.Date(date))
weather <- read.csv("weather.csv", stringsAsFactors = FALSE) %>%
  tbl_df() %>%
  mutate(date=as.Date(date))
planes <- read.csv("planes.csv", stringsAsFactors = FALSE) %>% tbl_df()
airports <- read.csv("airports.csv", stringsAsFactors = FALSE) %>% tbl_df()





