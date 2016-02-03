ggplot2 Continued
========================================================
author: Albert Y. Kim
date: Wednesday 2015/01/28





Review Exercise from Last Time
========================================================

* Go to top menu bar of RStudio -> File -> New File -> R Script
* Click on "Lec02 Exercise" in Moodle
* Copy contents and paste into R Script



Last Time: Basic Components
========================================================

* **`aes`** mappings of data variables to aesthetics we can perceive on a graphic
* **`geom`** geometric objects
* **`stat`** statistical transformations to summarise data
* **`facet`** how to break up plots into subsets
* **`coord`** coordinate system for x/y values: typically cartesian (can be polar)
* **`scale`** both convert **data units** to **physical units** the computer can display AND draw a legend/axes.
* **Extras** titles, axes labels, themes



Further Reading Ressources
========================================================
* Help files.  Ex `?geom_line()`
* Online help files: [http://docs.ggplot2.org/current/](http://docs.ggplot2.org/current/)
* [Ultimate Tech Support](http://xkcd.com/627/)

* ggplot2 book is on Moodle.  To learn more, I suggest reading
    + Chapter 1,
    + Chapter 3, but it will be hard to grasp the first time
    + Chapter 4
    + Revisit Chapter 3. Chapters  5-10 go into specific details.
* The code for all examples in the book: [http://ggplot2.org/book/](http://ggplot2.org/book/)



Today:  More Components/Concepts
========================================================
* **layers**: mechanism by which additional data elements are added to a plot
* **`position`** adjustments: minor tweeks to the position of elements
* **groups**: splitting data into groups within the same plot (not via facets)



Building a Graphic Layer-by-Layer
========================================================
We build plots by adding **layers**. Each layer consists of:

1. data and aesthetic mappings (the base)
2. geometric object
3. statistical transformation (with default values)
4. position adjustment (with default values)

Without all four elements specified, nothing will plot!

Building a Graphic Layer-by-Layer
========================================================

Notes:

* Make the base as general as possible
* Every `geom` has a default `stat` & `position` value if they aren't specified
* Layer settings override plot defaults
* You can save plots as variables and add to variables, to reduce duplication




Examples for Today
========================================================
In `ggplot_2.R` we have examples of

* setting groups: `Examples of groups`.
* many different types of geoms: `Examples of geoms`.
* `geom_histogram()` and **position adjustments**: [Titanic Survival Data](https://www.youtube.com/watch?v=zisjRgcuL9k)




Today's Question: UC Berkeley Admissions
========================================================

In 1973, the UC Berkeley was sued for bias against women who had applied for admission to graduate schools.  n=4526 applicants:

```
Source: local data frame [4 x 3]
Groups: Admit

     Admit Gender Freq
1 Admitted   Male 1198
2 Admitted Female  557
3 Rejected   Male 1493
4 Rejected Female 1278
```





Today's Question: UC Berkeley Admissions
========================================================

![plot of chunk unnamed-chunk-3](ggplot_2-figure/unnamed-chunk-3-1.png) 



Today's Question: UC Berkeley Admissions
========================================================

![plot of chunk unnamed-chunk-4](ggplot_2-figure/unnamed-chunk-4-1.png) 



Today's Question: UC Berkeley Admissions
========================================================

However, there was another variable researchers could consider: department applied to.


```
Source: local data frame [24 x 4]

      Admit Gender Dept Freq
1  Admitted   Male    A  512
2  Rejected   Male    A  313
3  Admitted Female    A   89
4  Rejected Female    A   19
5  Admitted   Male    B  353
6  Rejected   Male    B  207
7  Admitted Female    B   17
8  Rejected Female    B    8
9  Admitted   Male    C  120
10 Rejected   Male    C  205
..      ...    ...  ...  ...
```



Today's Question: UC Berkeley Admissions
========================================================

Investigate:

1. Construct a statistical graphic showing how male vs female acceptance varied by department.  Bonus:  Using google, make one of the axes reflect percentage of applicants.
2. Construct a statistical graphic showing the "competitiveness" of the department as measured by acceptance rate.

