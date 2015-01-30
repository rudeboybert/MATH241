#------------------------------------------------------------------------------
# The following code ensures all necessary packages are installed
#------------------------------------------------------------------------------
pkg <- c("ggplot2", "dplyr")
new.pkg <- pkg[!(pkg %in% installed.packages())]
if (length(new.pkg)) {
  install.packages(new.pkg, repos="http://cran.rstudio.com/")
}
library(ggplot2)
library(dplyr)


#------------------------------------------------------------------------------
# Viewing data
#------------------------------------------------------------------------------
# We're going to work with the diamonds and mtcars data set again
data(diamonds)
data(mtcars)
diamonds

# The previous command lists too many rows to view conveniently, so we convert it to tbl_df format.  This is useful when our data is large.
diamonds <- tbl_df(diamonds)
diamonds

# Some other useful viewing tools.  The View command is the same as going to the Environment panel in RStudio and clicking on the name of a variable: it shows it in spreadsheet format.
glimpse(diamonds)
View(diamonds)




#------------------------------------------------------------------------------
# The 5 "verbs" of data manipulation and piping
#------------------------------------------------------------------------------
# Filter out ROWS so that only those of "Ideal" cut remain.
# NOTE:  equality in computer programming is with a "==" and not "="
filter(diamonds, cut == "Ideal")
filter(diamonds, cut == "Ideal", color == "E")
filter(diamonds, cut == "Ideal", color == "E" | color == "I")

# Select columns i.e. variables
select(diamonds, carat)
select(diamonds, carat, x)
select(diamonds, -x, -y, -z)

# Arrange
?arrange
arrange(diamonds, price)
arrange(diamonds, desc(price))
# What do you think this does?
arrange(diamonds, desc(cut), carat)



# Now for an example of "piping"
filter(diamonds, cut == "Ideal") %>% select(carat)


filter(diamonds, cut == "Ideal") %>% select(carat) %>% sum()



filter(diamonds, cut == "Ideal") %>% select(carat) %>% sum()
sum(select(filter(diamonds, cut == "Ideal"), carat))




summarize(diamonds, mean(price))
group_by(diamonds, cut) %>% summarize(mean(price))
