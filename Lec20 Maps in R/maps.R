library(dplyr)
library(ggplot2)
library(maptools)
library(ggmap)



#-------------------------------------------------------------------------------
# 2010 Census Tract Data
#-------------------------------------------------------------------------------
# Download 2010 Census Tract from http://rlisdiscovery.oregonmetro.gov/

# Basic plot of "Spatial Polygons" object
PDX <- readShapeSpatial("tract2010")

# Don't fret about this part.  The geographical coordinate system of this particular data
# originally is not in longitude and latitude, so we change it.  Many datasets will already be
# in lat-long
proj4string(PDX) <- "+proj=lcc +lat_1=44.33333333333334 +lat_2=46 +lat_0=43.66666666666666 +lon_0=-120.5 +x_0=2500000 +y_0=0 +ellps=GRS80 +units=ft +no_defs"
PDX <- spTransform(PDX, CRS("+proj=longlat +ellps=WGS84"))

# Plot the map use native R plot command (i.e. not the ggplot package)
plot(PDX, axes=TRUE)

# Restrict to Multnomah County.  Unfortunately, the filter() command from dplyr
# doesn't work on sp objects, so we use subset()
PDX <- subset(PDX, COUNTY=="051")
plot(PDX, axes=TRUE)

# Many shapefiles come with data attached to each geographic object.  In this
# case we have census data for each census tract.  Looking at PDX.data, each
# region's unique identifier is, unsurprisingly, the FIPS code.
PDX.data <- PDX@data %>% tbl_df()
View(PDX.data)

# PDX@data$id <- rownames(PDX@data)




#-------------------------------------------------------------------------------
# Convert sp object to ggplot'able object
#-------------------------------------------------------------------------------
# We have to use the fortify() command to convert the sp object to a ggplot'able
# data frame where regions are ID'ed using the unique identifier discussed
# above.

PDX.map <- fortify(PDX, region="FIPS") %>% tbl_df()
PDX.map


# Look very carefully at this call:
# -the group aesthetic ensures census tracts (i.e. polygons) are kept and
#  plotted together
# -the polygons will be filled with darkorange
# -geom_path traces out the outline of each census tract in black
# -coord_map() is a map-specific coordinate command that ensures the aspect ratio
#  of longitude and latitude make sense
ggplot(data=PDX.map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="darkorange") +
  geom_path(color="black", size=0.5) +
  coord_map() +
  xlab("longitude") + ylab("latitude")




#-------------------------------------------------------------------------------
# Subimpose a background map
#-------------------------------------------------------------------------------
# Using the get_map() function from the ggmap package, we can download Google
# map images
google.map <-
  get_map(location = "Portland, OR", maptype = "roadmap", zoom = 10,
          color = "color")

# Plot it
p <- ggmap(google.map) + xlab("longitude") + ylab("latitude")
p

# We plot the previous census tracts of Portland onto the map.  Note since the
# ggmap has its own data and aesthetics, for both the geom_polygon and geom_path
# we need to define their own separate data and aesthetics.  The alpha value sets
# the opacity of the plot.
p +
  geom_polygon(data=PDX.map, aes(x=long, y=lat, group=group), fill="darkorange", alpha=0.6) +
  geom_path(data=PDX.map, aes(x=long, y=lat, group=group), color="black", size=0.5)




#-------------------------------------------------------------------------------
# Proportion Caucasian
#-------------------------------------------------------------------------------
PDX.data <- mutate(PDX.data, prop.hisp = HISPANIC/POP10)
PDX.data <- mutate(PDX.data,
                   prop.hisp.bracket = cut(prop.hisp, quantile(prop.hisp), dig.lab=3)
                     )

PDX.map <- fortify(PDX, region="FIPS") %>%
  left_join(PDX.data, by=c("id"="FIPS"))


ggplot(data=PDX.map, aes(x=long, y=lat, group=group, fill=prop.hisp.bracket)) +
  geom_polygon() +
  geom_path(color="black", size=0.5) +
  coord_map() +
  scale_fill_brewer(palette = 'Greys', name="Prop. Hispanic") +
  xlab("longitude") + ylab("latitude")


ggplot(data=PDX.map, aes(x=long, y=lat, group=group, fill=prop.hisp)) +
  geom_polygon() +
  geom_path(color="black", size=0.5) +
  coord_map() +
  xlab("longitude") + ylab("latitude") +
  scale_fill_continuous(low="white", high="black", name="Prop. Hispanic")

p +
  geom_polygon(data=PDX.map, aes(x=long, y=lat, group=group, fill=prop.hisp), alpha=0.6) +
  geom_path(data=PDX.map, aes(x=long, y=lat, group=group, fill=prop.hisp), color="black", size=0.5) +
  scale_fill_continuous(low="white", high="black", name="Prop. Hispanic")







#-------------------------------------------------------------------------------
# Exercise:  Recycling the code above, plot a map of the population of Western
# Washington
#-------------------------------------------------------------------------------
ww <- readShapeSpatial("ww.shp")
ww.data <- ww@data %>% tbl_df()

ww.map <- fortify(ww, region="FIPS") %>%
  inner_join(ww.data, by=c('id'='FIPS')) %>% tbl_df()

ww.map <- mutate(
  ww.map,
  POP2000.bracket = cut(POP2000, quantile(POP2000), dig.lab=10)
)

ggplot(data=ww.map, aes(long, lat, group=group, fill=POP2000.bracket)) +
  geom_polygon() +
  geom_path(color="black", size=0.05) +
  xlab("longitude") +
  ylab("latitude") +
  coord_map() +
  scale_fill_brewer(palette="Greys", name="Population")










