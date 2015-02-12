library(ggplot2)
library(dplyr)

profiles <- read.csv("profiles.csv", header=TRUE) %>% tbl_df()

# Split off the essays into a separate data.frame
essays <- select(profiles, contains("essay"))
profiles <- select(profiles, -contains("essay"))


levels(profiles$smokes)
levels(profiles$smokes) <- c("", "no", "yes", "yes", "yes", "yes")
mosaicplot(table(profiles$sex, profiles$smokes))




# Set binary outcome
profiles <- mutate(profiles, is.female = ifelse(sex=="f", 1, 0))
mean(profiles$is.female)


model0 <- glm(is.female ~ 1, data=profiles, family=binomial)
summary(model0)
b <- coefficients(model0)
exp(b)/(1+exp(b))
table(fitted(model0))








#------------------------------------------------
# Search for words
#------------------------------------------------
find.query <- function(char.vector, query){
  which.has.query <- grep(query, char.vector, ignore.case = TRUE)
  length(which.has.query) != 0
}
profile.has.query <- function(data.frame, query){
  query <- tolower(query)
  has.query <- apply(data.frame, 1, find.query, query=query)
  return(has.query)
}


profiles$has.wine <- profile.has.query(essays, "wine")
table(profiles$sex, profiles$has.wine)

group_by(profiles, has.wine) %>% summarise(mean(is.female))


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
ggplot(data=profiles, aes(x=height, y=..density..)) +
  geom_histogram() +
  facet_wrap(~sex, ncol=1) + xlim(c(50, 80))

model2 <- glm(is.female ~ height, data=profiles, family=binomial)
summary(model2)
b <- coefficients(model2)
b
qplot(fitted(model2)) + xlab("Fitted Probability of Being Female")




