library(ggplot2)
library(dplyr)
# Used for string manipulation:
library(stringr)
# User for ROC Curves:
install.packages("ROCR", repos="http://cran.rstudio.com/")
library(ROCR)

#------------------------------------------------
# Load Data & Preprocess It (Same as Previous)
#------------------------------------------------
profiles <- read.csv("profiles.csv", header=TRUE) %>% tbl_df()

# Split off the essays into a separate data.frame
essays <- select(profiles, contains("essay"))
profiles <- select(profiles, -contains("essay"))

# Define a binary outcome variable
# y_i = 1 if female
# y_i = 0 if male
profiles <- mutate(profiles, is.female = ifelse(sex=="f", 1, 0))

# Preview of things to come:  The variable "last online" includes the time.  We
# remove them by using the str_sub() function from the stringr package.  i.e.
# take the "sub-string" from position 1 to 10 of each string.  Then we convert
# them to dates.
profiles$last_online <- str_sub(profiles$last_online, 1, 10) %>% as.Date()

# Lastly we define a variable which counts the number of characters in the user's
# username.  We convert the
profiles$username.len <- profiles$username %>% as.character %>% nchar()





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

# Fit model
model1 <- glm(is.female ~ has.wine, data=profiles, family=binomial)
summary(model1)
b1 <- coefficients(model1)

# What does the slope coefficient 0.69742 mean?
b1[2]
exp(b1[2])

# We introduce the lag() function.  It let's you access a "lagged" version of a
# vector.  Try the following in the console: lag(c(1, 2, 3, 4, 5, 6))

# Recall the interpretation of the coefficient in terms of the factor increase
# in the odds of being female:
mutate(profiles, phat = fitted(model1)) %>%
  select(has.wine, phat) %>%
  distinct() %>%
  mutate(odds = phat/(1-phat)) %>%
  mutate(odds.previous = lag(odds)) %>%
  mutate(factor.increase=odds/odds.previous) %>%
  print.data.frame()

exp(b1[2])





#------------------------------------------------
# Is height predictive of sex?
#------------------------------------------------
# Fit Model
model2 <- glm(is.female ~ height, data=profiles, family=binomial)
summary(model2)
b2 <- coefficients(model2)

# What does the slope coefficient -0.6528102 mean?
b2[2]
exp(b2[2])

mutate(profiles, phat = fitted(model2)) %>%
  select(height, phat) %>%
  distinct() %>%
  arrange(height) %>%
  mutate(odds = phat/(1-phat)) %>%
  mutate(odds.previous = lag(odds)) %>%
  mutate(factor.increase=odds/odds.previous)

exp(b2[2])


#------------------------------------------------
# Is the number of characters in one's username predictive of sex?
#------------------------------------------------
# Fit Model
model3 <- glm(is.female ~ username.len, data=profiles, family=binomial)
summary(model3)
b3 <- coefficients(model3)

# What does the slope coefficient 0.05400784 mean?
b3[2]
exp(b3[2])

mutate(profiles, phat = fitted(model3)) %>%
  select(username.len, phat) %>%
  arrange(username.len) %>%
  distinct() %>%
  mutate(odds = phat/(1-phat)) %>%
  mutate(odds.previous = lag(odds)) %>%
  mutate(factor.increase=odds/odds.previous)

exp(b3[2])





#------------------------------------------------
# Measure of model fit:  ROC Curves
#------------------------------------------------
# Model2, using height as a predictor, looked pretty good at predicting sex.
# Let's see the fitted probabilities:
p <- qplot(fitted(model2)) + xlab("Fitted p.hat")
p

# What "threshold" on the probabilities do we use to declare someone is female?
# How about 50%?
threshold <- 0.5
p + geom_vline(xintercept=threshold, col="red", size=2)

# Using this threshold, we make an explicit prediction of whether the individual
# was female or not, if the fitted probability exceeds the threshold
predictions <-
  select(profiles, is.female) %>%
  mutate(phat=fitted(model2)) %>%
  mutate(predicted.female=ifelse(phat > threshold, 1, 0))
predictions

# We now compare our predictions with the truth:  the is.female variable.  We see
# we make two kinds of errors:
# -Predicting someone is female when they're not
# -Prediction someone is not female when the are
count(predictions, is.female, predicted.female)

# We use the table() command to view this in a contigency table
performance <- table(truth=predictions$is.female, predicted=predictions$predicted.female)
performance
mosaicplot(performance, main="Truth vs Predicted")

# We see we had a
# -False Postive Rate = 559/(559+3028) = 15.6%
# -True Postive Rate = 1932/(1932+476) = 80.2%
FPR <- 559/(559+3028)
TPR <- 1932/(1932+476)

#------------------------------------------------
# EXERCISE:  Repeat the above for a more "strict" threshold i.e. We only want to
# declare someone female if we're more certain.  How does this new threshold
# impact our False and True Positive rates?
#------------------------------------------------





#------------------------------------------------
# ROC Curves
#------------------------------------------------
# Function for creating ROC curves.  Don't fuss too much as how this works:  I
# just ripped it off google.
ROC.curve <- function(probs, truth){
  pred <- prediction(probs, truth)
  perf <- performance(pred, "tpr", "fpr")
  plot(perf, col="black", lty=3, lwd=3)
  auc <- unlist(slot(performance(pred,"auc"), "y.values"))
  title(paste("AUC = ", round(auc,3)))
  abline(c(0,1))
}

# The area under the curve is very high!
ROC.curve(predictions$phat, predictions$is.female)

# The FPR and TPR for each threshold corresponds to a point on the curve
points(FPR, TPR, pch=19, cex=2)


#------------------------------------------------
# EXERCISE:  Plot the point corresponding to
# -Your more strict threshold from above
# -the threshold where we want a False Positive Rate of 0%
# -the threshold where we want a True Positive Rate of 100%
#
# Draw the ROC curve when using username.len as the predictor
#------------------------------------------------







