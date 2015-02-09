library(dplyr)
library(ggplot2)

# This package allows us to read .dta STATA files into R
library(foreign)

# Load child IQ data from Gelman.  Recall tbl_df() changes the data frame so
# that not all rows show when we print its contents
url <- "http://www.stat.columbia.edu/~gelman/arm/examples/child.iq/kidiq.dta"
kid.iq <- read.dta(url) %>% tbl_df()
kid.iq



#------------------------------------------------
# Model 0: Just the average
#------------------------------------------------
ybar <- mean(kid.iq$kid_score)
ybar

qplot(x=kid.iq$kid_score) +
  geom_vline(xintercept=ybar, col="red", size=1)



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
p <- ggplot(kid.iq, aes(x=as.factor(mom_hs), y=kid_score)) + geom_point()
p
# Now add horizontal lines corresponding to the means.  Note the [[2]] says
# extract the second column
p + geom_hline(yintercept=means[[2]], linetype=c("dashed", "solid"))

# This is how we fit a linear (regression) model in R:
model1 <- lm(kid_score ~ mom_hs, data=kid.iq)
model1

# The last output isn't so helpful; here is the full regression table.  Compare
# the table to the means data frame above
summary(model1)

# Diagnostics plots to check assumptions.  Hit enter from the console to scroll
plot(model1)

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
b <- coefficients(model2)
b

# We plot the regression line by extracting the intercept and slope:
p + geom_abline(intercept=b[1], slope=b[2], col="blue")

# We can do this quick via geom_smooth()
p + geom_smooth(method="lm")



#------------------------------------------------
# Model 3 & 4: Include mom's IQ and high
#------------------------------------------------
ggplot(kid.iq, aes(x=mom_iq, y=kid_score, color=mom_hs)) +
  geom_point()

# Note we have the multiple colors b/c R is treating mom_hs as a numerical
# variable, when really it is a categorical variable.  So we convert it to a
# categorical variable via factor() or as.factor()
p <- ggplot(kid.iq, aes(x=mom_iq, y=kid_score, color=factor(mom_hs))) +
  geom_point()
p

# Now let's add some regression lines.  Notice anything?
p + geom_smooth(method="lm")

# We fit the first model assuming an intercept shift, or just the additive effect
# of a mom having completed high school
model3 <- lm(kid_score ~ mom_iq + mom_hs, data=kid.iq)
summary(model3)
b <- coefficients(model3)
b

# Plot these lines
p + geom_abline(intercept=b[1], slope=b[2], col="#F8766D", size=1) +
  geom_abline(intercept=b[1]+b[3], slope=b[2], col="#00BFC4", size=1)

# We now assume an interaction model using the * command:
model4 <- lm(kid_score ~ mom_iq*mom_hs, data=kid.iq)
summary(model4)
b <- coefficients(model4)
b

p + geom_abline(intercept=b[1], slope=b[2], col="#F8766D", size=1) +
  geom_abline(intercept=b[1]+b[3], slope=b[2]+b[4], col="#00BFC4", size=1)

# We can once again to this quick using geom_smooth()
p + geom_smooth(method="lm")
p + geom_smooth(method="lm", se=FALSE)
p + geom_smooth(method="lm") + xlim(0, 140)
p + geom_smooth(method="lm", fullrange=TRUE) + xlim(0, 140)



#------------------------------------------------
# Extra Stuff: How did I get ggplot's default colors #F8766D and #00BFC4?
#------------------------------------------------
# Using this function, you can pick off colors from the color wheel below.
gg_color_hue <- function(n) {
  hues = seq(15, 375, length=n+1)
  hcl(h=hues, l=65, c=100)[1:n]
}

# For example for the plots above we had two cases, so we set n=2
gg_color_hue(n=2)

# Create color wheel
r  <- seq(0,1,length=201)
th <- seq(0,2*pi, length=201)
d  <- expand.grid(r=r,th=th)
gg <- with(d,data.frame(d,x=r*sin(th),y=r*cos(th),
                        z=hcl(h=360*th/(2*pi),c=100*r, l=65)))
ggplot(gg) +
  geom_point(aes(x,y, color=z), size=3)+
  scale_color_identity()+labs(x="",y="") +
  coord_fixed()
