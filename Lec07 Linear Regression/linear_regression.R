# Linear Regression
# Reference:  Chapter 3 of "Data analysis using regression and
# multilevel/hierarchical models" by Gelman and Hill
# Note all code/data from this book can be found at
# http://www.stat.columbia.edu/~gelman/arm
library(dplyr)
library(ggplot2)

# This package allows us to read .dta STATA files into R via read.dta()
library(foreign)

# Load child data from Gelman:  predicting cognitive test scores of 3-4 year old
# children given characteristics of their mothers, using data from the National
# Longitudinal Survey of Youth.
# Recall tbl_df() changes the data frame so that not all rows show when we print
# its contents
url <- "http://www.stat.columbia.edu/~gelman/arm/examples/child.iq/kidiq.dta"
kid.iq <- read.dta(url) %>% tbl_df()
kid.iq



#------------------------------------------------
# Model 0: Just the average
#------------------------------------------------
p <- qplot(data=kid.iq, x=kid_score)
p

ybar <- mean(kid.iq$kid_score)
p + geom_vline(xintercept=ybar, col="red", size=1)



#------------------------------------------------
# Model 1: Include mom's high school information
#------------------------------------------------
means <- group_by(kid.iq, mom_hs) %>%
  summarise(mean=mean(kid_score))
means

# Note we make mom_hs a categorical variable by as.factor() or factor()'ing it
ggplot(kid.iq, aes(x=as.factor(mom_hs), y=kid_score)) + geom_boxplot()
ggplot(kid.iq, aes(x=kid_score, y=..density..)) + geom_histogram() +
  facet_wrap(~ mom_hs, ncol=1)

p <- ggplot(kid.iq, aes(x=as.factor(mom_hs), y=kid_score, color=as.factor(mom_hs))) + geom_point()
p
# Now add horizontal lines corresponding to the means.  Note the [[2]] says
# extract the second column
p + geom_hline(yintercept=means[[2]], color=c("#F8766D", "#00BFC4"), size=1)

# This is how we fit a linear (regression) model in R:
model1 <- lm(kid_score ~ mom_hs, data=kid.iq)
model1
# The last output isn't so helpful; here is the full regression table.  Compare
# the table to the means data frame above
summary(model1)

# Other useful functions
coefficients(model1)
confint(model1)
fitted(model1) # the fitted yhat values
resid(model1) # the residuals


#------------------------------------------------
# Model 2: Include mom's IQ
#------------------------------------------------
p <- ggplot(kid.iq, aes(x=mom_iq, y=kid_score)) + geom_point()
p

model2 <- lm(kid_score ~ mom_iq, data=kid.iq)
summary(model2)

# We plot the regression line by extracting the intercept and slope using square
# brackets:
b <- coefficients(model2)
b
p + geom_abline(intercept=b[1], slope=b[2], col="blue", size=1)

# We can do this quick via geom_smooth()
p + geom_smooth(method="lm", size=1, level=0.95)



#------------------------------------------------
# Model 3: Include BOTH mom's IQ and high
#------------------------------------------------
ggplot(kid.iq, aes(x=mom_iq, y=kid_score, color=mom_hs)) + geom_point()

# Note we have the multiple colors b/c R is treating mom_hs as a numerical
# variable, when really it is a categorical variable.  So we convert it to a
# categorical variable via factor() or as.factor()
p <- ggplot(kid.iq, aes(x=mom_iq, y=kid_score, color=factor(mom_hs))) +
  geom_point(size=3)
p


# Model 3.a) We fit the first model assuming an intercept shift, or just the
# additive effect of a mom having completed high school
model3a <- lm(kid_score ~ mom_iq + mom_hs, data=kid.iq)
summary(model3a)

# Plot these lines
b <- coefficients(model3a)
b
p + geom_abline(intercept=b[1], slope=b[2], col="#F8766D", size=1) +
  geom_abline(intercept=b[1]+b[3], slope=b[2], col="#00BFC4", size=1)


