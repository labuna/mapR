library(rgdal)
library(gridExtra)
library(maptools)
#Load State Shape Files
states <- readOGR(dsn = "data/shapefiles/cb_2014_us_state_500k/cb_2014_us_state_500k.shp",
                  layer = "cb_2014_us_state_500k")

states <- states[states@data$STUSPS %in% c("DC","NY","PA","NJ","DE","CT",
                                           "MD","RI","MA","VA","WV","OH",
                                           "NC","TN","KY","MI","IL","SC",
                                           "GA","AL","MI","IN","LA","AR",
                                           "MS","MO","IA"),]
#Create coordinates as IDs
states.coords <- coordinates(states)

states.id <- cut(states.coords[,1],quantile(states.coords[,1]),include.lowest=TRUE)

states.union <- unionSpatialPolygons(states,states.id)

# plot(states)
# plot(states.union, add = TRUE, border = "red", lwd=2)


#Convert SpatialPolygons to data frame
states.df <- as(states,"data.frame")

#Aggregate and sum desired data attributes by ID List
states.df.agg <- aggregate(states.df[,c("ALAND","AWATER")], list(states.id), sum)
row.names(states.df.agg) <- as.character(states.df.agg$Group.1)

#Reconvert data frame to SpatialPolygons
states.shp.agg <- SpatialPolygonsDataFrame(states.union, states.df.agg)

#Plotting
grid.arrange(spplot(states,"ALAND",main="State water original"),
              spplot(states.shp.agg, "ALAND",main="State water aggregated"))