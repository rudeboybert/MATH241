library(dplyr)
library(ggplot2)
library(foreign)
# Reference:  Chapter 3 and 4 of "Data analysis using regression and
# multilevel/hierarchical models" by Gelman and Hill
url <- "http://www.stat.columbia.edu/~gelman/arm/examples/child.iq/kidiq.dta"
kid.iq <- read.dta(url) %>% tbl_df()
kid.iq



#------------------------------------------------
# Side Note: How did I get ggplot's default colors #F8766D and #00BFC4?
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



#------------------------------------------------
# Model 3: Continued
#------------------------------------------------
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

# The above treats mom_work as a numerical variable and not a categorical one
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
model2 <- lm(kid_score ~ mom_iq, data=kid.iq)
summary(model2)

# The intercept is meaningless since no mothers have IQ = 0.
p <- ggplot(kid.iq, aes(x=mom_iq, y=kid_score)) + geom_point()
p + geom_smooth(method="lm", se=FALSE, fullrange=TRUE) + xlim(c(0, 140))

# What we can do is "standardize" the predictor so its centered at 0 and has
# SD = 1.
kid.iq <- mutate(kid.iq, z_mom_iq = (mom_iq - mean(mom_iq))/sd(mom_iq)) %>%
  ggplot(data=., aes(x=z_mom_iq, y=kid_score)) + geom_point()

model5 <- lm(kid_score ~ z_mom_iq, data=kid.iq)
summary(model5)

# Compare model2 and model5's:
# -Residual standard error
# -R-squared
# -slope parameter



#------------------------------------------------
# Example of regression on logged outcome variable
#------------------------------------------------
url <- "http://www.stat.columbia.edu/~gelman/arm/examples/earnings/heights.dta"

# Filter out observations with earnings=0 and missing data
heights <- read.dta(url) %>%
  tbl_df() %>%
  filter(earn !=0 & !is.na(height) & !is.na(earn))
heights

# The earnings are very right-skewed
qplot(data=heights, x=earn)

# So we log the earnings
heights <- mutate(heights, log_earn=log(earn))
qplot(data=heights, x=log_earn)

# We fit a regression to this model
model6 <- lm(log_earn~height, data=heights)
summary(model6)
b <- coefficients(model6)
b

# This is what the data/regression looks like on the log-scale
ggplot(data=heights, aes(x=height, y=log_earn)) +
  geom_point() +
  xlab("height") +
  ylab("log of earnings") +
  geom_smooth(method="lm")

# On the original scale we need to exp() the regression line
p <- ggplot(data=heights, aes(x=height, y=earn)) + geom_point()
p

regression.line <- function(x){
  exp(b[1] + b[2]*x)
}

p + stat_function(fun = regression.line, color="blue")
p + stat_function(fun = regression.line, color="blue") + xlim(c(55, 90))

