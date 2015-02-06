Putting It All Together: Homework 01
========================================================
author: Albert Y. Kim
date: Friday 2015/02/06






Questions
========================================================

Last time someone asked how to reorder the bars on the barplot.  We do that by setting the `state` variable as a factor, i.e. a categorical variable, and then setting its order via its `levels`.

See lines 106-120.



A few other commands
========================================================

* `count()`.  Ex:
    + `count(diamonds, color)`
    + `count(diamonds, color, clarity)`
* `summarise(n())`.  Ex:
    + `group_by(diamonds, color) %>% summarise(n())`
* How to deal with missing data
    + `mean(c(1, 2, NA))` gives `NA`
    + but `mean(c(1, 2, NA), na.rm=TRUE)` gives 1.5.



Flights data
========================================================

* `flights` [227,496 x 14]. Every domestic flight departing Houston in 2011.
* `weather` [8,723 x 14]. Hourly weather data.
* `planes` [2,853 x 9]. Plane metadata.
* `airports` [3,376 x 7]. Airport metadata.

Source: RStudio.



Questions for Homework
========================================================

* Plot a "time series" of the number of flights that were delayed by more than 30 minutes on each day.  i.e.
    + the x-axis should be some notion of time
    + the y-axis should be the proportion.
* Which seasons did we tend to see the most and least delays of > 30 minutes.
* I actually prefer flying on older planes.  Even though they aren't as nice, they tend to have more room.  Which airlines should I favor?
* What states did Southwest Airlines flights tend to fly to from Houston?



Questions for Homework
========================================================

* What weather patterns are associated with the biggest departure delays?
* I want to know what regions (NE, south, west, midwest) each carrier flies to from Houston.
* Get creative:  Answer one question of your own using this data based on your feelings on flying.  The more interesting the question the better.



Strategy
========================================================

* Get familiar with all the variables in all four datasets.
* BEFORE you do any coding, sketch out all the necessary data wrangling steps in terms of the **grammar of data manipulation**
    + I want to do X, then
    + I want to do Y, then
    + ...
* Once you have the appropriate **tidy** data frame sketch out what you want your graphic to look like and build it using the **grammar of graphics**




Strategy
========================================================

* For those of you with no programming experience: if you're spinning your wheels, TAKE A BREAK.  If really stuck, get help from your peers, me, or Rich.
* There are no "right" answers.  Just think of the goal:  you want to convey the most information so that consumers need to use the least cerebral power to understand it.
* [Grading Rubric](http://stat545-ubc.github.io/peer-review01_marking-rubric.html)



R Markdown
========================================================




