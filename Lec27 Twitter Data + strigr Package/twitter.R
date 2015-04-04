library(twitteR)
library(stringr)

setup_twitter_oauth("Z81sQ1bW8LC4g3u0G4VbdHgAr", "ZPf9UKzEDmMQxXP9MZPdsd5oEQBNavQEfSmx63YqIhPinp9iWQ", "55667378-QPqom3aXZZ2PIMpEX6Hr8yEwslrUmVE2lxG0UdK8y", "DA6B1ut6lrd6UCsn1QP75fvc5vQcQ1W5H87gD7waJpaSB")

# Select yes.


some_tweets <- searchTwitter("indiana", n=100, lang="en")
some_tweets

# Check out help file:
?searchTwitter

some_tweets <- searchTwitter("indiana", n=100, lang="en", geocode='37.781157,-122.39720,1mi')

some_tweets

# Press tab after the dollar sign, and scroll to the bottom.
some_tweets[[1]]$

# Example: Now a vector of text elements
sapply(some_tweets,
       function(x){
         x$text
       })
sapply(some_tweets,
       function(x){
         x$screenName
       })


# stringr vignette doesn't officially exist, only in development mode as
# of 2015/04/03
browseVignettes()
