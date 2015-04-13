library(dplyr)
library(stringr)

# Note the solutions to all exercises are at the end of the file.

# Introducing the tm = "text mining" package:  it has various tools for advanced
# text processing (beyond simple string manipulation).  The outputs of tm
# functions are used in other packages, including the wordcloud package.

# Install the following new packages:
library(tm)
library(wordcloud)



#-------------------------------------------------------------------------------
# Character Encodings
#-------------------------------------------------------------------------------
# Working with text data can be a real PITA, as there are many different
# "character encodings", i.e. how characters are represented on a computer:
# http://www.iana.org/assignments/character-sets/character-sets.xhtml
# Converting between them can be a real nuissance as some characters don't
# translate well, like accented letters, spaces, punctuation.

# Let try to avoid some of these issues the best we can for now and revisit "The
# Old Man and the Sea" from Project Gutenberg:
# -Go to: http://www.gutenberg.ca/ebooks/hemingwaye-oldmanandthesea/hemingwaye-oldmanandthesea-00-t.txt
# -Copy all:  COMMAND-A and then COMMAND-C on Macs (CTRL on windows)
# -In RStudio -> Menu Bar -> File -> New File -> Text File, and paste the contents
# -Remove the introduction and conclusion fluff
# -Ensure the last line is a blank line (to avoid the 'incomplete final line'
#  error message)
# -Menu Bar -> File -> Save with Encoding..., select UTF-8.

# We use the readLines() function to read the lines while specifying the
# encoding.  Furthermore, to be absolutely paranoid safe, we convert the
# resulting vector into a character vector using the as.character() function.
old.man <-
  readLines("old_man_and_the_sea.txt", encoding="UTF-8") %>%
  as.character()



#-------------------------------------------------------------------------------
# tm Package
#-------------------------------------------------------------------------------
# The tm package is very versatile;  the functions we focus on are (with very
# self-evident names):
removeNumbers("A-B-C, 1-2-3, Baby you and me!")
removePunctuation("H./&e#@!llo Worl------><><><d!")
removeWords("Hello World", "World")
stripWhitespace("   lots    of  superfluous      whitespace ")

# Also built in are "stopwords": http://en.wikipedia.org/wiki/Stop_words, words
# like articles, but not verbs/nouns/adjective/adverbs.  Note: depending on the
# situation, you may or may not want to remove these words
stopwords("english")
stopwords("french")
stopwords("spanish")
stopwords("hungarian")

# Example:
string <- "Why is the 'the' in 'the apple' and 'the car' pronouced different? Because one starts with a vowel, and the other starts with a consonant!"
string
removeWords(string, stopwords("english"))


# Also, many words speak to the same concept, especially plurals.  Note:  this
# is kind of black-box'ish to me:  i.e. I don't really know how it works. It's
# based on the Porter algorithm:  http://tartarus.org/martin/PorterStemmer/
stemDocument(c("constitutions", "constitutional", "constitution"))



#-------------------------------------------------------------------------------
# Back to the old man and the sea
#-------------------------------------------------------------------------------
# Before:
old.man

old.man <- old.man %>%
  tolower() %>%
  removeNumbers() %>%
  removePunctuation() %>%
  removeWords(stopwords("english")) %>%
  stemDocument() %>%
  stripWhitespace()

# After
old.man

# Same as last time:
# -Split the entire vector using spaces i.e. cut it up into words
# -str_split() returns a list, and not a vector of words.  Convert this to a vector
#  using the unlist() function
# -Compute the frequency table() of the words
# -sort() the vector in decreasing order
# -Look at the first 20 elements of the sorted vector of frequencies
top.20 <- str_split(old.man, pattern= " ") %>%
  unlist() %>%
  table() %>%
  sort(decreasing=TRUE) %>%
  .[1:20]
top.20

# If you want to have a vector of the words, and not the counts, get the names()
# of the elements of the vector
top.20 %>% names()


