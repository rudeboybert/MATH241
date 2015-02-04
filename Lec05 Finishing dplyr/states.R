# Define matrix of states, state abbreviation, and region
south <- c('AL', 'AR', 'FL', 'GA', 'KY', 'LA', 'NC', 'SC', 'TN', 'TX', 'OK', 'MS', 'WV', 'VA')
NE <- c('CT', 'DE', 'MA', 'MD', 'ME', 'NH', 'NJ', 'NY', 'PA', 'RI', 'VT')
midwest <- c('ND', 'SD', 'NE', 'KS', 'MN', 'IA', 'MO', 'IL', 'MI', 'IN', 'OH', 'WI')
west <- c('WA', 'OR', 'ID', 'MT', 'WY', 'CO', 'NM', 'AZ', 'CA', 'NV', 'UT')

states <- data.frame(
  state = c(south, NE, midwest, west),
  region = c(
    rep("south", length(south)),
    rep("NE", length(NE)),
    rep("midwest", length(midwest)),
    rep("west", length(west))
  )
) %>% arrange(state) %>%
  mutate(fullname=state.name[match(state, state.abb)]) %>%
  mutate(fullname=tolower(fullname)) %>%
  select(state, fullname, region)

write.csv(states, row.names=FALSE, file="states.csv")
write.csv(states, row.names=FALSE, file="./Lec05 Finishing dplyr/states.csv")
