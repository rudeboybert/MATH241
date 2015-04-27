library(dplyr)
library(ggplot2)

dataset <- read.csv("dataset.csv", header = TRUE) %>% tbl_df()

# For each group, do the following:
# -Compute the means and sd's for both x and y
# -Compute the correlation coefficient between x and y using the cor() function
# -Get the coefficients of the linear regression y~x.

group_by(dataset, group) %>%
  summarise_each(funs(mean,var))

group_by(dataset, group) %>%
  summarise(cor=cor(x,y))

for(i in 1:4){
  filter(dataset, group==i) %>% lm(y~x, data=.) %>% coef() %>% print()
}

# Plot the data!
ggplot(dataset, aes(x=x, y=y)) +
  geom_point(size=3) +
  geom_smooth(method="lm", se=FALSE) +
  facet_wrap(~group, nrow=2)




adriana <- read.csv("./adriana/adriana_data.csv", header=TRUE) %>% tbl_df()

ggplot(adriana, aes(x=Sample, y=nmoles.mL)) +
  geom_boxplot() +
  facet_wrap(~Set.ID)

ggplot(adriana, aes(x=Sample, y=nmoles.mL)) +
  geom_point() +
  facet_wrap(~Set.ID)

ggplot(adriana, aes(x=Sample, y=nmoles.mL)) +
  geom_point() +
  facet_wrap(~Set.ID) +
  scale_y_log10()






