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
# Exercise for today
#-------------------------------------------------------------------------------
# Run this line, search for "lubridate", and click on HTML to get the "vignette"
# (example file).  You can also browse the source code.
browseVignettes()

# Go over the source code, but for each section, I've added some additional
# notes.



#-------------------------------------------------------------------------------
# Parsing dates and times
#-------------------------------------------------------------------------------
arrive <- ymd_hms("2011-03-04 12:00:00", tz = "Pacific/Auckland")
leave <- ymd_hms("2011-08-10 14:00:00", tz = "Pacific/Auckland")

# ymd_hms() is a cookie-cutter function.  parse_date_time() allows more
# flexible parsing of Date/Time Objects than ymd_hms(), but requires more
# careful specification.  Look at the help file and look at Details section
?parse_date_time()

# Example say we have a date/time object that's not "clean"
x <- "Sun 2003 Nov 30 19:48:20"
parse_date_time(x, "%Y %b %d %H%M%S")

x <- "Sunday 03 Nov 30 19:48:20"
parse_date_time(x, "%y %b %d %H%M%S")

# lubridate knows to ignore weekday name.  Look at the list of formats in the
# help file to get a sense for how this function parses the date.


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
# As covered in the Vignette:
second(arrive)
minute(arrive)
hour(arrive)
day(arrive)
month(arrive)
year(arrive)
wday(arrive)
wday(arrive, label = TRUE)
week(arrive)

# Extra:  Change individual components
day(arrive) <- day(arrive) + 365
arrive

# Change it back
month(arrive) <- month(arrive) - 12
arrive


# EXERCISE: Create a new variable day.of.week which specifies the day of week
# and compute the mean trading value split by day of week.  Which day of the
# week is there on average the most trading of bitcoins?
bitcoin$day.of.week <- wday(bitcoin$Date, label=TRUE)
group_by(bitcoin, day.of.week) %>%
  summarise_each(funs(mean, sd), Total.Volume) %>%
  arrange(mean)



#-------------------------------------------------------------------------------
# Time Zones
#-------------------------------------------------------------------------------
# This list all time zones:
OlsonNames()

# Hadley Wickham is from New Zealand, so he sets a Skype meeting for NZ time
meeting <- ymd_hms("2011-07-01 09:00:00", tz = "Pacific/Auckland")
meeting

# What time is this in Portland?
with_tz(meeting, "America/Los_Angeles")

# Let's change the time zone to ours permanently
meeting <- force_tz(meeting, "America/Los_Angeles")
meeting



#-------------------------------------------------------------------------------
# Time Intervals
#-------------------------------------------------------------------------------
auckland <- interval(arrive, leave) # Same as arrive %--% leave
jsm <- interval(ymd(20110720, tz = "Pacific/Auckland"), ymd(20110831, tz = "Pacific/Auckland"))

# Compare these two time intervals.  A bit hard to read unfortunately
auckland
jsm



#---------------------------------------------------------------
# Interval functions
#---------------------------------------------------------------
int_overlaps(jsm, auckland)
int_start(jsm)
int_flip(jsm)
int_shift(jsm, new_duration(week=12))

x <- c(ymd(20110725, tz = "Pacific/Auckland"), ymd(20110901, tz = "Pacific/Auckland"))
x
x %within% jsm


# EXERCISE:  Using the interval and %within% commands, plot the times series
# for the price of bitcoin to dates in 2013 and on.
date.range <- interval(ymd(20130101), ymd(20150601))
filter(bitcoin, Date %within% date.range) %>%
  ggplot(data=., aes(x=Date, y=Avg)) + geom_line() +
  xlab("Date") + ylab("Bitcoin price vs US Dollar") + geom_smooth()

# EXERCISE.  Replot the above curve so that the 4 seasons are in different
# colors.  For simplicity assume Winter = (Jan, Feb, Mar), etc.  Don't forget
# the overall smoother.
#
# Hint: nested ifelse statements and the following %in%  function which is
# similar to %within% but for individual elements, not intervals.
c(3,5) %in% c(1,2,3)

bitcoin <-
  filter(bitcoin, Date %within% date.range) %>%
  mutate(month=month(Date),
       Season = ifelse(month %in% c(1,2,3), "spring",
                       ifelse(month %in% c(4,5,6), "summer",
                              ifelse(month %in% c(7,8,9), "fall", "winter")
                       )),
       Season = factor(Season, levels=c("spring", "summer", "fall", "winter"))
       )

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
