pollution <- structure(
  list(city = c("New York", "New York", "London", "London", "Beijing", "Beijing"),
       size = c("large", "small", "large", "small", "large", "small"),
       amount = c(23, 14, 22, 16, 121, 56)),
  .Names = c("city", "size", "amount"),
  row.names = c(NA, -6L),
  class = "data.frame")

cases <- structure(
  list(country = c("FR", "DE", "US"),
       `2011` = c(7000, 5800, 15000),
       `2012` = c(6900, 6000, 14000),
       `2013` = c(7000, 6200, 13000)),
  .Names = c("country", "2011", "2012", "2013"),
  row.names = c(NA, -3L),
  class = "data.frame")

storms <- structure(
  list(storm = c("Alberto", "Alex", "Allison", "Ana", "Arlene", "Arthur"),
       wind = c(110L, 45L, 65L, 40L, 50L, 45L),
       pressure = c(1007L, 1009L, 1005L, 1013L, 1010L, 1010L),
       date = structure(c(11172, 10434, 9284, 10042, 10753, 9664), class = "Date")),
  .Names = c("storm", "wind", "pressure", "date"),
  class = c("tbl_df", "data.frame"),
  row.names = c(NA, -6L))