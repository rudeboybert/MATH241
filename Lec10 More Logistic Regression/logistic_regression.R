library(ggplot2)
library(dplyr)
# Used for string manipulation:
library(stringr)


#------------------------------------------------
# Load Data & Preprocess It
#------------------------------------------------
profiles <- read.csv("profiles.csv", header=TRUE) %>% tbl_df()

# Split off the essays into a separate data.frame
essays <- select(profiles, contains("essay"))
profiles <- select(profiles, -contains("essay"))

# Look at our data
names(profiles)
glimpse(profiles)

# Because essays is of tbl_df() format, we can't see all the essays of the 9th
# individual.
essays[9, ]
# Use print.data.frame() to see all that person's essays
print.data.frame(essays[9, ])

# Define a binary outcome variable
# y_i = 1 if female
# y_i = 0 if male
profiles <- mutate(profiles, is.female = ifelse(sex=="f", 1, 0))

# Preview of things to come:  The variable "last online" includes the time.  We
# remove them by using the str_sub() function from the stringr package.  i.e.
# take the "sub-string" from position 1 to 10 of each string.  Then we convert
# them to dates.
profiles$last_online[1:10]
profiles$last_online <- str_sub(profiles$last_online, 1, 10) %>% as.Date()
profiles$last_online[1:10]

# Lastly we define a variable which counts the number of characters in the user's
# username.  We convert the
profiles$username.len <- profiles$username %>% as.character %>% nchar()





#------------------------------------------------
# Naive Model
#------------------------------------------------
# If you had to guess a user's sex via coin flips (i.e. using no information),
# where getting heads = declaring user is female, what should be the probability
# of heads?

#------------------
# Analysis:
#------------------
# -a) Means: Since the sample proportion = 40% of the observations are female
# (remember this is San Francisco), this should be the "probability that a
# randomly chosen person is female"
mean(profiles$is.female)


# -b) Regression, coefficients, and fitted values:  This situation is akin to
# fitting a regression with only an intercept.  This is done in R by setting the
# predictor variables to just "1" (the number one).  The command to run logistic
# regression is "glm" for "generalized linear model", where the family is set to
# "binomial" i.e. with have n independent trials of a Bernoulli random variable
# with probability p of success:
model0 <- glm(is.female ~ 1, data=profiles, family=binomial)
summary(model0)

# We apply the inverse logit formula to the intercept:
b.0 <- coefficients(model0)
1/(1+exp(-b.0))

# The inverse-logit of the intercept match the fitted values.  Compare to the
# mean from part a)
fitted(model0)
table(fitted(model0))


# -c) Plot:  Not useful when we don't have any predictors
p0 <- ggplot(data=profiles, aes(x=1, y=is.female)) + geom_point()
p0





#------------------------------------------------
# Search for words
#------------------------------------------------
# The following two functions allow us to search each row of a data.frame for
# a string.  (More when we cover text mining).
find.query <- function(char.vector, query){
  which.has.query <- grep(query, char.vector, ignore.case = TRUE)
  length(which.has.query) != 0
}
profile.has.query <- function(data.frame, query){
  query <- tolower(query)
  has.query <- apply(data.frame, 1, find.query, query=query)
  return(has.query)
}

# Search for the string "wine"
profiles$has.wine <- profile.has.query(data.frame = essays, query = "wine")
x <- table(profiles$has.wine)
x
# Quick and dirty barplot, w/o using ggplot
barplot(x, xlab="Has 'wine'?")

# Contingency table:
y <- table(profiles$sex, profiles$has.wine)
y
# mosaicplot.  What do the bar widths mean?
mosaicplot(y, xlab="sex", ylab="Has 'wine'?")

# Exercise:  Visualize the relationship between the presence of the word "wine"
# and the presence of the word "food" in users' profiles

# Solution
profiles$has.food <- profile.has.query(data.frame = essays, query = "food")
z <- table(profiles$has.food, profiles$has.wine)
z
mosaicplot(z, xlab="Has 'food'?", ylab="Has 'wine'?")


#------------------
# Analysis:
#------------------
# Let's do an analysis using the "has.wine" variable as a predictor

# -a) Means: in this case, the means are the sample proportions of the two groups:
# those with the word wine in their profile, and those without.
group_by(profiles, has.wine) %>% summarise(mean=mean(is.female))


