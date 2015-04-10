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
# More Advanced
#-------------------------------------------------------------------------------
str c() string concatenation paste()
str length() number of characters nchar()
str sub() extracts substrings substring()
str dup() duplicates characters none
str trim() removes leading and trailing whitespace none
str pad() pads a string none
str wrap() wraps a string paragraph strwrap()
str trim() trims a string none
str detect() Detect the presence or absence of a pattern in a string
str extract() Extract first piece of a string that matches a pattern
str extract all() Extract all pieces of a string that match a pattern
str match() Extract first matched group from a string
str match all() Extract all matched groups from a string
str locate() Locate the position of the first occurence of a pattern in a string
str locate all() Locate the position of all occurences of a pattern in a string
str replace() Replace first occurrence of a matched pattern in a string
str replace all() Replace all occurrences of a matched pattern in a string
str split() Split up a string into a variable number of pieces
str split fixed() Split up a string into a fixed number of pieces







#-------------------------------------------------------------------------------
# For fuller details check out: http://gastonsanchez.com/Handling_and_Processing_Strings_in_R.pdf
#-------------------------------------------------------------------------------