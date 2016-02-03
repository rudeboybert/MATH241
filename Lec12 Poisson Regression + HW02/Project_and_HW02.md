Term Project + Homework 02
========================================================
author: Albert Y. Kim
date: Friday 2015/02/20







Project Logistics
========================================================

* Proposal due on Friday March 20th.
* During exam week: 20 minute presentation of your work.  There will be 4 sessions where in groups of 5 you will present to each other and me.
* Write-up will be due on Monday of that week.




Principles
========================================================

* Guiding principle:  **Use the materials learned in this class.**  Ex:  a two-sample t-test is not enough:
    + Data visualization
    + Data manipulation (not for its own sake)
    + Topics to be covered for sure later:  time series, spatial statistics, text mining, and machine learning




Principles
========================================================

* Grading rubric for homeworks applies
* Reproducible research:  start with rawest possible data file, set code up so that any one can reproduce the entire analysis with one click of the mouse.




Data
========================================================

* Has to involve REAL data
* Pick a topic you're interested in (politics, sports, science, etc) and find an interesting question.  The more interested you are in an answer, the less it will seem like work!




Data
========================================================

* Seniors:  you **can** use thesis data.  However I require that
    + Your advisors email me and consent to you using your data for both your thesis and this class.
    + Your data processing and analysis be done in R.
* If you're looking for ideas, come talk to me.





Homework 02: Question 1
========================================================
Question 4 on page 76 from Chapter 4 of Data Analysis Using Regression and Multilevel/Hierarchical Models.  The codebook can be found [here](http://www.stat.columbia.edu/~gelman/arm/examples/pollution/pollution.txt).




Homework 02: Question 2
========================================================
Using the OkCupid data, fit what you think is a good predictive model for gender and interpret all results.




Homework 02: Question 2
========================================================
What do I mean by "good predictions"?  Recall that the dataset from class is a  **sample** of profiles.  In fact, I gave you 10% of all profiles.  I define "bad" as the following:  the proportion of people misclassified (both possible ways)  using the **other** 90% of profiles.

Think about what happens when your prediction mechanism is overly optimized for your particular dataset.  What will happen when it tries to predict other datasets?





Homework 02: Question 3
========================================================
Data consists cancer counts of the National Cancer Institute's "Surveillance, Epidemiology, and End Results Program" (SEER) database of cancers

* For the $n=887$ census tracts in the 13 counties in Western Washington:  Clallam, Grays Harbor, Island, Jefferson, King, Kitsap, Mason, Pierce, San Juan, Skagit, Snohomish, Thurston, and Whatcom.
* Stratified by different demographic categories:  age, sex, and race
* For the years 1996 through 2005



Homework 02: Question 3
========================================================
Unprocessed data file as provided by SEER (please do not share).  Marked as `txt` file, but actually is CSV file:


```r
library(dplyr)
SEER <- read.csv("Space Time Surveillance Counts 11_05_09.txt", header=TRUE) %>% tbl_df()
SEER
```




Homework 02: Question 3
========================================================
Let

* $y_i$ for $i=1, \ldots, n$ be counts of a particular cancer summed over all years (1996-2005) and over all demographic categories.
* Predictor variables $X_i$ be relevant demographic factors like age, race, gender, plus socio-economic status and any other relevant variables from the **2000** census.




Homework 02: Question 3
========================================================
Keep a tone of where you would be sharing your findings with state public health officials:

* Perform exploratory data analyses:  basic summaries, relevant maps (more on mapping making on Monday)
* Conduct appropriate regressions along with **interpretations**

Do this for breast and lung cancer separately.



Obtaining Predictor Variables
========================================================
Go to [Social Explorer](http://www.socialexplorer.com/) while at Reed or using a proxy.

* Click on "Start Now" -> 3-Bar button on top right
* Zoom into WA by entering "Washington" in top left bar
* Select
    + "Census Tract" level of refinement
    + 1. Census 2000 survey
    + 2. Any particular topic
    + 3. Census tracts using "Circle" tool
* Click "Create Report" -> "Data Download" and download "Census Tract data (CSV)" & "Data dictionary (text file)"




Identifying Census Tracts
========================================================
States, counties, census tracts, and census blocks can be identified using "Federal Information Processing Standard" (FIPS) codes.

![alt text](FIPS.png)

These codes are **crucial** for matching up different data sets.  For example, "Nez Perce County Idaho" might be coded as: "Nez Perce", "Nez_Perce", "NezPerce", etc.  Whereas the FIPS code is just 16069.