# Model 3.b) we now assume an interaction model using the * command:
model3b <- lm(kid_score ~ mom_iq*mom_hs, data=kid.iq)
summary(model3b)

# Plot these lines
b <- coefficients(model3b)
b
p + geom_abline(intercept=b[1], slope=b[2], col="#F8766D", size=1) +
  geom_abline(intercept=b[1]+b[3], slope=b[2]+b[4], col="#00BFC4", size=1)

# We can once again to this quick using geom_smooth()
p + geom_smooth(method="lm")
p + geom_smooth(method="lm", se=FALSE)
p + geom_smooth(method="lm") + xlim(0, 140)
p + geom_smooth(method="lm", fullrange=TRUE) + xlim(0, 140)



#------------------------------------------------
# Model 4: Multilevel Factor
#------------------------------------------------
# On page 67 of Gelman, they explain the mom_work categorial variable:
# mom_work = 1: mother did not work in the first three years of child's life
# mom_work = 2: mother worked in second or third year of child's life
# mom_work = 3: mother worked part-time in first year of child's life
# mom_work = 4: mother worked full-time in first year of child's life
p <- ggplot(kid.iq, aes(x=mom_iq, y=kid_score, color=as.factor(mom_work))) + geom_point(size=3)
p

model4 <- lm(kid_score ~ mom_work + mom_iq, data=kid.iq)
summary(model4)

model4 <- lm(kid_score ~ as.factor(mom_work) + mom_iq, data=kid.iq)
summary(model4)

# Plot these lines
b <- coefficients(model4)
b
p + geom_abline(intercept=b[1], slope=b[5], col="#F8766D", size=1) +
  geom_abline(intercept=b[1]+b[2], slope=b[5], col="#7CAE00", size=1) +
  geom_abline(intercept=b[1]+b[3], slope=b[5], col="#00BFC4", size=1) +
  geom_abline(intercept=b[1]+b[4], slope=b[5], col="#C77CFF", size=1)



#------------------------------------------------
# Model 5: Standardizing predictors
#------------------------------------------------
# Recall model 2
p <- ggplot(kid.iq, aes(x=mom_iq, y=kid_score)) + geom_point()
p + geom_smooth(method="lm", se=FALSE)
p + geom_smooth(method="lm", se=FALSE, fullrange=TRUE) + xlim(c(0, 140))

model2 <- lm(kid_score ~ mom_iq, data=kid.iq)
summary(model2)


# The intercept is meaningless since no mothers have IQ = 0.  What we can do is
# "standardize" the predictor so its centered at 0 and has SD = 1.
kid.iq <- mutate(kid.iq, z_mom_iq = (mom_iq - mean(mom_iq))/sd(mom_iq))
p <- ggplot(kid.iq, aes(x=z_mom_iq, y=kid_score)) + geom_point()
p

model5 <- lm(kid_score ~ z_mom_iq, data=kid.iq)
summary(model5)

# Compare the two table's
# -Residual standard error
# -R-squared
# -slope parameter



url <- "http://www.stat.columbia.edu/~gelman/arm/examples/earnings/heights.dta"
heights <- read.dta(url) %>% tbl_df()

heights <- filter(heights, earn !=0 & !is.na(height) & !is.na(earn)) %>%
  mutate(log_earn=log(earn))

model6 <- lm(log_earn~height, data=heights)
summary(model6)

p <- ggplot(data=heights, aes(x=height, y=earn)) + geom_point()
p
p <- ggplot(data=heights, aes(x=height, y=log_earn)) + geom_point()
p + geom_smooth(method="lm")

b <- coefficients(model6)
b


p <- ggplot(data=heights, aes(x=height, y=earn)) + geom_point()
p
test <- function(x) {exp(b[1] + b[2]*x)}
p + stat_function(fun = test, color="blue") + xlim(c(55, 90))




