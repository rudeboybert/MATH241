library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyr)
library(rgdal)



#-------------------------------------------------------------------------------
# Import shapefiles we downloaded in Lec20 Maps in R using the commands we saw
# in Lec23 Spatial Autocorrelation.  Again, the filter() command from dplyr
# doesn't work on shapefile objects, so we use the base R subset() command
# which does the same thing.
#-------------------------------------------------------------------------------
PDX.shapefile <- readOGR(dsn=".", layer="tract2010", verbose=FALSE) %>%
  spTransform(CRS("+proj=longlat +ellps=WGS84")) %>%
  subset(COUNTY=="051")

# Extract data file from shape file
PDX.data <- PDX.shapefile@data %>% tbl_df()
View(PDX.data)

# Convert shapefile to ggplot'able object
PDX.map <- fortify(PDX.shapefile, region="FIPS") %>% tbl_df()

# Define the base plot.
# coord_map() sets the aspect ratio between the x and y axes to be one used by
# maps
ggplot(PDX.map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white") +
  geom_path(col="black", size=0.5) +
  coord_map() +
  theme_bw()



#-------------------------------------------------------------------------------
# Import PDX crime data from CSVs
# Source http://www.civicapps.org/datasets.
# Go to site, create an account and download "Crime Incidents 2012 Data"
# Classification of the crime type is based on the Uniform Crime Reporting (UCR)
# system developed by the FBI and used by law enforcement agencies throughout
# the United States.
#-------------------------------------------------------------------------------
# Before we start, the data's geographic coordinates are not in
# latitude/longtitude, but rather NAD83: http://en.wikipedia.org/wiki/North_American_Datum.
# I'll spare you the geography and R coding background necessary to understand
# the difference and give you a function that has as
# -input:  n x 2 data frame where columns are the NAD coordiates
# -output:  n x 2 date frame where columns are longtitude and latitutde
#
# Alternatively you can use GIS software like ArcMap/ArcGIS or qGIS (open source)
# and convert units there:
# http://www.civicapps.org/news/how-we-do-it-making-shapefiles-more-accessible-open-source-tools
NAD.to.latlong <- function(coords){
  proj <- "+proj=lcc +lat_1=44.33333333333334 +lat_2=46 +lat_0=43.66666666666666 +lon_0=-120.5 +x_0=2500000 +y_0=0 +ellps=GRS80 +units=ft +no_defs"
  coords <-
    as.data.frame(coords) %>%
    SpatialPoints(proj4string=CRS(proj)) %>%
    spTransform(CRS("+proj=longlat +ellps=WGS84")) %>%
    .@coords %>%
    as.data.frame() %>%
    rename(long=X.Coordinate, lat=Y.Coordinate)
  return(coords)
}

# Read in data
crime2012 <- read.csv("crime_incident_data.csv", header=TRUE) %>% tbl_df()
View(crime2012)

# Use unite() from tidyr to combine the date and time columns
crime2012 <-
  crime2012 %>%
  unite("date.time", c(Report.Date, Report.Time), sep="-")

# Use parse_date_time() from lubridate to make the date.time column appropriate
# date/time objects
crime2012$date.time[1:5]
crime2012 <-
  crime2012 %>%
  mutate(date.time = parse_date_time(date.time, "%m %d %Y %H %M %S"))
crime2012$date.time[1:5]

# A certain number of the geocoordinates are missing.
summarise(crime2012, sum(is.na(X.Coordinate)), sum(is.na(Y.Coordinate)))

# Remove these.  We have to be careful about the bias this may entail.  A more
# thorough analysis would see if there is a pattern in which data are missing.
crime2012 <-
  crime2012 %>%
  filter(!is.na(X.Coordinate) & !is.na(Y.Coordinate))

# Get new coordinates in lat/long and merge them into the crime2012 data set
lat.long <-
  select(crime2012, X.Coordinate, Y.Coordinate) %>%
  NAD.to.latlong()

crime2012 <- bind_cols(crime2012, lat.long)
View(crime2012)



#-------------------------------------------------------------------------------
# Plotting Maps
#-------------------------------------------------------------------------------
# We're going to build a plot marking every crime instance in Portland in 2012
# from the base.plot.  We'll build this up step-by-step
base.plot <-
  ggplot(PDX.map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white") +
  geom_path(col="black", size=0.5) +
  coord_map() +
  theme_bw()
base.plot

# Let's attempt to add the crime2012 point using geom_point() but using its own
# data and own aes()
base.plot +
  geom_point(data=crime2012, aes(x=long, y=lat))

# We get an error.  The ggplot() aes() had three elements: x, y, and group,
# where group was used to associate points to the same polygon, in this case
# polygons.
# All subsequent elements we add have to have the same aes() elements. When
# marking points we don't really need a group aesthetic, so we define a bogus
# one
crime2012$group <- 76

base.plot +
  geom_point(data=crime2012, aes(x=long, y=lat, group=group))

# Now it seems there were some data entry errors, as some crimes occurred in the
# middle of the Pacific Ocean.  So we use the scale_x_continous() example on the
# bottom-right of the backside of the ggplot cheatsheet to focus the plot only
# on Portland.
base.plot +
  geom_point(data=crime2012, aes(x=long, y=lat, group=group)) +
  scale_x_continuous(limits = c(-123.0, -122.3)) +
  scale_y_continuous(limits = c(45.4, 45.7))

# Now we have the problem that too many points are plotted on top of each other,
# so its hard to visualize the number of points at many locations.  So we use
# the alpha parameter in geom_point() to "thin" them out.  alpha sets how dark
# each point should be, and rather intelligently, if many points are stacked
# on top of each other, the darker things get.  Toy around with different values
# of alpha between 0 and 1
base.plot +
  geom_point(data=crime2012, aes(x=long, y=lat, group=group), alpha=0.2) +
  scale_x_continuous(limits = c(-123.0, -122.3)) +
  scale_y_continuous(limits = c(45.43, 45.73))


# Finally we add a density plot via geom_density2d().  See the front of the ggplot cheat sheat under
# "Two Variables".  Where is most crime occurring?
base.plot +
  geom_point(data=crime2012, aes(x=long, y=lat, group=group), alpha=0.2) +
  scale_x_continuous(limits = c(-123.0, -122.3)) +
  scale_y_continuous(limits = c(45.43, 45.73)) +
  geom_density2d(data=crime2012, aes(x=long, y=lat, group=group), col="red")



#-------------------------------------------------------------------------------
# Exercise
#-------------------------------------------------------------------------------
# These are counts of all crimes that occurred in Portland in 2012
count(crime2012, Major.Offense.Type) %>% arrange(desc(n)) %>% as.data.frame()

# Investigate the location of specific crimes using similar maps as above.
# For example, where do car thefts occur?
base.plot +
  geom_point(data=crime2012, aes(x=long, y=lat, group=group), alpha=0.2) +
  scale_x_continuous(limits = c(-123.0, -122.3)) +
  scale_y_continuous(limits = c(45.43, 45.73)) +
  geom_density2d(data=crime2012, aes(x=long, y=lat, group=group), col="red") +
  facet_wrap(~Major.Offense.Type)

# From the package ggmap
library(ggmap)
google.map <- get_map(location = "Portland, OR", maptype = "roadmap", zoom = 10, color = "color")

# Plot it
ggmap(google.map) +
  # The census tract outlines aren't as important if you have the actual map!
  # geom_path(data=PDX.map, aes(x=long, y=lat, group=group), col="black", size=0.5) +
  coord_map() +
  theme_bw() +
  xlab("longitude") + ylab("latitude") +
  geom_point(data=crime2012, aes(x=long, y=lat, group=group), alpha=0.05) +
  scale_x_continuous(limits = c(-123.0, -122.3)) +
  scale_y_continuous(limits = c(45.43, 45.73)) +
  geom_density2d(data=crime2012, aes(x=long, y=lat, group=group), col="red")



