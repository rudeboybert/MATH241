#------------------------------------------------------------------------------
# From last time:  Fix plot of acceptance rates per department
#------------------------------------------------------------------------------
data(UCBAdmissions)
UCB <- as.data.frame(UCBAdmissions) %>% tbl_df() %>%
  group_by(Admit, Dept) %>% summarize(Freq=sum(Freq))

ggplot(UCB, aes(x=Dept, y=Freq, fill = Admit)) +
  geom_bar(stat = "identity", position="fill") +
  ggtitle("Acceptance Rate Split by Department") +
  xlab("Dept") +
  ylab("% of Applicants")



#------------------------------------------------------------------------------
# More dplyr: adapted from Paideia 2015 Data Science and Visualization by
# Rich Majerus and Albert Y. Kim 2015/1/23
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Load all necessary packages
#------------------------------------------------------------------------------
# Verify that R version 3.1.2 is being used.  Should be True if not follow steps
# 1-3 here: http://reed.edu/data-at-reed/software/R/r_studio.html
R.Version()$major == '3' & R.Version()$minor == '1.2'

# Install necessary packages
pkg <- c("devtools", "rvest", "ggthemes",  "dplyr", "ggplot2",
         "ggmap", "RColorBrewer", "htmlwidgets", "RCurl", "scales")

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

# Update all packages
update.packages(checkBuilt=TRUE, ask=FALSE)

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



#------------------------------------------------------------------------------
# Scrape data from Washington Post into a data frame
#------------------------------------------------------------------------------
webpage <- html("http://apps.washingtonpost.com/g/page/local/college-grants-for-the-affluent/1526/")

# Look at first of all HTML tables
wp_data <- webpage %>% html_nodes("table") %>% .[[1]] %>% html_table()



#------------------------------------------------------------------------------
# Clean colnames and data types.  We will study such things as we go.
#------------------------------------------------------------------------------
# Function to clean col names:  this takes as input a tidy data frame, removes
# all non alphanumeric characters in the column names and sets them to lower
# case.
clean.names <- function(df){
  colnames(df) <- gsub("[^[:alnum:]]", "", colnames(df))
  colnames(df) <- tolower(colnames(df))
  return(df)
}

# Function to remove all $ signs and commas
currency.to.numeric <- function(x){
  x <- gsub('\\$','', as.character(x))
  x <- gsub('\\,','', as.character(x))
  x <- as.numeric(x)
  return(x)
}

# The data is a bit messy at first:  some missing values, column names are too
# long
View(wp_data)

# Guess:
# * What does the clean.names() function do?
# * What does the %<>% does?  Ask me if you're not sure.
# * The mutate command from last time
wp_data %<>%
  clean.names() %>%
  rename(
    comp_fee = tuitionfeesroomandboard201314,
    p_no_need_grant = percentoffreshmenreceivingnoneedgrantsfromschool,
    ave_no_need_grant = averagenoneedawardtofreshmen,
    p_need_grant = percentreceivingneedbasedgrantsfromschool
    ) %>%
  mutate(
    # Convert character strings to factors i.e. categorical variables
    state = as.factor(state),
    sector = as.factor(sector),
    # Convert currencies to numeric i.e. strip dollar signs and commas
    comp_fee = currency.to.numeric(comp_fee),
    ave_no_need_grant = currency.to.numeric(ave_no_need_grant),
    # Using the ifelse() command, replace missing values with .5
    p_no_need_grant = ifelse(is.na(p_no_need_grant), .5, p_no_need_grant))

# Now look at it.  A bit cleaner
View(wp_data)



#------------------------------------------------------------------------------
# Geocode and map data
#------------------------------------------------------------------------------
# Using the geocode() function from the ggmap package, get geocodes of school
# locations based on school name by searching Google maps.  The code takes about
# two minutes; uncomment and run if you're curious:
#
# gc <- do.call(rbind, lapply(as.character(wp_data$school), geocode))
# wp_data %<>% mutate(lon=gc$lon, lat=gc$lat)

# Or read in previously calculated geocodes
x <- getURL("https://raw.githubusercontent.com/majerus/paideia_reed_college/master/data_science_and_visualization/geocodes.csv")
gc <- read.csv(text = x)
gc$X <- NULL
wp_data %<>% mutate(lon=gc$lon, lat=gc$lat)

# Let's take a quick look at where all the colleges in the data are located using
# the leaflet() package:
leaflet(wp_data) %>%
  addTiles() %>%
  setView(-93.65, 42.0285, zoom = 3) %>%
  addCircles(wp_data$lon, wp_data$lat)


