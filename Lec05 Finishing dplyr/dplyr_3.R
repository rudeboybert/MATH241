# Run all code from dplyr_2


# talk about joins
# talk about choloropleth

# Answering question:
#
# Using the wp_data data frame, create a new data frame called state_means with
# two variables:
# 1) state: the state's abbreviation
# 2) ave_no_need_grant: the state's average no need grant, averaged over schools
# where the entire data frame is sorted in descending order of average no need
# grant.
state_means <-
  wp_data %>%
  select(state, ave_no_need_grant) %>%
  group_by(state) %>%
  summarise_each(funs(mean)) %>%
  arrange(desc(ave_no_need_grant))



# R has state names and abbreviations built in.  Add a variable state_name with
# these
state.abb
state.name

state_means$state_name <-
  match(state_means$state, state.abb) %>%
  state.name[.] %>%
  tolower()

# Get geographic coordinates of each state
state_coord <- map_data("state") %>% tbl_df() %>% rename(state_name=region)



choropleth <- left_join(state_coord, state_means) %>% tbl_df() %>% arrange(order)



# Define color pal
my.cols <- brewer.pal(8, "Greens")

# Create cuts for % no need grants
choropleth$ave_no_need_grant_d <- cut(choropleth$ave_no_need_grant, breaks = c(seq(0, 25000, by = 3125)))

# Create map
ggplot(data=choropleth, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = ave_no_need_grant_d)) +
  geom_path(color="white") +
  scale_fill_manual("Avg. No\n Need Grant", values = my.cols, guide = "legend") +
  theme_classic()
