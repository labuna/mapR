library(rgdal)
library(leaflet)

#Load state shape file
# states <- readOGR("data/shapefiles/cb_2014_us_state_500k/cb_2014_us_state_500k.shp",
#   layer = "cb_2014_us_state_500k", verbose = FALSE)



#Plot states on map
leaflet(states) %>% addTiles()%>%
  addPolygons(
    stroke = FALSE, fillOpacity = 0.1, smoothFactor = 0.5,
    color = ~colorQuantile("YlOrRd", as.numeric(as.character(states@data$STATEFP))) (as.numeric(as.character(STATEFP)))
 )

