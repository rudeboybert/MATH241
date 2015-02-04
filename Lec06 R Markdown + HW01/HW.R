state.means <- left_join(state.means, state.info, by="state")
state.means

# Now we replot the plot from above, but with the fill aesthetic set to "region"
ggplot(data=state.means, aes(x=state, y=ave_no_need_grant, fill=region)) +
  geom_bar(stat="identity") +
  ylab("avg no need grant")






# We join the state.means data and the map_data corresponding to states
state.data <- map_data("state") %>%
  inner_join(state.means, by=c("region" = "fullname")) %>%
  tbl_df()
state.data

# What do you think the grey values mean? Note:  the "\n" is the "return"
# character
ggplot(state.data, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = ave_no_need_grant)) +
  geom_path(color="white") +
  scale_fill_gradient(name="Avg. No\nNeed Grant", low='white', high='red')




#------------------------------------------------------------------------------
# Using the join command
#------------------------------------------------------------------------------
flights <- read.csv("flights.csv", stringsAsFactors = FALSE) %>%
  tbl_df() %>%
  mutate(date=as.Date(date))
weather <- read.csv("weather.csv", stringsAsFactors = FALSE) %>%
  tbl_df() %>%
  mutate(date=as.Date(date))
planes <- read.csv("planes.csv", stringsAsFactors = FALSE) %>% tbl_df()
airports <- read.csv("airports.csv", stringsAsFactors = FALSE) %>% tbl_df()





