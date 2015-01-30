#------------------------------------------------------------------------------
# The following code ensures all necessary packages are installed
#------------------------------------------------------------------------------
pkg <- c("ggplot2", "dplyr", "scales")
new.pkg <- pkg[!(pkg %in% installed.packages())]
if (length(new.pkg)) {
  install.packages(new.pkg, repos="http://cran.rstudio.com/")
}
library(ggplot2)
library(dplyr)


#------------------------------------------------------------------------------
# Wrapping Up UC Berkeley Admissions
#------------------------------------------------------------------------------
# Load and "tidy" data
data(UCBAdmissions)
UCB <- as.data.frame(UCBAdmissions)

# The scales package allows us to put %'ages on axes
library(scales)
ggplot(UCB, aes(x=Gender, y=Freq, fill = Admit)) +
  geom_bar(stat = "identity", position="fill") +
  facet_wrap(~ Dept, nrow = 2) +
  scale_y_continuous(labels = percent) +
  ggtitle("Acceptance Rate Split by Gender & Department") +
  xlab("Gender") +
  ylab("% of Applicants")

ggplot(UCB, aes(x=Dept, y=Freq, fill = Admit)) +
  geom_bar(stat = "identity", position="fill") +
  ggtitle("Acceptance Rate Split by Department") +
  xlab("Dept") +
  ylab("% of Applicants")




#------------------------------------------------------------------------------
# dplyr: Viewing data
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
filter(diamonds, price >= 326)
filter(diamonds, price >= 326 & price <= 350)

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

# mutate
mutate(diamonds, price.squared=price^2)
transmute(diamonds, price.squared=price^2)

# summarise
summarise(diamonds, mean(price), sd(price))
summarise(diamonds, mean=mean(price), sd=sd(price))




#------------------------------------------------------------------------------
# Piping
#------------------------------------------------------------------------------
# Now for an example of "piping" using the "then" command
# NOTE:  when piping, we assume what gets piped goes into the first argument
# of the next command.  i.e. note how we don't indicate the data is diamond.
filter(diamonds, cut == "Ideal")
filter(diamonds, cut == "Ideal") %>% select(carat, price)
filter(diamonds, cut == "Ideal") %>% select(carat, price) %>% arrange(carat, price)

# You can also stagger commands across multiple lines to make it easier to read.
# Say out loud what happening:  take diamonds, filter to keep only those with ideal
# cut THEN select ...
filter(diamonds, cut == "Ideal") %>%
  select(carat, price) %>%
  arrange(carat, price)

# The above is the same as the following with nested parentheses!  What a nightmare!
arrange(select(filter(diamonds, cut == "Ideal"), carat, price), carat, price)




#------------------------------------------------------------------------------
# Grouping via group_by()
#------------------------------------------------------------------------------
# This is a very VERY convenient feature of dplyr since we are often not interested
# in summarizing variables across all observations, but for subsets of observations.
# You can "group by" a categorical variable
data(Titanic)
Titanic <- as.data.frame(Titanic)
names(Titanic)

# The main categorical variable of interest is "Survived".  The following sums the "Freq"
# variable but keeps the grouping varible "Survived" i.e. it "collapses" or "aggregates"
# over the rest
group_by(Titanic, Survived)
group_by(Titanic, Survived) %>% summarise(sum(Freq))

# Same but give the new variable the name "count"
group_by(Titanic, Survived) %>% summarise(Count=sum(Freq))

# Now group by the variable "Class" as well. i.e. collapse over the rest
group_by(Titanic, Survived, Class) %>% summarise(Count=sum(Freq))




#------------------------------------------------------------------------------
# You can pipe into ggplot!
#------------------------------------------------------------------------------
# We're going to recreate the graphic that was the basis of the UC Berkeley
# lawsuit.  Consider:
group_by(UCB, Admit, Gender) %>% summarise(Freq = sum(Freq))

# We can pipe this into ggplot.  NOTE: it gets piped to the first argument of
# the ggplot() function, which is where you specify your data
group_by(UCB, Admit, Gender) %>% summarise(Freq = sum(Freq)) %>%
  ggplot(aes(x=Gender, y=Freq, fill=Admit)) +
  geom_bar(stat = "identity", position="fill") +
  ggtitle("Acceptance Rate Split by Gender") +
  xlab("Gender") +
  ylab("Proportion of Applicants")



#------------------------------------------------------------------------------
# Exercise
#------------------------------------------------------------------------------
# Using dplyr, fix the 2nd plot above showing the acceptance rates of the
# different departments at UC Berkeley so that the bars aren't split up.  i.e.
# collapse the data appropriately.