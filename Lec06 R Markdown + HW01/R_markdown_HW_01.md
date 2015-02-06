Putting It All Together: Homework 01
========================================================
author: Albert Y. Kim
date: Friday 2015/02/06






Questions
========================================================

Last time someone asked how to reorder the bars on the barplot.  We do that by setting the `state` variable as a factor, i.e. a categorical variable, and then setting its order via its `levels`.

Unfortunately the solution is a bit of a hack.  See lines 106-120 of `HW01.R` for an example.



A few other commands
========================================================
Load `dplyr`:

* `count()`.  Ex:
    + `count(mtcars, cyl)`
    + `count(mtcars, cyl, vs)`
* `summarise(n())`.  Ex:
    + `group_by(mtcars, cyl) %>% summarise(count = n())`
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



Question 1
========================================================

* Plot a "time series" of the number of flights that were delayed by > 30 minutes on each day.  i.e.
    + the x-axis should be some notion of time
    + the y-axis should be the count.
* Which seasons did we tend to see the most and least delays of > 30 minutes.



Question 2
========================================================

I actually prefer flying on older planes.  Even though they aren't as nice, they tend to have more room.  Which airlines should I favor?



Question 3
========================================================

* What states did listed Southwest Airlines flights tend to fly to?
* What states did all Southwest Airlines flights tend to fly to?



Question 4
========================================================

What weather patterns are associated with the biggest departure delays?




Question 5
========================================================

I want to know proportionately what regions (NE, south, west, midwest) each carrier flies to from Houston in the month of July.  Consider the `lubridate` package.



Question 6
========================================================

Get creative:  Answer one question of your own using this data.  The more interesting the question the better.




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

* For those of you with no programming experience: if you're spinning your wheels for a long while, TAKE A BREAK.  If really stuck, get help from your peers, me, or Rich.
* There are no "right" answers.  Just think of the goal:  you want to convey the most information so that consumers need to use the least cerebral power to understand it.
* [Grading Rubric](http://stat545-ubc.github.io/peer-review01_marking-rubric.html)





R Markdown
========================================================

* Use `HW01.Rmd` template for submitting your homework.
* Submit a working `.Rmd` file by Wednesday Feb. 18th at 1pm.  We will discuss the HW in lecture that day.
* Please check out the R Markdown debugging sheet at the top of the Moodle page.



