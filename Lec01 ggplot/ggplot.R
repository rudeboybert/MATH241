# Install the ggplot package
install.packages("ggplot2")

# Load the package
library(ggplot2)

# We will consider the diamonds data set
data(diamonds)
head(diamonds)
?diamonds
n <- nrow(diamonds)
n

# Since the diamonds data set is too big, let's only consider a randomly chosen
# sample of 500 of these points:
set.seed(76)
samp <- sample(1:n, size = 500)
diamonds <- diamonds[samp,]


# We build up the plot incrementally from the base:
# -data: is the data considered
# -aes() is the function that maps variables to aesthetics
ggplot(data=diamonds, aes(x = carat, y = price))

# Nothing shows. We need a geometry: points.  We add it with a + sign
ggplot(data=diamonds, aes(x = carat, y = price)) +
  geom_point()

# Look at the help file for geom_point(), in particular the aesthetics it
# understands
?geom_point

# The default value (i.e. if you don't set it to anything) for the "color"
# aesthetic is black.  Let's map the "cut" variable to color
ggplot(data=diamonds, aes(x = carat, y = price, colour = cut)) +
  geom_point()


# scale: put the y-axis on a log-scale
ggplot(data=diamonds, aes(x = carat, y = price, colour = cut)) +
  geom_point() +
  scale_y_log10()


# facet: break down the plot by cut
ggplot(data=diamonds, aes(x = carat, y = price, colour = cut)) +
  geom_point() +
  scale_y_log10() +
  facet_wrap(~cut, nrow=2)


# extra: add title
ggplot(data=diamonds, aes(x = carat, y = price, colour = cut)) +
  geom_point() +
  scale_y_log10() +
  facet_wrap(~cut, nrow=2) +
  ggtitle("First example")


# Note all the above could've been added incrementally to a variable
p <- ggplot(data=diamonds, aes(x = carat, y = price, colour = cut))
p <- p + geom_point()
p <- p + scale_y_log10()
p <- p + facet_wrap(~cut, nrow=2)
p <- p + ggtitle("First example")
p


# Exercise:  Create a plot that shows once again the relationship between carat,
# but now let the size of the points reflect the table of the diamond and have
# separate plots by clarity


# Exercise:  A friend wants to know if cars in 1973-1974 that have bigger
# cylinders (in cu. in.) have better mileage (in mpg).  Two important factors
# they want to consider are the # of cylinders and whether the car has an
# automatic or manual transmission.  Answer your friend's question using a
# visualization. As added bonus, use google to add detailed x-labels and
# y-labels
data(mtcars)
?mtcars