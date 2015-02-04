Wrapping Up dplyr
========================================================
author: Albert Y. Kim
date: Wednesday 2015/02/04





Notes from Last Time
========================================================
`%<>%` is a combination of `->` and `%>%` from the `magrittr` package.  Ex. the following are the same:


```r
mtcars <- filter(mtcars, gear >3)
mtcars %<>% filter(gear > 3)
```



Discussion about Article
========================================================





Combining Data Sets via Join Operations
========================================================
Imagine we have two data frames **`x**   and  **y`**:


```
  x1 x2
1  A  1
2  B  2
3  C  3
```

```
  x1    x3
1  A  TRUE
2  B FALSE
3  D  TRUE
```

We want to **join** them along the `x1` variable and end up with a new data frame that has all three variables.



Combining Data Sets via Join Operations
========================================================

* `dplyr`'s operations to join data sets are inspired by SQL (Structured Query Language), which used to query large databases.
* If values are missing during the join, `NA`'s are inserted.
* This [illustration](https://twitter.com/yutannihilation/status/551572539697143808) succinctly summarizes all of them.



R Markdown
========================================================

Everybody please ensure that Step 9 in the [instructions about LaTeX](http://reed.edu/data-at-reed/software/R/r_studio.html) work.  If this doesn't work, please see Rich in his office hours tomorrow or me at some point before class.

Homework 01 will be assigned on Friday.
