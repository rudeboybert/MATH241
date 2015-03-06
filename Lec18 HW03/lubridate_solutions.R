# Install these packages:
library(Quandl)
library(lubridate)

library(dplyr)
library(ggplot2)

#-------------------------------------------------------------------------------
# Data for Today: Bitcoin Price vs USD Dollar
# https://www.quandl.com/data/BAVERAGE/USD-USD-BITCOIN-Weighted-Price
#-------------------------------------------------------------------------------
bitcoin <- Quandl("BAVERAGE/USD") %>% tbl_df()
bitcoin

# We rename the variables so that they don't have spaces. You do that as follows
# using ` marks (next to the "1" key):
bitcoin <- rename(bitcoin, Avg = `24h Average`, Total.Volume = `Total Volume`)



#-------------------------------------------------------------------------------
# Parsing dates and times
#-------------------------------------------------------------------------------
# EXERCISE: As it is, the dates in the bitcoin data are simply character
# strings.  Convert the date variable from character strings to "POSIXct"
# date/time objects and plot a time series of the avg price of bitcoins relative
# to USD vs date.  What is the overall trend?

# We convert them to date/time objects using the ymd()
bitcoin$Date <- ymd(bitcoin$Date)
bitcoin$Date

# Time series
p <- ggplot(data=bitcoin, aes(x=Date, y=Avg)) + geom_line() +
  xlab("Date") + ylab("Bitcoin price vs US Dollar")
p
p + geom_smooth()



#-------------------------------------------------------------------------------
# Setting and Extracting information
#-------------------------------------------------------------------------------
# EXERCISE: Create a new variable day.of.week which specifies the day of week
# and compute the mean trading value split by day of week.  Which day of the
# week is there on average the most trading of bitcoins?
bitcoin$day.of.week <- wday(bitcoin$Date, label=TRUE)
group_by(bitcoin, day.of.week) %>%
  summarise_each(funs(mean, sd), Total.Volume) %>%
  arrange(mean)



#---------------------------------------------------------------
# Interval functions
#---------------------------------------------------------------
# EXERCISE:  Using the interval and %within% commands, plot the times series
# for the price of bitcoin to dates in 2013 and on.
date.range <- interval(ymd(20130101), ymd(20150601))
bitcoin <- filter(bitcoin, Date %within% date.range)

ggplot(data=bitcoin, aes(x=Date, y=Avg)) + geom_line() +
  xlab("Date") + ylab("Bitcoin price vs US Dollar") + geom_smooth()

# EXERCISE.  Replot the above curve so that the 4 seasons are in different
# colors.  For simplicity assume Winter = (Jan, Feb, Mar), etc.  Don't forget
# the overall smoother.
#
# Hint: nested ifelse statements and the following %in%  function which is
# similar to %within% but for individual elements, not intervals.
c(3,5) %in% c(1,2,3)


# This gets a bit nasty in the second mutate below:  we have a series of nested
# ifelse() statements
bitcoin <-
  mutate(bitcoin, month=month(Date)) %>%
  mutate(
         Season = ifelse(month %in% c(1,2,3), "spring",
                         ifelse(month %in% c(4,5,6), "summer",
                                ifelse(month %in% c(7,8,9), "fall", "winter")
                         ))
  )

# We could alternatively using piping, but needs to be outside the dplyr piping
# or else things will get confused
bitcoin$Season <-
  ifelse(bitcoin$month %in% c(7,8,9), "fall", "winter") %>%
  ifelse(bitcoin$month %in% c(4,5,6), "summer", .) %>%
  ifelse(bitcoin$month %in% c(1,2,3), "spring", .)



# Reorder the factors
bitcoin$Season <- factor(bitcoin$Season, levels=c("spring", "summer", "fall", "winter"))

ggplot(data=bitcoin, aes(x=Date, y=Avg)) +
  geom_point(aes(col=Season)) +
  xlab("Date") + ylab("Bitcoin price vs US Dollar") +
  scale_y_log10() +
  geom_smooth()

# Or alternatively I could define "Quarters" which are a combination of the year
# and the season and plot a separate linear smoother for each by setting the
# group aesthetic.  We'll learn more about the paste() command when we learn
# about text manipulation
bitcoin <- mutate(bitcoin, Quarter=paste(year(Date),Season))

ggplot(data=bitcoin, aes(x=Date, y=Avg, group=Quarter)) +
  geom_point(aes(col=Season)) +
  xlab("Date") + ylab("Bitcoin price vs US Dollar") +
  scale_y_log10() +
  geom_smooth(method="lm")
