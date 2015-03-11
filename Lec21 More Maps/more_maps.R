library(rgdal)
library(rgeos)
library(maps)
library(spdep)



PDX <- readShapeSpatial("tract2010")
proj4string(PDX) <- "+proj=lcc +lat_1=44.33333333333334 +lat_2=46 +lat_0=43.66666666666666 +lon_0=-120.5 +x_0=2500000 +y_0=0 +ellps=GRS80 +units=ft +no_defs"
PDX <- spTransform(PDX, CRS("+proj=longlat +ellps=WGS84"))
PDX@data$id <- rownames(PDX@data)
PDX <- subset(PDX, COUNTY=="051")



PDX <- readOGR(dsn=".", layer="tract2010")
PDX <- spTransform(PDX, CRS("+proj=longlat +ellps=WGS84"))
PDX@data$id <- rownames(PDX@data)
PDX <- subset(PDX, COUNTY=="051")







# Ignore this part.  The geographical coordinate system of this particular data
# originally is not in longitude and latitude, so we change it.  Many datasets
# will already be in lat-long
proj4string(PDX) <- "+proj=lcc +lat_1=44.33333333333334 +lat_2=46 +lat_0=43.66666666666666 +lon_0=-120.5 +x_0=2500000 +y_0=0 +ellps=GRS80 +units=ft +no_defs"
PDX <- spTransform(PDX, CRS("+proj=longlat +ellps=WGS84"))






coord_map







# We plot the previous census tracts of Portland onto the map.  Note since the
# ggmap has its own data and aesthetics, for both the geom_polygon and geom_path
# we need to define their own separate data and aesthetics.  The alpha value sets
# the opacity of the plot.
p +
  geom_polygon(data=PDX.map, aes(x=long, y=lat, group=group), fill="darkorange", alpha=0.6) +
  geom_path(data=PDX.map, aes(x=long, y=lat, group=group), color="black", size=0.5)




p +
  geom_polygon(data=PDX.map, aes(x=long, y=lat, group=group, fill=prop.hisp), alpha=0.6) +
  geom_path(data=PDX.map, aes(x=long, y=lat, group=group, fill=prop.hisp), color="black", size=0.5) +
  scale_fill_continuous(low="white", high="black", name="Prop. Hispanic")







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

















http://rstudio-pubs-static.s3.amazonaws.com/8495_3eca534268ea4c89b6b3d57dcf2638c2.html
PDX_nb <- poly2nb(PDX, queen = FALSE)
summary(PDX_nb)
coordinates(PDX)
# Construct row-standardized spatial weights
PDX_W <- nb2listw(PDX_nb, style = "W", zero.policy = TRUE)
# Construct unstandardized spatial weights
PDX_B <- nb2listw(PDX_nb, style = "B", zero.policy = TRUE)
########### Calculate Moran's I of cases
help(moran.test)
moran.test(PDX$HISPANIC/PDX$POP10, PDX_W)  #row-standardized