# It might be helpful to color code the schools based on the average no need
# grant variable in the data by defining a new color palette where darker
# indicates higher values
pal <- colorQuantile("YlOrRd", NULL, n = 6)

leaflet(wp_data) %>%
  addTiles() %>%
  setView(-93.65, 42.0285, zoom = 3) %>%
  addCircles(wp_data$lon, wp_data$lat) %>%
  addCircles(wp_data$lon, wp_data$lat, color = ~pal(ave_no_need_grant)) %>%
  addCircleMarkers(wp_data$lon, wp_data$lat, color = ~pal(ave_no_need_grant))



#------------------------------------------------------------------------------
# STEP 1: CREATING NEW VARIABLES
#------------------------------------------------------------------------------
# Create a region (south) variable:
table(wp_data$state)
state.list <- c('AL', 'AR', 'FL', 'GA', 'KY', 'LA', 'NC', 'SC', 'TN', 'TX')

wp_data %<>%
  mutate(south = ifelse(state %in% state.list, 'south', 'non-south'))

# EXERCISE: create a region (NE) variable by changing the above code to create a
# binary variable that identifies the following states
state.list <- c('CT', 'DC', 'DE', 'MA', 'MD', 'ME', 'NH', 'NJ', 'NY', 'PA', 'RI', 'VT')



#------------------------------------------------------------------------------
# STEP 2: ARRANGE and SELECT DATA
#------------------------------------------------------------------------------
# Arranging/sorting the data by region (south)
# First let's sort the data by the south region variable
wp_data %<>%
  arrange(south)

# The default for arrange is ascending, let's put that in descending order instead
wp_data %<>%
  arrange(desc(south))

# It might be more useful to sort the data by multiple variables
wp_data %<>%
  arrange(desc(south), ave_no_need_grant)

# We can also create a NEW data frame with just these variables while executing this code
south.data <-
  wp_data %>%
  arrange(desc(south), ave_no_need_grant) %>%
  select(south, ave_no_need_grant)

# Let's take a look.  What's missing?
View(south.data)

# Oops we forgot to include school name and sector
south.data <-
  wp_data %>%
  arrange(desc(south), ave_no_need_grant) %>%
  select(school, sector, south, ave_no_need_grant)

# EXERCISE: Create a similarly ordered data frame for the north_east



#------------------------------------------------------------------------------
# STEP 3: SUMMARIZE YOUR DATA
#------------------------------------------------------------------------------
# EXAMPLE: find the mean and standard deviation of each variable by region (south)
south.data %>%
  group_by(south) %>%
  summarise(mean_merit = mean(ave_no_need_grant))

# summarise_each() is like summarise, but on all (numerical) columns
south.data %>%
  group_by(south) %>%
  summarise_each(funs(mean(.), sd(.)))

# Or you can specify columns
wp_data %>%
  group_by(south) %>%
  summarise_each(
    funs(mean(.)),
    p_no_need_grant,  ave_no_need_grant,	p_need_grant)

wp_data %>%
  group_by(south) %>%
  summarise_each(
    funs(mean(.), sd(.)),
    p_no_need_grant,  ave_no_need_grant)

# EXERCISE: Do the same for NE schools




#------------------------------------------------------------------------------
# STEP 4: VISUALIZE YOUR DATA (HISTORGRAMS)
#------------------------------------------------------------------------------
ggplot(south.data, aes(x=ave_no_need_grant)) +
  geom_histogram()

ggplot(south.data, aes(x=ave_no_need_grant)) +
  geom_histogram() +
  theme_classic()

ggplot(south.data, aes(x=ave_no_need_grant)) +
  geom_histogram() +
  theme_classic() +
  facet_wrap( ~  south, ncol=2)

ggplot(south.data, aes(x=ave_no_need_grant, fill=as.factor(south))) +
  geom_histogram() +
  theme_classic() +
  facet_wrap( ~  south, ncol=2)

# The difference between facet_wrap() and facet_grid() is that you can
# cross-classify on two variables like below where the sector categorical
# variable are the columns and the south variable is are the rows
ggplot(south.data, aes(x=ave_no_need_grant, fill=as.factor(south))) +
  geom_histogram() +
  theme_classic() +
  facet_grid(south ~  sector)

ggplot(south.data, aes(x=ave_no_need_grant, fill=as.factor(south))) +
  geom_histogram(aes(y = ..density..)) +
  theme_classic() +
  facet_grid(south ~  sector)



#------------------------------------------------------------------------------
# EXERCISE:  Answer question from lecture
#------------------------------------------------------------------------------
# I want to know which states have the highest average no need grants (averaged
# over schools).
# 1. Create the smallest data frame (i.e. least number of rows, least number of
# columns) that answers this question.
# 2. Challenge: create a visualization of this data