# -b) Regression, coefficients, and fitted values: we now include the has.wine
# predictor variable
model1 <- glm(is.female ~ has.wine, data=profiles, family=binomial)
summary(model1)

# We apply the inverse logit formula to the two cases of the regression
# equation:  when the profile has wine, i.e. x=1, or when it doesn't, i.e. x=0
b.1 <- coefficients(model1)
b.1
1/(1+exp(-(b.1[1] + 0*b.1[2])))
1/(1+exp(-(b.1[1] + 1*b.1[2])))

# The inverse-logit of the two cases of the regression equation match the fitted
# values.  Compare to the means from part a)
table(fitted(model1))


# -c) Plot:  Not useful when we don't have any predictors
p1 <- ggplot(data=profiles, aes(x=has.wine, y=is.female)) + geom_point()
p1

# The above plot is useless, b/c we don't know how many points are superimposed
# on top of each other; so we first convert the TRUE/FALSE has.wine variable to
# a 0/1 numeric variable, then add a little jitter to both variables:
p1 <- ggplot(data=profiles,
             aes(x=jitter(as.numeric(has.wine)), y=jitter(is.female))) +
  geom_point() + xlab("has wine") + ylab("is female?")
p1





#------------------------------------------------
# Is height predictive of sex?
#------------------------------------------------
# Exercise:  Compare the heights of females and males using geom_histogram()

# Solution
ggplot(data=profiles, aes(x=height, y=..density..)) +
  geom_histogram() +
  facet_wrap(~sex, ncol=1) +
  xlim(c(50, 80))


#------------------
# Analysis:
#------------------
# -a) Means: Looking at the above histograms, the heights of the men are higher
group_by(profiles, is.female) %>% summarise(mean=mean(height), sd=sd(height))


# -b) Regression, coefficients, and fitted values
model2 <- glm(is.female ~ height, data=profiles, family=binomial)
summary(model2)

# We apply the inverse logit FUNCTION to the regression equation: now we have a
# numerical input x
b.2 <- coefficients(model2)
regression.line <- function(x, b){
  linear.equation <- b[1] + b[2]*x
  1/(1+exp(-linear.equation))
}

# Histogram of fitted p.hat's
qplot(fitted(model2)) + xlab("Fitted Probability of Being Female")


# -c) Plot:
p2 <- ggplot(data=profiles, aes(x=jitter(height), y=jitter(is.female))) +
  geom_point() + xlab("height") + ylab("is female")
p2

# We now add the regression line
p2 + stat_function(fun = regression.line, args=list(b=b.2), color="blue", size=2)





#------------------------------------------------
# Is the number of characters in one's username predictive of sex?
#------------------------------------------------
# Exercise:  Compare the number of characters used in the usernames of females
# and males using geom_bar()

# Solution:
library(scales)
values <- group_by(profiles, sex, username.len) %>%
  summarise(count=n()) %>%
  mutate(perc=count/sum(count))

ggplot(data=values, aes(x=as.factor(username.len), y=perc)) +
  geom_bar(stat="identity") +
  facet_wrap(~sex, nrow=1) +
  scale_y_continuous(labels = percent) +
  xlab("# of characters") + ylab("proportion")

# Alternatively, use density estimates
ggplot(data=profiles, aes(x=username.len, fill=sex)) + geom_density(alpha=.3)


#------------------
# Analysis:
#------------------
# -a) Means: Looking at the above histograms, the heights of the men are higher
group_by(profiles, is.female) %>% summarise(mean=mean(height), sd=sd(height))


# -b) Regression, coefficients, and fitted values
model3 <- glm(is.female ~ username.len, data=profiles, family=binomial)
summary(model3)

# We apply the inverse logit FUNCTION to the regression equation: now we have a
# numerical input x
b.3 <- coefficients(model3)

# Histogram of fitted p.hat's
qplot(fitted(model3)) + xlab("Fitted Probability of Being Female")


# -c) Plot:
p3 <- ggplot(data=profiles, aes(x=jitter(username.len), y=jitter(is.female))) +
  geom_point() + xlab("# of characters in username") +
  ylab("is female")
p3

# We now add the regression line
p3 + stat_function(fun = regression.line, args=list(b=b.3), color="blue", size=2)

# Although this looks like a straight line, its really a curved line.  Note we
# cannot actually extrapolate the model to values of x = 100, since there are no
# observations there
p3 + stat_function(fun = regression.line, args=list(b=b.3), color="blue", size=2) +
  xlim(c(0, 100))