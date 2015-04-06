library(twitteR)
library(stringr)

# Copy over your info from the Twitter developer page and run this command.
# Select 2 at the prompt.
setup_twitter_oauth("API key", "API secret", "Access token", "Access token secret")

# The tragedy in Kenya has been in the news of late.
some_tweets <- searchTwitter("kenya", n=100, lang="en")

# The function returns a "list", not a vector, with 100 tweets.  You access them
# individually using [[]] and not [] like with vectors
some_tweets
some_tweets[[1]]

# As well as Indiana has been in the news of late.
some_tweets <- searchTwitter("indiana", n=100, lang="en")
some_tweets

# Check out help file:
?searchTwitter

# We can pull out geo-coded tweets within a certain distance of a long/lat point
some_tweets <- searchTwitter("indiana", n=100, lang="en", geocode='37.781157,-122.39720,100mi')
some_tweets

# Press tab after the dollar sign to what info is stored for each list element.
some_tweets[[1]]$

# For example, the following lines extract the text and the author
some_tweets[[1]]$text
some_tweets[[1]]$screenName

# If we want to extract the text for each tweet, i.e. each list element, we use
# the sapply() command.  i.e. it applies the function we define to each element
# of the list.
tweets.vector <- sapply(some_tweets, function(x){x$text})
tweets.vector[1]