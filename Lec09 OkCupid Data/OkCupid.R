library(ggplot2)
library(dplyr)
# Used for string manipulation:
library(stringr)


#------------------------------------------------
# Load Data & Preprocess It
#------------------------------------------------
profiles <- read.csv("profiles.csv", header=TRUE) %>% tbl_df()

# Split off the essays into a separate data.frame
essays <- select(profiles, contains("essay"))
profiles <- select(profiles, -contains("essay"))

# Look at our data
names(profiles)
glimpse(profiles)

# Because essays is of tbl_df() format, we can't see all the essays of the 9th
# individual.
essays[9, ]
# Use print.data.frame() to see all that person's essays
print.data.frame(essays[9, ])

# Define a binary outcome variable
# y_i = 1 if female
# y_i = 0 if male
profiles <- mutate(profiles, is.female = ifelse(sex=="f", 1, 0))

# Preview of things to come:  The variable "last online" includes the time.  We
# remove them by using the str_sub() function from the stringr package.  i.e.
# take the "sub-string" from position 1 to 10 of each string.  Then we convert
# them to dates.
profiles$last_online[1:10]
profiles$last_online <- str_sub(profiles$last_online, 1, 10) %>% as.Date()
profiles$last_online[1:10]

# Lastly we define a variable which counts the number of characters in the user's
# username.  We convert the
profiles$username.len <- profiles$username %>% as.character %>% nchar()



#------------------------------------------------
# Naive Model
#------------------------------------------------
# If you had to guess a user's sex via coin flips (i.e. using no information),
# where getting heads = declaring user is female, what should be the probability
# of heads?



#------------------------------------------------
# Search for words
#------------------------------------------------
# The following two functions allow us to search each row of a data.frame for
# a string.  (More when we cover text mining).
find.query <- function(char.vector, query){
  which.has.query <- grep(query, char.vector, ignore.case = TRUE)
  length(which.has.query) != 0
}
profile.has.query <- function(data.frame, query){
  query <- tolower(query)
  has.query <- apply(data.frame, 1, find.query, query=query)
  return(has.query)
}

# Search for the string "wine"
profiles$has.wine <- profile.has.query(data.frame = essays, query = "wine")
x <- table(profiles$has.wine)
x
# Quick and dirty barplot, w/o using ggplot
barplot(x, xlab="Has 'wine'?")

# Contingency table:
y <- table(profiles$sex, profiles$has.wine)
y
# mosaicplot.  What do the bar widths mean?
mosaicplot(y, xlab="sex", ylab="Has 'wine'?")

# Exercise:  Visualize the relationship between the presence of the word "wine"
# and the presence of the word "food" in users' profiles



#------------------------------------------------
# Is height predictive of sex?
#------------------------------------------------
# Exercise:  Compare the heights of females and males using geom_histogram()

# Exercise Plot the binary variable is.female over height (i.e. height on the
# x-axis).  What's wrong with this basic visualization? What function from the
# last class' exercise can alleviate this problem?

# Exercise:  Sketch out in your mind what the best fitting function through
# these points are where the function doesn't have to be linear.  Recall a
# function maps each value of x to a single value.



#------------------------------------------------
# Is the number of characters in one's username predictive of sex?
#------------------------------------------------
# Exercise:  Compare the number of characters used in the usernames of females
# and males using geom_bar()

# Exercise Plot the binary variable is.female over username.len

# Exercise:  Sketch out in your mind what the best fitting function through
# these points is where the function doesn't have to be linear.  Recall a
# function maps each value of x to a single value.



#------------------------------------------------
# Additional Changing Levels of a Factor
#------------------------------------------------
# Let's say you want to create a binary variable smokes vs not using:
levels(profiles$smokes)
count(profiles, smokes)

# You can do this be reassigning the levels of the variable
profiles$is.smoker <- profiles$smokes
levels(profiles$is.smoker) <- c("NA", "no", "yes", "yes", "yes", "yes")
count(profiles, is.smoker)

mosaicplot(table(profiles$sex, profiles$is.smoker))



#------------------------------------------------
# Exercise
#------------------------------------------------
# Do an EDA of all the varibles in this dataset using ggplot/dplyr and
# quick-and-dirty tools.  Talk to your peers.  You will be using this dataset
# for HW02!