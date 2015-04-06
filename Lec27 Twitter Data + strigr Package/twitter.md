Mining Twitter Data + Handling Strings
========================================================
author: Albert Y. Kim
date: Monday 2015/04/06


Mining Twitter Data
========================================================
[Beer vs church map](http://www.floatingsheep.org/2012/07/church-or-beer-americans-on-twitter.html)

What is the **most** important thing to keep in mind when observing such maps?



Mining Twitter Data
========================================================

**Strong** selection biases at every step:

* Who signs up to Twitter
* Who tweets at all
* Who tweets about these topics
* Who let's their location be revealed

i.e. the sample is non-random, so it is not representative of the population as a whole, and hence the results of the sample
are **not generalizable** to the US population.



But still...
========================================================

George Box, one of the most famous statisticians said:  **All models are wrong, but some are useful.**

![alt text](http://funeralinnovations.com/img/obits/large/114698_r1opq1msx5r44x0jq.JPG)



Create Twitter OAS Authentication
========================================================

We are getting digital permission to open the Twitter pipeline for our use, just like any other developer.

* Install `twitteR` package from RStudio (homepage is [here](https://github.com/geoffjentry/twitteR))
* Create a Twitter application at the [Twitter developers page](http://dev.twitter.com).
* Make sure to give the app read, write and direct message authority.
* Note the "API key", "API secret", "Access token", and "Access token secret".



Example:
========================================================



```
Error in check_twitter_oauth() : OAuth authentication error:
This most likely means that you have incorrectly called setup_twitter_oauth()'
```
