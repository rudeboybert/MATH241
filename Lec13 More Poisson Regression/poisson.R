library(ggplot2)
library(dplyr)

# Stop data from NYC between 1998-1999 (with noise added to protect
# confidentiality). As described in Chapter 1.2 of Gelman page 5, this was part
# of an investigation of whether or not the NYPD's stop and frisk policy
# disproportionately targetted minorities. The data only focuses on whites,
# black, and hispanic.
# From http://www.stat.columbia.edu/~gelman/arm/examples/police/.  Our analysis
# differs from the one on page 112.
arrests <- read.table("frisk_with_noise.txt", header=TRUE) %>%
  group_by(precinct, eth) %>% summarise_each(funs(sum)) %>% select(-crime) %>%
  tbl_df()
arrests

# -units i are precincts x ethnic groups (75 x 3 =225 rows)
# -outcome y_i is the number of stops
# -exposure_i is the number of people of the particular ethnic group who live in
#  the jurisdiciton of the precinct
# -precincts are numbered 1-75
# -ethnicity 1=black, 2=hispanic, 3=white

# Convert to factors setting appropriate levels
arrests$precinct <- factor(arrests$precinct)
arrests$eth <- factor(arrests$eth, labels=c("black", "hispanic", "white"))



#------------------------------------------------
# Exploratory Data Analysis
#------------------------------------------------
# Investigate population:
group_by(arrests, eth) %>% summarise(pop=sum(pop))
p <- ggplot(data=arrests, aes(x=pop)) + geom_histogram() + facet_wrap(~eth, ncol=1)
p
# Changing the x-axis scale to a logged one helps deal with the skew
p + scale_x_log10()


# EXERCISE:  Investigate arrests.  Which groups get predominately stopped?
group_by(arrests, eth) %>% summarise(stops=sum(stops))
p <- ggplot(data=arrests, aes(x=stops)) + geom_histogram() + facet_wrap(~eth, ncol=1)
p
# Changing the x-axis scale to a logged one helps deal with the skew
p + scale_x_log10()


# Investigate relationship between population size and number of stops
p <- ggplot(data=arrests, aes(x=pop, y=stops, group=eth, col=eth)) + geom_point()
p
# A raw plot of stops over population is hard to make sense of given the right
# skew in both data, so we use a log-log plot i.e. both the x and y axis on
# a log-scale
p + scale_x_log10() + scale_y_log10()

# EXERCISE:  Add a smoother to the previous plot to focus on the signal
# distinguishing the three groups and less on the noise.
p + scale_x_log10() + scale_y_log10() + geom_smooth()


# EXERCISE: Using dplyr, compare the "stops per 10K individuals" between the
# three ethnic groups
group_by(arrests, eth) %>%
  summarise(rate.per.10K = 10000*sum(stops)/sum(pop)) %>%
  ggplot(data=., aes(x=eth, y=rate.per.10K)) +
  geom_bar(stat="identity")





#------------------------------------------------
# Model 0: Just the average rate i.e. using no predictors
#------------------------------------------------
# Overall arrest rate:
rate0 <- sum(arrests$stops)/sum(arrests$pop)
rate0

# Model Fit:
# Poisson regression is done in R using glm() again, but now setting family to
# poisson.  Note also that we specifiy the offset to be log(pop).  Recall that
# the ~1 means fit only the intercept
model0 <- glm(stops ~ 1, offset=log(pop), family=poisson, data=arrests)
summary(model0)
b0 <- coefficients(model0)

# What does this value correspond to?
exp(b0)

# A 95% confidence interval on the rate of arrest in NYC
exp(confint(model0))





#------------------------------------------------
# Model 1: Incorporating ethnicity
#------------------------------------------------
# EXERCISE:  Find the arrest rate for all three ethnic groups
group_by(arrests, eth) %>% summarise(rate=sum(stops)/sum(pop))

# Model Fit:
model1 <- glm(stops ~ eth, family=poisson, data=arrests, offset=log(pop))
summary(model1)
b1 <- coefficients(model1)
exp(b1)

# CRUCIAL EXERCISE:  What is the relationship between the above rates and
# exp(b)?

# RELATED EXERCISE:  Compute 95% confidence intervals on the coefficients.  What
# is the "null" value for such CI's?  Do the hispanic and white coefficient CI's
# include it?
exp(confint(model1))





#------------------------------------------------
# Model 2: Ethnicity + Precinct
#------------------------------------------------
# EXERCISE:  Create a single plot that shows stop rates for each of the three
# ethnic groups for all 75 precincts in NYC.  Hint:  consider the "group" aesthetic
# What trend do you notice?
p <- group_by(arrests, eth, precinct) %>% summarise(rate=sum(stops)/sum(pop), stops=sum(stops), pop=sum(pop)) %>%
  ggplot(aes(x=precinct, y=rate, group=eth, col=eth)) + geom_line() + ylab("Stop rate (log-scale)")
p
p + geom_point(aes(size=log10(pop)))
p + geom_point(aes(size=log10(pop))) + scale_y_log10()

# Model Fit:
model2 <- glm(stops ~ eth + precinct, family=poisson, data=arrests, offset=log(pop))
summary(model2)
b2 <- coefficients(model2)
exp(b2)
CI2 <- confint(model2)
exp(CI2)

# EXERCISE:  What is the interpretation of the first three coefficients based on
# ethnicity now?
