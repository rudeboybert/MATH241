library(rgdal)
library(rgeos)
library(maps)
library(spdep)





# https://github.com/hadley/ggplot2/wiki/plotting-polygon-shapefiles
setwd("~/Documents/Teaching/MATH241/MATH241_Notes/Lec20 Maps in R/ecoregion_design/")
utah <- readOGR(dsn=".", layer="eco_l3_ut")
utah@data$id <- rownames(utah@data)
utah.points <- fortify(utah, region="id")
utah.df <- inner_join(utah.points, utah@data, by="id")

ggplot(utah.df, aes(x=long, y=lat, group=group, fill=LEVEL3_NAM)) +
  geom_polygon() +
  geom_path(color="white") +
  coord_equal() +
  scale_fill_brewer("Utah Ecoregion", palette="Set3")






PDX <- readShapeSpatial("tract2010")
proj4string(PDX) <- "+proj=lcc +lat_1=44.33333333333334 +lat_2=46 +lat_0=43.66666666666666 +lon_0=-120.5 +x_0=2500000 +y_0=0 +ellps=GRS80 +units=ft +no_defs"
PDX <- spTransform(PDX, CRS("+proj=longlat +ellps=WGS84"))
PDX@data$id <- rownames(PDX@data)
PDX <- subset(PDX, COUNTY=="051")



PDX <- readOGR(dsn=".", layer="tract2010")
PDX <- spTransform(PDX, CRS("+proj=longlat +ellps=WGS84"))
PDX@data$id <- rownames(PDX@data)
PDX <- subset(PDX, COUNTY=="051")