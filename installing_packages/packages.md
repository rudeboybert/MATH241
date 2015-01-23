R Packages
========================================================
author: Albert Y. Kim
date:



Best Reason to Use R (Besides Cost = $0)
========================================================
IMO the best


Installing Packages
========================================================
There are many ways to install packages

* Directly from a "zipped" file
* From CRAN over the internet
* From [GitHub](https://github.com/)


Installing Packages from GitHub
========================================================
We're going to be using the [`rvest`](https://github.com/hadley/rvest) package to scrape information from webpages, which is being developped in a GitHub repository by Hadley Wickham (`hadley`)

In order to install packages from GitHub, we need to install the `devtools` package:  follow these [instructions](https://github.com/hadley/devtools#updating-to-the-latest-version-of-devtools).

Now install the `rvest` package

```r
devtools::install_github("hadley/rvest")
```



Web Scraping via the rvest Package
========================================================
Here is a list of [NHL Stanley Cup champions since 1927](http://en.wikipedia.org/wiki/List_of_Stanley_Cup_champions).



```r
library(rvest)
webpage <- html("http://en.wikipedia.org/wiki/List_of_Stanley_Cup_champions")
wp_data <- webpage %>%
  html_nodes("table") %>%
  .[[3]] %>% html_table() %>% tbl_df()
```





Web Scraping via the rvest Package
========================================================


