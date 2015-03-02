#-------------------------------------------------------------------------------
#
# Regression
#
#-------------------------------------------------------------------------------
library(dplyr)
library(RCurl) # to use getURL() command to read tables off the web



#---------------------------------------------------------------
# Hypothetical Model Formulas in General
#---------------------------------------------------------------
# Regressions are based on "model formulas" of the form:
# response ~ termA + termB + ...
# Say your data is saved in variable "values":

# The above is fit as
lm(response ~ termA + termB + ..., data = values)

# Fitting just an intercept to response
lm(response ~ 1, data = values)

# Fitting the interaction term between termA and termB as well as termA and
# termB individually
lm(response ~ termA * termB, data = values)

# If termA is technically a categorical variable but is coded with numerical
# values, we can convert it to be categorical via as.factor() or factor()
lm(response ~ factor(termA) + termB, data = values)




#---------------------------------------------------------------
# Regression Objects
#---------------------------------------------------------------
# Any regression can be saved to a variable AKA a regression "object". We
# present all the regression types we've seen where in each case we assign the
# regression to an object called "model".  Run which ever regression you're
# interested in, and then proceed to the section "Functions on Regression
# Objects"

#------------------------------------------------
# 1. Multiple Linear Regression
#------------------------------------------------
# Data:  House prices in Ames IA
ames <- read.csv("http://www.openintro.org/stat/data/ames.csv", header=TRUE)

# Regular linear regression uses the lm() command
model <- lm(SalePrice ~ Year.Built + Yr.Sold, data = ames)

#------------------------------------------------
# 2. Logistic Regression
#------------------------------------------------
# Data: admissions to graduate school data, where rank indicates the prestige of
# the undergraduate institution.
admissions <- read.csv("http://www.ats.ucla.edu/stat/data/binary.csv")

# Logistic regression requires the glm() or "generalized linear model" command
# where we set family=binomial
model <- glm(admit ~ gre + gpa + factor(rank), family = binomial, data = admissions)

#------------------------------------------------
# Poisson Regression
#------------------------------------------------
# Data: Stop and Frisk Data
url <- "https://raw.githubusercontent.com/rudeboybert/MATH241/master/Lec13%20More%20Poisson%20Regression/frisk_with_noise.txt"
arrests <- read.table(text=getURL(url), header=TRUE)

# For poisson regression, we use glm() instead of lm() again, but now we
# * set family=poisson
# * if desired, set an offset term based on log(exposure)
model <- glm(stops ~ eth + precinct, family=poisson, offset=log(pop), data=arrests)

#------------------------------------------------
# Quasipoisson Regression with Correction for Overdispersion
#------------------------------------------------
# For quasipoisson regression, we set family=quasipoisson.  If you look at the
# summary() for this model, you can get the overdispersion factor.  We
# explicitly computed this in Lecture 14.
model <- glm(stops ~ eth + precinct, family=quasipoisson, offset=log(pop), data=arrests)




#---------------------------------------------------------------
# Functions on Regression Objects
#---------------------------------------------------------------
# These functions work on any kind of regression object:

# Overall summary of regression
summary(model)

# Estimated coefficients beta.hat of regression equation
coefficients(model)

# Confidence intervals for regression coefficients
confint(model)

# Extra: standard errors for regression coefficients
vcov(model) %>% diag() %>% sqrt()

# Fitted values y.hat
fitted(model)

# Fit values of linear equation beta0.hat + beta1.hat * x1 + beta2.hat * x2 + ...
# Note for linear regression predict() returns the same values as fitted(), but
# for logistic and poisson regression since we need to transform the linear
# equation to convert to the outcome units of interest
predict(model)
