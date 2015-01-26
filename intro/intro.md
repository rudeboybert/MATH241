MATH 241 Case Studies in Statistical Analysis
========================================================
author: Albert Y. Kim
date: Monday 2015/01/26



Misnomer
========================================================
When I came up with the name for this class "MATH 241 Case Studies in Statistical Analysis" last year, I was still skeptical of the term "Data Science" as I felt it too buzzwordy.

I've since changed my stance. This class should be in fact "MATH 241 Introductory Data Science"



What is Data Science?
========================================================
From a [presentation](http://bulletin.imstat.org/2014/10/ims-presidential-address-let-us-own-data-science/) by former Institute of Mathematical Statistics president Bin Yu:

![alt text](data_science_1.png)



What is Data Science?
========================================================
Venn Diagram 2.0:

![alt text](data_science_2.png)



Typical Statistical Analyses
========================================================
From the introduction to the [OpenIntro Statistics](https://www.openintro.org/stat/textbook.php) textbook from MATH 141:

1. Formulate a scientific question
2. Collect data
3. Clean and manipulate data
4. Analyze data
5. Form conclusions & communicate them

In MATH 141, we tended to focus more on 4 and 5.



Goals for This Class
========================================================

* Follow the complete statistical analysis cycle
* Real data: more interesting, not clean, violating statistical assumptions
* Data visualization: not just infographics, but as an analytical tool
* Use computational tools: R coding, R packages, scraping data from the web, building web apps
* Apply statistical methodologies: regression, correlated data, spatial statistics, text mining, machine learning, etc.



Building Our Data Toolbox
========================================================
For the first few lectures, we will work on developing our data toolbox.  These tools are absolutely necessary before we can pursue any kind of meaningful analysis. Specifically

* Tools for **visualizing data**:  the `ggplot2` package
* Tools for **manipulating/transforming** your data:  the `dplyr` package

The beauty of these two R packages is there is a deep philosophy underlying how to use them.



RStudio
========================================================
RStudio is an integrated development environment that acts as a user interface for R.

![alt text](RStudio.png)



Useful RStudio Keyboard Shortcuts
========================================================

1. **Tab**:  complete command and variable names
2. (From console) **Up**:  scroll thru previous commands
3. (From editor) **CMD+Enter** or **Control+Enter**:  execute in console either current line or highlighted code

To see them all, press `alt+shift+k`.
