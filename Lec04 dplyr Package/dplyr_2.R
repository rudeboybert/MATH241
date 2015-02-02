#------------------------------------------------------------------------------
# The following code ensures all necessary packages are installed
#------------------------------------------------------------------------------
pkg <- c("ggplot2", "dplyr", "scales", "RColorBrewer")
new.pkg <- pkg[!(pkg %in% installed.packages())]
if (length(new.pkg)) {
  install.packages(new.pkg, repos="http://cran.rstudio.com/")
}
library(ggplot2)
library(dplyr)




