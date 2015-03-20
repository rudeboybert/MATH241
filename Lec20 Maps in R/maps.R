library(dplyr)
library(ggplot2)
library(maptools)
library(ggmap)
gpclibPermit()



#-------------------------------------------------------------------------------
# 2010 Portland Census Tract Data
#-------------------------------------------------------------------------------
# Download 2010 Census Tract from http://rlisdiscovery.oregonmetro.gov/

# Convert shapefile into "Spatial Polygons" AKA "sp" object
PDX <- readShapeSpatial("tract2010")

# Plot the map use native R plot command (i.e. not the ggplot package).  Note
# that the geographical coordinate system is NOT latitude and longitude
plot(PDX, axes=TRUE)

# Restrict to Multnomah County.  Unfortunately, the filter() command from dplyr
# doesn't work on sp objects, so we use subset()
PDX <- subset(PDX, COUNTY=="051")
plot(PDX, axes=TRUE)

# Many shapefiles come with data attached to each geographic object.  In this
# case we have census data for each census tract.  Looking at PDX.data, each
# region's unique identifier is, unsurprisingly, the FIPS code.  For some weird
# reason you access the data in sp objects using "@" and not "$".
PDX.data <- PDX@data %>% tbl_df()
View(PDX.data)




#-------------------------------------------------------------------------------
# Convert sp object to ggplot'able object
#-------------------------------------------------------------------------------
# We have to use the fortify() command to convert the sp object to a ggplot'able
# data frame where regions are ID'ed using the unique identifier discussed
# above.  The group variable associates (x,y) to distinct polygons, also
# allowing the possibility that multiple polygons are in the same region.  Ex: a
# census tract with islands.
PDX.map <- fortify(PDX, region="FIPS") %>% tbl_df()
PDX.map


# Look very carefully at this ggplot call:
# -the group aesthetic ensures census tracts (i.e. polygons) are kept and
#  plotted together
# -the polygons will be filled with darkorange
# -geom_path traces out the outline of each census tract in black
#  of longitude and latitude make sense
ggplot(data=PDX.map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="darkorange") +
  geom_path(color="black", size=0.5) +
  xlab("longitude") + ylab("latitude")




#-------------------------------------------------------------------------------
# Subimpose a background map
#-------------------------------------------------------------------------------
# Using the get_map() function from the ggmap package, we can download Google
# map images
google.map <-
  get_map(location = "Portland, OR", maptype = "roadmap", zoom = 11, color = "color")

# Plot it
p <- ggmap(google.map) + xlab("longitude") + ylab("latitude")
p

# Unfortunately we can't superimpose our ggplot object over this Google map b/c
# the coordinate system is not in longitude/latitude.  The function to switch
# coordinate systems will come from a package in an R package to be installed
# (hopefully) later.




#-------------------------------------------------------------------------------
# Map of Proportion Hispanic for Each Census Tract
#-------------------------------------------------------------------------------
# Define a numerical variable of the proportion hispanic in each census tract.
PDX.data <- mutate(PDX.data, prop.hisp = HISPANIC/POP10)

# Define the same variable, but now in a categorial fashion.  We "cut" the
# values according to the quantiles.  Try this on for size:
quantile(PDX.data$prop.hisp)
cut(PDX.data$prop.hisp, quantile(PDX.data$prop.hisp))
cut(PDX.data$prop.hisp, quantile(PDX.data$prop.hisp), dig.lab=2)
cut(PDX.data$prop.hisp, quantile(PDX.data$prop.hisp), dig.lab=2, include.lowest=TRUE)

PDX.data <-
  mutate(PDX.data,
         prop.hisp.bracket = cut(prop.hisp, quantile(prop.hisp), dig.lab=2, include.lowest=TRUE)
                     )

# Fortify PDX data and join with new PDX.data data frame which contains our
# proportion hispanic variables
PDX.map <- fortify(PDX, region="FIPS") %>%
  left_join(PDX.data, by=c("id"="FIPS"))

# Plot the numerical proportion:  note the scale_fill_continuous
ggplot(data=PDX.map, aes(x=long, y=lat, group=group, fill=prop.hisp)) +
  geom_polygon() +
  geom_path(color="black", size=0.5) +
  xlab("longitude") + ylab("latitude") +
  scale_fill_continuous(low="white", high="black", name="Prop. Hispanic")

# Plot the categorical proportion:  note the scale_fill_brewer
ggplot(data=PDX.map, aes(x=long, y=lat, group=group, fill=prop.hisp.bracket)) +
  geom_polygon() +
  geom_path(color="black", size=0.5) +
  xlab("longitude") + ylab("latitude") +
  scale_fill_brewer(palette = 'Greys', name="Prop. Hispanic")




#-------------------------------------------------------------------------------
# Exercise:  Recycling the code above, plot a map of the population of Western
# Washington by census tract.
#-------------------------------------------------------------------------------











