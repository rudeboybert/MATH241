library(dplyr)
library(ggplot2)

anscombe <- read.csv("anscombe.csv", header = TRUE) %>% tbl_df()

# For each group, do the following:
# -Compute the means and sd's for both x and y
# -Compute the correlation coefficient between x and y using the cor() function
# -Get the coefficients of the linear regression y~x.

group_by(anscombe, group) %>%
  summarise_each(funs(mean,var))

group_by(anscombe, group) %>%
  summarise(cor=cor(x,y))

for(i in 1:4){
  filter(anscombe, group==1) %>% lm(y~x, data=.) %>% coef() %>% print()
}

ggplot(anscombe, aes(x=x, y=y)) +
  geom_point(size=3) +
  geom_smooth(method="lm", se=FALSE) +
  facet_wrap(~group, nrow=2)















adriana <- read.csv("adriana_data.csv", header=TRUE) %>% tbl_df()
adriana

adriana %>% select(Set.ID, Sample, nmoles.mL) %>%
  count(Set.ID, Sample) %>%
  ungroup() %>%
  arrange(desc(n)) %>%
  as.data.frame()



ggplot(adriana, aes(x=Sample, y=nmoles.mL)) +
  geom_point() +
  facet_wrap(~Set.ID) +
  scale_y_log10()
