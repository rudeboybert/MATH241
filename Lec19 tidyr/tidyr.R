library(tidyr)
library(dplyr)
library(ggplot2)
library(stringr)

# Install the babynames package first: All babynames (with n >= 5) from Social
# Security Administration from 1880 to 2013: https://github.com/hadley/babynames
library(babynames)

# Run the following line to load necessary example data: cases, storms, pollution
source("http://people.reed.edu/~albkim/MATH241/Lec19_examples.R")






#-------------------------------------------------------------------------------
# Tutorial
#-------------------------------------------------------------------------------
#---------------------------------------------------------------
# Going from tidy (AKA narrow AKA tall) format to wide format and vice versa
# using gather() and separate()
#---------------------------------------------------------------
# Convert to tidy format. All three of the following do the same:  "year" is the
# new "key" variable and n is the "value" variable
cases
gather(data=cases, key="year", value=n, 2:4)
gather(cases, "year", n, `2011`, `2012`, `2013`)
gather(cases, "year", n, -country)


# Convert to wide format. The "key" variable is size and the "value" variable is
# amount
pollution
spread(pollution, size, amount)


# Note: gather() and spread() are opposites of each other
cases
gather(cases, "year", n, -country) %>% spread(year, n)



#---------------------------------------------------------------
# separate() and unite() columns
#---------------------------------------------------------------
# Separate the year, month, day from the date variable":
storms
storms2 <- separate(storms, date, c("year", "month", "day"), sep = "-")
storms2

# Undo the last change using unite()
unite(storms2, "date", year, month, day, sep = "-")





#-------------------------------------------------------------------------------
# EXERCISES
#-------------------------------------------------------------------------------
# From Eleanor: Census data with total population, land area, and population
# density in wide format
census <- read.csv("popdensity1990_00_10.csv", header=TRUE) %>% tbl_df()
View(census)


# EXERCISE: Add varibles "county_name" and "state_name" to the census data
# frame, which are derived from the variable "QName".  Do this in a manner that
# keeps the variable "QName" in the data frame.



# EXERCISE: Create a new variable FIPS_code that follows the federal standard:
# http://www.policymap.com/blog/wp-content/uploads/2012/08/FIPSCode_Part4.png
# As a sanity check, ensure that the county with FIPS code "08031" is Denver
# County, Colorado.  Hint: str_pad() command in the stringr



# EXERCISE: Plot histograms of the population per county, where we have the
# histograms facetted by year.



# EXERCISE: Now consider the babynames data set which is in tidy format.  For
# example, consider the top male names from the 1880's:
babynames
filter(babynames, year >=1880 & year <= 1889, sex=="M") %>%
  group_by(name) %>%
  summarize(n=sum(n)) %>%
  ungroup() %>%
  arrange(desc(n))


# The most popular male and female names in the 1890's were John and Mary.
# Present the proportion for all males named John and all females named Mary
# (some males were recorded as females, for example) for each of the 10 years in
# the  1890's in wide format.  i.e. your table should have two rows, and 11
# columns: name and the one for each year


