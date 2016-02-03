library(dplyr)
library(rvest)
library(stringr)
library(ggplot2)



#------------------------------------------------------------------------------
#
# Do Hispanics Cluster?
#
#------------------------------------------------------------------------------
# Hopefully this works for you
library(rgdal)

# Install this package as well.  We need this to run Moran's I.
library(spdep)

# We use the same shapefiles downloaded from Lecture 20
# - Import the Portland Shapefile using the readOGR() function from the rgdal
#   package instead of the other function used in Lecture 20. Please the
#   function below from now on.
# - Convert the coordinate system to latitude/longitude using the
#   spTransform() function
# - Select only census tracts in Multnomah County
PDX.shapefile <- readOGR(dsn=".", layer="tract2010", verbose=FALSE) %>%
  spTransform(CRS("+proj=longlat +ellps=WGS84")) %>%
  subset(COUNTY=="051")

# Get the data frame of information from the shapefile.  In this case rather
# weirdly we have to use @ instead of $ to extract the data.
# Then compute the proportion of the population that is hispanic for each
# census tract.
PDX.data <- PDX.shapefile@data %>% tbl_df() %>%
  mutate(prop.hisp=HISPANIC/POP10)

# We convert the shapefile to a ggplot'able data frame and then plot it
PDX.map <- fortify(PDX.shapefile, region="FIPS") %>% tbl_df()
ggplot(PDX.map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white") +
  geom_path(col="black", size=0.5) +
  coord_map() +
  theme_bw()

# Join the census tract data to the map data
PDX.map <- inner_join(PDX.map, PDX.data, by=c("id"="FIPS"))

ggplot(PDX.map, aes(x=long, y=lat, group=group, fill=prop.hisp)) +
  geom_polygon() +
  geom_path(col="black", size=0.5) +
  coord_map() +
  scale_fill_continuous(low="white", high="black", name="Prop. Hispanic") +
  theme_bw()


#---------------------------------------------------------------
# Recreate the Spatial Connectivity map from the slides.
#---------------------------------------------------------------
# Get coordinates of each region.  Much of this is code is techincal, so don't
# worry about understanding it completely.
PDX.coord <- coordinates(PDX.shapefile)

# Get neighbor information
PDX.nb <- poly2nb(PDX.shapefile, queen = FALSE)
summary(PDX.nb)

# Get weights as defined in slides.  "B" indicates basic weights.
PDX.weights <- nb2listw(PDX.nb, style = "B", zero.policy = TRUE)

# Plot using base R, not ggplot.  Don't try to understand the code to make this
# kind of plot using base R.
plot(PDX.shapefile, border = "grey60", main="Spatial Connectivity")
box()
plot(PDX.nb, PDX.coord, pch = 19, cex = 0.3, lwd=0.5, add = TRUE)


#---------------------------------------------------------------
# Moran's I.
#---------------------------------------------------------------
# We're going to test Moran I's on statistical noise.
# runif(n, min=a, max=b) returns n Uniform(a,b) random variables. i.e. n values
# uniformly chosen on the interval [a,b]].

# Run the next bit of code a few times to convince yourselves of this fact.
n <- nrow(PDX.data)
noise <- runif(n, min=0, max=1)
qplot(noise, binwidth=0.1)

# We then compute Moran's I using Y_i = noise.  Look at the statistic and
# p-value for multiple runs of the following two lines.
noise <- runif(n, min=0, max=1)
moran.test(noise, PDX.weights)

# EXERCISE 1: Use Moran's I to see if there is evidence that hispanics cluster.
# Investigate some other varibles as well





#------------------------------------------------------------------------------
#
# Mapping the structure of the US Senate
#
#------------------------------------------------------------------------------
# This function takes in numerical values that are coded as strings with commas
# in them and converts them to numeric values.  Note the gsub is saying replace
# all commas with ""
remove.commas <- function(x){
  x <- gsub(",", "", x) %>% as.numeric()
  return(x)
}

# Let's revisit our old friend the rvest package and scrape some web data.
# Specifically the population of each state in 2010 and other political info
state.pop <-
  html("http://simple.wikipedia.org/wiki/List_of_U.S._states_by_population") %>%
  html_nodes("table") %>% .[[1]] %>% html_table() %>%
  tbl_df()

# We clean the variables. Note for column names that are "weird", we surround
# them with ` marks (above the TAB button).  We also define a variable
# Pop.per.senator and lowercase the names of all states.
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

# EXERCISE 2:  Solutions are at the end of this file.
# 1.  Ignoring state information, what is the "baseline" ratio of Population per
#     Senator?
# 2.  Construct a measure of how much a state benefits/is at a disadvantage by
#     the current arrangement of the Senate where
#     -low values indicate benefit
#     -1 indicates indifference
#     -high values indicate disadvantage
# 3.  Plot a histogram of this value
# 4.  Plot a map of this measure
# 5.  Which states benefits the most?
# 6.  Which states benefit the least?





#------------------------------------------------------------------------------
#
# SOLUTIONS TO EXERCISE 1:
#
#------------------------------------------------------------------------------
# The test statistic is 0.63 > 0, indicating positive correlation.  The p-value
# is a microscopic 2.2 x 10^{-16}, so we can confidently reject the null
# hypothesis of no spatial autocorrelation
moran.test(PDX.data$prop.hisp, PDX.weights)





#------------------------------------------------------------------------------
#
# SOLUTIONS TO EXERCISE 2:
#
#------------------------------------------------------------------------------
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