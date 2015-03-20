library(rgdal)
library(rgeos)
library(maps)
library(spdep)

library(dplyr)
library(rvest)
library(stringr)



#------------------------------------------------------------------------------
#
# US Senate
#
#------------------------------------------------------------------------------
# This function takes in numerical values that are coded as strings with commas
# in them and converts them to numeric values.  Note the gsub is saying replace
# all commas with ""
remove.commas <- function(x){
  x <- gsub(",", "", x) %>% as.numeric()
  return(x)
}

# Let's revisit our old friend rvest and scrape some web data.  Specifically
# the population of each state in 2010 and other political info
state.pop <-
  html("http://simple.wikipedia.org/wiki/List_of_U.S._states_by_population") %>%
  html_nodes("table") %>% .[[1]] %>% html_table() %>%
  tbl_df()

# We clean the variables. Note for column names that are "weird", we surround
# them with ` marks (above the TAB button).  We also define a variable
#
state.pop <- state.pop %>%
  rename(
    House.Seats = `House\nSeats`,
    Electoral.Votes = `Elect.\nVotes`,
    Pop.per.House.Seat = `Pop. per\nHouse\nSeat`,
    Pop.per.Electoral.Vote = `Pop. per\nElect.\nVote`
    ) %>%
  mutate(
    Population = remove.commas(Population),
    Pop.per.House.Seat = remove.commas(Pop.per.House.Seat),
    Pop.per.Electoral.Vote = remove.commas(Pop.per.Electoral.Vote),
    Pop.per.Senator = Population/2,
    State = tolower(State)
    )
View(state.pop)


# Import US state map data using the map_data() function in ggplot.
# Note that state.map is already been processed to be ggplot'able. i.e. there is
# -group: a "grouping variable" that associates multiple (long,lat)
#  points to the same polygon i.e the same state
# -order: an "ordering variable" that tells ggplot in what order the points
#  associated with a polygon should be plotted in.
state.map <- map_data("state") %>% tbl_df()
state.map

# Join the two data sets
US.senators <- inner_join(state.map, state.pop, by=c("region" = "State"))

# Again, note we are
# -Grouping by "group"
# -Setting the fill aesthetic of the polygons to be the variable of interest
# -Tracing a black outline of all states of width 0.5
ggplot(data=US.senators, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = Pop.per.Senator)) +
  geom_path(color="black", size=0.5) + # outline of states
  scale_fill_gradient(name="Pop. per Senator", low='white', high='red') +
  ggtitle("Population per Senator") +
  xlab("Longitude") + ylab("Latitude")

# EXERCISE 1:
# 1.  Ignoring state information, what is the "baseline" ratio of Population per
#  Senator?
# 2.  Construct a measure of how much a state benefits/is at a disadvantage by
#     the current arrangement of the Senate where
#     -low values indicate benefit
#     -high values indicate disadvantage
# 3.  Plot a histogram of this value
# 4.  Plot a map of this measure
# 5.  Which states benefits the most?
# 6.  Which states benefit the least?
#
# Next HW you will investigate which political parties benefit the most/least
# from the arrangement of the Senate.

# SOLUTIONS 1:
# 1.  It is the sum of the entire population over 50.
overall.ratio <- sum(state.pop$Population)/50

# 2.  We take the ratio of each state's ratio of Pop per Senator over the
#     overall US ratio
US.senators <- US.senators %>%
  mutate(relative.ratio = Pop.per.Senator/overall.ratio)

# 3.  The histogram where the value 1 means no benefit/disadvantage for a given
#     state
qplot(x=US.senators$relative.ratio) +
  xlab("Relative Ratio") +
  geom_vline(xintercept=1, col="red", size=1)

# However, this is not the right scale to show the data.  For example ratios of
# 0.5 and 2 are reciprocal, but in the original scale, all ratios below 1 get
# squashed between 0 and 1, where as all ratios above 1 have all the space in
# in the world.  We must therefore log (or log10) the data to show the inverse
# relationship between 0.5 and 2 and the appropriate scale.  Now log10(1)=0
# becomes the value of indifference
US.senators <-  US.senators %>%
  mutate(log.10.relative.ratio = log10(relative.ratio))
qplot(x=US.senators$log.10.relative.ratio) +
  xlab("log10 Relative Ratio") +
  geom_vline(xintercept=0, col="red", size=1)

# 4.
ggplot(data=US.senators, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = log.10.relative.ratio)) +
  geom_path(color="black", size=0.5) + # outline of states
  scale_fill_gradient(name="log10 of Relative Ratio", low='white', high='red') +
  ggtitle("log10 of Relative Ratio") +
  xlab("Longitude") + ylab("Latitude")

# 5. and 6.  The maps shows Vermont and Wyoming benefit the most as the have the
# smallest populations.  California and Texas benefit the least.




#------------------------------------------------------------------------------
#
# Do Hispanics Cluster?
#
#------------------------------------------------------------------------------
setwd("~/Documents/Teaching/MATH241/MATH241_Notes/Lec21 More Maps/tract2010")

# We
# - Import the Portland Shapefile using the readOGR() function from the rgdal
#   package
# - Convert the coordinate system to latitude/longitude using the
#   spTransform() function

library(rgeos)
library(rgdal)
PDX.shapefile <- readOGR(dsn=".", layer="tract2010")
PDX.shapefile <- spTransform(PDX.shapefile, CRS("+proj=longlat +ellps=WGS84"))
PDX.shapefile <- subset(PDX.shapefile, COUNTY=="051")

PDX.data <- PDX.shapefile@data %>% tbl_df() %>%
  mutate(prop.hisp=HISPANIC/POP10)

# We convert the shapefile to a ggplot'able data frame
PDX <- fortify(PDX.shapefile, region="FIPS") %>% tbl_df()
ggplot(PDX, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white") +
  geom_path(col="black", size=0.5) +
  coord_map()

# Join the census tract data to
PDX <- fortify(PDX.shapefile, region="FIPS") %>% tbl_df()
PDX <- inner_join(PDX, PDX.data, by=c("id"="FIPS"))
ggplot(PDX, aes(x=long, y=lat, group=group, fill=prop.hisp)) +
  geom_polygon() +
  geom_path(col="black", size=0.5) +
  coord_map() +
  scale_fill_continuous(low="white", high="black", name="Prop. Hispanic") +
  theme_bw()




http://rstudio-pubs-static.s3.amazonaws.com/8495_3eca534268ea4c89b6b3d57dcf2638c2.html

coord <- coordinates(PDX.shapefile)
PDX.nb <- poly2nb(PDX.shapefile, queen = FALSE)
summary(PDX.nb)
PDX.weights <- nb2listw(PDX.nb, style = "B", zero.policy = TRUE)

plot(PDX.shapefile, border = "grey60", main="Spatial Connectivity")
box()
plot(PDX.nb, coord, pch = 19, cex = 0.3, lwd=0.5, add = TRUE)




# We're going to test Moran I's on statistical noise.
# runif(n, min=a, max=b) returns n Uniform(a,b) random variables. i.e. n values
# uniformly chosen on the interval [a,b]].
# Run the next bit of code a few times to convince yourselves of this fact.
n <- nrow(PDX.data)
noise <- runif(n, min=0, max=1)
qplot(noise, binwidth=0.1)

# Note what happens to the p-value as you run the following bit of code a few
# times.  What proportion of the time will the p-value be alpha=0.05
# significant?
noise <- runif(n, min=0, max=1)
moran.test(noise, PDX.weights)


moran.test(PDX.data$prop.hisp, PDX.weights)



