library(rgdal)
library(rgeos)
library(maps)
library(spdep)



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