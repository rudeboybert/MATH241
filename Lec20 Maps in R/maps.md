Working With Maps
========================================================
author: Albert Y. Kim
date: Wednesday 2015/03/11





GIS
========================================================
Geographical information system (GIS) is a system designed to capture, store, manipulate, analyze, manage, and present all types of spatial or geographical data.

Typical GIS software include ArcGIS and ArcMap.




GIS
========================================================
At its simplest, geographic elements are

* Points: landmarks
* Lines: roads, coarse representation of a river
* Polygons: geographic areas, lots, etc.


Shapefiles
========================================================
The **shapefile** format is a popular geospatial vector data format for geographic information system (GIS) software. It is developed and regulated by Esri as a (mostly) open specification for data interoperability among Esri and other GIS software products.



Spatial Polygons
========================================================

We're going to import shapefiles into R and convert them into **SpatialPolygons** (sp) objects.  At its simplest, an sp object consists of:

* A plotting order
* A bounding box of the the geographic extent in question
* A coordinate system (latitude/longitude, UTM, NAD) to project a 3D globe onto a 2D page.
* A list of polygons
* Any relevant data to each geographic object

The last three are the most relevant to you.


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