#-------------------------------------------------------------------------------
# Wordcloud
#-------------------------------------------------------------------------------
# In order to make a wordcloud, we need to first convert the vector into a
# "corpus" object:
old.man <- VectorSource(old.man) %>% Corpus()
wordcloud(old.man, scale=c(5,0.5), max.words=25, random.order=FALSE,
          rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "BuPu"))

# Check out the help file for the wordcloud() function to see what all these
# parameters do
?wordcloud



#-------------------------------------------------------------------------------
# Note on colors
#-------------------------------------------------------------------------------
# To see all the possible color palette options in R, run the following code
# after installing the RColorBrewer package:
library(RColorBrewer)
par(mar = c(0, 4, 0, 0))
display.brewer.all()
par(mar = c(0, 0, 0, 0))

# The first cluster are "sequential" palettes i.e. indicate highs and lows
# The next are qualitative i.e. they don't convey any real order
# The last are diverging i.e. they diverge from some middle point

# In this case, sequential is appropriate since we want to convey highs and
# lows, but there is no divergence point

# The following commands generate the HEX codes representing colors on the
# color wheel:  http://simple.wikipedia.org/wiki/Color_wheel
brewer.pal(8, "Purples")
brewer.pal(8, "Set3")



#-------------------------------------------------------------------------------
# Back to OkCupid Data
#-------------------------------------------------------------------------------
# Set your working directories to the location of the OkCupid data
profiles <- read.csv(file="profiles.csv", header=TRUE, stringsAsFactors=FALSE) %>%
  tbl_df()

# Following code
# -selects the essays
# -creates a new variable "all.essays" consisting of all 10 essay responses
#  pasted together
# -selects only sex and the all.essays variable
essays <-
  select(profiles, sex, starts_with("essay")) %>%
  mutate(
    all.essays = paste(essay0, essay1, essay2, essay3, essay4, essay5, essay6, essay7, essay8, essay9, sep=" ")
    ) %>%
  select(sex, all.essays) %>%
  tbl_df()

# EXERCISE1:  There are a lot of HTML tags in the essay responses that junk up
# reading the responses.  Using the stringr package, replace all instances of
# "\n" (return i.e. blank line) and "<br />" (paragraph breaks) with a " "
# character.



# EXERCISE2:  Get the top 500 words used by men, sorted in decreasing order, and
# save the words (not the counts) in a vector called "male.words".  Do the same
# for females.  Do not correct for punctuation, or numbers, or whitespace.
# Comment on the first 25 for each case.
# Hint:  to extract a column from a dplyr data frame and have it be a vector,
# use DATA_FRAME_NAME[["COLUMN_NAME"]].  For example: essays[["sex"]]



# EXERCISE3:  using the setdiff() command, pick out the following:
# -Of the top 500 words used by males, those NOT in the top 500 words used by
#  females.
# -Of the top 500 words used by females, those NOT in the top 500 words used by
#  males.

# setdiff(x, y) says:  return all the elements in the vector x, that are not in
# the vector y.  Try this on for size:
x <- c(1, 3, 5, 7, 8)
y <- c(1, 2, 3, 4, 6, 7)
setdiff(x, y)

# Other set operations include intersect(), union(), setequal().



# OPTIONAL: Make a wordcloud for this two results









# SOLUTION1:
essays <- essays %>%
  mutate(
    all.essays = str_replace_all(all.essays, "\n", " "),
    all.essays = str_replace_all(all.essays, "<br />", " ")
  )










# SOLUTION2:
male.words <- subset(essays, sex == "m") %>%
  .[["all.essays"]] %>%
  str_split(" ") %>%
  unlist() %>%
  table() %>%
  sort(decreasing=TRUE) %>%
  .[1:500] %>%
  names()

female.words <- subset(essays, sex == "f") %>%
  .[["all.essays"]] %>%
  str_split(" ") %>%
  unlist() %>%
  table() %>%
  sort(decreasing=TRUE) %>%
  .[1:500] %>%
  names()










# SOLUTION3:
# Words in the males top 500 that weren't in the females' top 500:
setdiff(male.words, female.words)
# Words in the male top 500 that weren't in the females' top 500:
setdiff(female.words, male.words)