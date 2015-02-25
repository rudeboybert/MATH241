library(ggplot2)
library(dplyr)

# Stop data from NYC between 1998-1999 (with noise added to protect
# confidentiality). As described in Chapter 1.2 of Gelman page 5, this was part
# of an investigation of whether or not the NYPD's stop and frisk policy
# disproportionately targetted minorities. The data only focuses on whites,
# black, and hispanic.
# From http://www.stat.columbia.edu/~gelman/arm/examples/police/.  Our analysis
# differs from the one on page 112.

# Aggregate over crime type for now.  i.e. collapse the counts
arrests <- read.table("frisk_with_noise.txt", header=TRUE) %>%
  group_by(precinct, eth) %>% summarise_each(funs(sum)) %>% select(-crime) %>%
  tbl_df()
arrests

# -units i are (precincts x ethnic group) (i.e. 75 x 3 = 225 rows)
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


# EXERCISE:  Investigate arrests.  Which groups are subject to the highest
# numbers of stops?
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
confint(model0)
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
# exp(b1)?
# The effects are multiplicative.  So for example blacks (the baseline) have a
# baseline rate of 0.009355162, but being hispanic has a multiplicative effect
# of 0.688386155 on that rate (i.e. it lower it).  Note 0.009355162 * 0.688386155
# is equal to the rate we first computed earlier

# RELATED EXERCISE:  Compute 95% confidence intervals on the coefficients.  What
# is the "null" value for such CI's?  Do the hispanic and white coefficient CI's
# include it?
exp(confint(model1))
# The null value is 1.  i.e. a multiplicative of 1 means no change.  For both
# whites and hispanics, they both don't include it, and the confidenct interval
# is entirely less than 1, suggesting a significant effect.





#------------------------------------------------
# Model 2: Ethnicity + Precinct
#------------------------------------------------
# EXERCISE:  Create a single plot that shows stop rates for each of the three
# ethnic groups for all 75 precincts in NYC.  Hint:  consider the "group" aesthetic
# What trend do you notice?
p <- group_by(arrests, eth, precinct) %>%
  summarise(rate=sum(stops)/sum(pop), stops=sum(stops), pop=sum(pop)) %>%
  ggplot(aes(x=precinct, y=rate, group=eth, col=eth)) + geom_line() +
  xlab("Precinct") + ylab("Stop rate (log-scale)") +
  scale_colour_discrete(name="Ethnicity") +
  ggtitle("Stop rates by NYPD in 1998-1999")

p
p + scale_y_log10()
p + scale_y_log10() + geom_point(aes(size=log10(pop)))



# Model Fit:
model2 <- glm(stops ~ eth + precinct, family=poisson, data=arrests, offset=log(pop))
summary(model2)
b2 <- coefficients(model2)
exp(b2)
CI2 <- confint(model2)
exp(CI2)

# EXERCISE:  What is the interpretation of the first three coefficients based on
# ethnicity now?
# Recall Precinct 1 was the baseline, so the first coefficient is the rate
# African-Americans get stoped at precinct 1, and the other two are the
# multiplicative effect on top of that (both less than 1, i.e. they get
# arrested at a lower rate)





#------------------------------------------------
# Overdispersion
#------------------------------------------------
# Get fitted values for stops i.e. y.hat
arrests$stops.hat <- fitted(model2)

# We compare the observed numbers of stops to the number of stops fitted by our
# model
qplot(stops, stops.hat, data=arrests, xlab="observed stops", ylab="fitted stops")
# logging both the x and y axes
qplot(stops, stops.hat, data=arrests, xlab="observed stops", ylab="fitted stops", log='xy')
# We add a line y=x to compare the observed to fitted values
qplot(stops, stops.hat, data=arrests, xlab="observed stops", ylab="fitted stops", log='xy') +
  geom_abline(intercept=0, slope=1, col="red")

# Create standardized residuals.  We see they are centered at 0 (dashed line),
# but have standard deviation much greater than 1.
arrests <- mutate(arrests,
                  residuals = stops-stops.hat,
                  z = residuals/sqrt(stops.hat))
qplot(arrests$z, xlab="Standardized Residuals")

# We expect 95% of the points to lie within +/- 2 standard deviations of the
# mean, (i.e. within the solid lines) but we see that there are many that
# aren't, suggesting overdispersion.
qplot(stops.hat, z, data=arrests) +
  xlab("fitted stops") + ylab("standardized residuals") +
  ggtitle("Standardized Residuals vs Fitted Values") +
  geom_hline(yintercept=0, linetype="dashed") +
  geom_hline(yintercept=c(-2, 2))


# Recall we have
# -n=225 observations
#
# -3 ethnic groups, one of which acts as a baseline, thus two parameters
# -75 precincts, one of which acts as a baseline, thus 74 parameters
# -1 intercept parameters
# Thus the number of parameters is k = 2 + 74 + 1
# Thus n-k = 148 degrees of freedom
n <- nrow(arrests)
k <- (nlevels(arrests$eth)-1) + (nlevels(arrests$precinct)-1) + 1
n-k

# Under the null hypothesis of no overdispersion, we'd expect the sum of the
# squared residuals to follow a chi-squared distribution with df=n-k
p <- ggplot(data.frame(x = c(0, 300)), aes(x)) +
  stat_function(fun = dchisq, args=list(df=n-k)) +
  xlab("sum squared residuals") +
  ylab("density") +
  ggtitle("Expected Distribution of Sum.Sq.Resid if No Overdispersion")
p

# The observed sum of squared residuals is crazy extreme; it is nowhere
# near the bulk of the distribution, suggesting massive overdispersion.
# i.e. we reject the null hypothesis of no overdispersion
observed.sum.sq.resid <- sum(arrests$z^2)
observed.sum.sq.resid
p + geom_vline(xintercept=observed.sum.sq.resid, col="red")

# This is the estimated overdispersion value.  It is much greater than 1.
est.overdispersion <- observed.sum.sq.resid/(n-k)
est.overdispersion

# To correct for overdispersion, we need to multiply all the standard errors
# in the regression output by
sqrt(est.overdispersion)

# We can do this automatically by fitting an "overdispersed Poisson" regression
# model.  We do this by setting the family in the glm call to quasipoisson,
# instead of poisson.
model3 <- glm(stops ~ eth + precinct, family=quasipoisson, data=arrests, offset=log(pop))
summary(model3)

# Compare the standard errors of the two ethnicity parameters to those from the
# overdispersed model.  By what factor are they changed?
summary(model2)
