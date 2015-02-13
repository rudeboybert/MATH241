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
# individual.  Use print.data.frame() to see all that person's essays
essays[9, ]
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
profiles$last_online <- str_sub(profiles$last_online, 1, 10) %>%
  as.Date()
profiles$last_online[1:10]



#------------------------------------------------
# Naive Model
#------------------------------------------------
# If you had to guess a user's sex via coin flips (i.e. using no information),
# where getting heads = declaring user is female, what should be the probability
# of heads?

####
model0 <- glm(is.female ~ 1, data=profiles, family=binomial)
summary(model0)
b <- coefficients(model0)
exp(b)/(1+exp(b))
table(fitted(model0))
####



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
barplot(x, xlab="Has 'wine'?")

y <- table(profiles$sex, profiles$has.wine)
y
mosaicplot(y, xlab="sex", ylab="Has 'wine'?")

# Exercise:  Visualize the relationship between the presence of the word "wine"
# and the presence of the word "food" in users' profiles

####
z <- table(profiles$has.food, profiles$has.wine)
z
mosaicplot(z, xlab="Has 'food'?", ylab="Has 'wine'?")
####



group_by(profiles, has.wine) %>% summarise(mean(is.female))
group_by(profiles, is.female) %>% summarise(mean(has.wine))


count(profiles, sex, has.wine) %>%
  ggplot(data=., aes(x=sex, y=n, fill=has.wine)) +
  geom_bar(stat="identity", position="fill") +
  ylab("Proportion")







model1 <- glm(is.female ~ has.wine, data=profiles, family=binomial)
summary(model1)
b <- coefficients(model1)
b
exp(b[1])/(1+exp(b[1]))
exp(b[1] + b[2])/(1+exp(b[1] + b[2]))

table(fitted(model1))
table(profiles$is.female, fitted(model1) > 0.5)






#------------------------------------------------
# Height
#------------------------------------------------
# Exercise:
ggplot(data=profiles, aes(x=height, y=..density..)) +
  geom_histogram() +
  facet_wrap(~sex, ncol=1) + xlim(c(50, 80))


# Exercise
# Plot the binary variable is.female over height (i.e.)



model2 <- glm(is.female ~ height, data=profiles, family=binomial)
summary(model2)
b <- coefficients(model2)
b
qplot(fitted(model2)) + xlab("Fitted Probability of Being Female")

regression.line <- function(x){
  exp(b[1] + b[2]*x)/(1+exp(b[1] + b[2]*x))
}

p <-
  ggplot(profiles,
         aes(x=jitter(height), y=jitter(is.female, factor=0.5))
         )

p + geom_point() +
  ylab("Prob(Female)") +
  xlab("height") +
  xlim(c(50, 80)) #+
  #stat_function(fun = regression.line, color="blue", size=2)








#------------------------------------------------
# Changing Levels of a Factor
#------------------------------------------------
# levels(profiles$smokes)
# levels(profiles$smokes) <- c("", "no", "yes", "yes", "yes", "yes")
# mosaicplot(table(profiles$sex, profiles$smokes))
