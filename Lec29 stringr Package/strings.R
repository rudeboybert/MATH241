library(Quandl)
library(twitteR)
library(stringr)
library(lubridate)
library(ggplot2)
library(dplyr)

#-------------------------------------------------------------------------------
# The paste() function (in base R)
#-------------------------------------------------------------------------------
# The greatest of all R string/character commands:  the paste() command!
# You can combine text and R variables.
PI <- paste("The life of", pi)
PI

# The next example is one of programming abstractly.  i.e. you assign all
# specific values to variables, and then use the variable names throughout the
# rest of your code.  That way if you want to change either the name or the
# number to order, you only need to change it once, instead of everywhere in
# your document.
name <- "BORT"
number.to.order <- 76
paste("We need to order", number.to.order, name, "novelty license plates.")

# paste() is very useful when you want to automate the creation of strings.  For
# example say you want to produce a daily chart of bitcoin prices with a title
# indicating the date range.  It would get tiring to everyday update the title
# manually.  With paste() you can do this automagically!
bitcoin <- Quandl("BAVERAGE/USD", start_date="2013-01-01") %>% tbl_df() %>%
  mutate(Date=ymd(Date))

title <- paste("Bitcoin prices from", min(bitcoin$Date), "to", max(bitcoin$Date))

ggplot(bitcoin, aes(x=Date, y=`24h Average`)) +
  geom_line() +
  xlab("Date") + ylab("24h Average Price") +
  ggtitle(title) +
  geom_smooth(n=100)

# There are two possible arguments. 'collapse' to collapse a single vector of
# character strings and 'sep' to determine what to separate the paste by.  The
# default is sep=" ".
letters[1:10]
paste(letters[1:10], collapse="+")
paste(letters[1:10], 1:10, sep="&")

# Exercise:  using the paste() command, write-out a command that will print out
# a message like this one, but by assigning values to the variables below:
# "Hello, my name is Albert Kim.  My birthday is November 5, 1980"
day
month
year
last.name
first.name





#-------------------------------------------------------------------------------
# A list of other base R string commands
#-------------------------------------------------------------------------------
# as.character() converts objects into strings
as.character(76)

# The following play with upper case and lower case
tolower("HeLLO worlD")
toupper("HeLLO worlD")

# nchar() counts characters
nchar("HeLLO worlD")

# abbreviate() using some sort of algorithm:  remove vowels, and include just
# enough consonants to be able to distinguish values?  I'm not sure of the exact
# procedure.  The only thing that matters is that you for each original word you
# get a unique abbreviation
colors()
colors() %>% abbreviate()

# gsub for character substitution
text <- "I love to play apples to apples while eating apples. How do you like dem apples?"
gsub(pattern = "apple", replacement="orange", x=text)





#-------------------------------------------------------------------------------
# The stringr Package.  Behold it's glory
#-------------------------------------------------------------------------------
# Useful basic manipulations:
str_c()             # string concatenation. same as paste()
str_length()        # number of characters. same as nchar()
str_sub()           # extracts substrings
str_trim()          # removes leading and trailing whitespace
str_pad()           # pads a string
str_to_title()      # convert string to title casing
str_count()         # count number of matches in a string
str_sort()          # sort a character vector

# Less useful basic manipulations
str_wrap()          # wraps a string paragraph
str_dup()           # duplicates characters

# Advanced string find, extract, replace, etc.
str_detect()        # Detect the presence or absence of a pattern in a string
str_extract()       # Extract first piece of a string that matches a pattern
str_extract_all()   # Extract all pieces of a string that match a pattern
str_match()         # Extract first matched group from a string
str_match_all()     # Extract all matched groups from a string
str_locate()        # Locate the position of the first occurence of a pattern in a string
str_locate_all()    # Locate the position of all occurences of a pattern in a string
str_replace()       # Replace first occurrence of a matched pattern in a string
str_replace_all()   # Replace all occurrences of a matched pattern in a string
str_split()         # Split up a string into a variable number of pieces
str_split_fixed()   # Split up a string into a fixed number of pieces


# These ALL have great help file examples.  Type ?str_ in the console and press
# TAB to see all the functions that are available to you!

# Let's go over the ones that are not self-evident.

# Extract substrings:
hw <- "Hadley Wickham"
str_sub(hw, 1, 6)
str_sub(hw, 1, nchar(hw))
str_sub(hw, c(1, 8), c(6, 14))

# Padding strings.  Especially useful for padding with 0's
nums <- c(1:15)
as.character(nums)
str_pad(nums, 2, pad ="0")
str_pad(nums, 3, pad ="0")

# HUGE one: detecting strings
text <- "Hello, my name is Simon and I like to do drawings."
str_detect(string=text, pattern="Simon")

text <- c("Simon", "Radhika", "Hyo-Kyung")
str_detect(string=text, pattern="Simon")

# Extracting strings.  Notice the difference.  The latter returns a "list" and
# not a vector
text <-c("Simon", "My name is Simon.  Simon Favreau-Lessard", "Hyo-Kyung")
str_extract(string=text, pattern="Simon")
str_extract_all(string=text, pattern="Simon")

# Matching strings:
strings <- c(" 219 733 8965", "329-293-8753 ", "banana", "595 794 7569",
             "387 287 6718", "apple", "233.398.9187  ", "482 952 3315",
             "239 923 8115 and 842 566 4692", "Work: 579-499-7527", "$1000",
             "Home: 543.355.3679")
str_match(string=strings, pattern="233")
str_match(string=strings, pattern="Work")

# Locate the exact position of a string:  input is a single element
fruit <- "It's time to go bananas for bananas."
str_locate(string=fruit, pattern="na")
str_locate_all(string=fruit, pattern="na")
str_locate(string=fruit, pattern="time to go ba")
str_sub(string=fruit, start=6, end=18)

# Locate the exact position of a string:  input is a vector
fruit <- c("apple", "banana", "pear", "pineapple")
str_locate(string=fruit, pattern="na")
output <- str_locate_all(string=fruit, pattern="na")
output
output[[2]]

# String replacing.  Same as gsub() earlier
text <- "I love to play apples to apples while eating apples. How do you like dem apples?"
gsub(pattern = "apple", replacement="orange", x=text)
# Note the difference
str_replace(string=text, pattern = "apple", replacement = "orange")
str_replace_all(string=text, pattern = "apple", replacement = "orange")

# The piece de resistance
fruits <- "apples and oranges and pears and bananas"
str_split(string=fruits, pattern=" and ")

fruits <- c(
  "apples and oranges and pears and bananas",
  "pineapples and mangos and guavas"
)
str_split(string=fruits, pattern=" and ")

# Why is this one so big?  Because it allows us to split up text into words!
some_tweets <- searchTwitter("NHL", n=1, lang="en")
some_tweets <- sapply(some_tweets, function(x){x$text})
some_tweets
str_split(string=some_tweets, pattern=" ")


old.man.and.the.sea <-
  readLines("old_man_and_the_sea.txt", encoding="UTF-8") %>%
  paste(collapse=" ") %>%
  str_split(pattern=" ") %>%
  table() %>%
  sort(decreasing=TRUE) %>%
  .[1:200]