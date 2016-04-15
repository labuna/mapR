library(rgdal)
library(gridExtra)
library(maptools)
library(rgeos)
#Load State Shape Files
states <- readOGR(dsn = "data/shapefiles/cb_2014_us_state_500k/cb_2014_us_state_500k.shp",
                  layer = "cb_2014_us_state_500k")
states <- zips
states@data <- data.frame(states@data,zipcode[match(as.character(states@data$ZCTA5CE10),zipcode$zip),])
# states <- states[states@data$STUSPS %in% c("DC","NY","PA","NJ","DE","CT",
#                                            "MD","RI","MA","VA","WV","OH",
#                                            "NC","TN","KY","MI","IL","SC",
#                                            "GA","AL","MI","IN","LA","AR",
#                                            "MS","MO","IA","WI","IO","MN",
#                                            "ND","SD","NE","KS","OK","TX",
#                                            "MT","WY","CO","NM","ID","UT",
#                                            "AZ","NV","WA","OR","CA"),]
#Create coordinates as IDs
# states <- states[(as.integer(states@data$ZCTA5CE10) <= 13000 & as.integer(states@data$ZCTA5CE10) > 10900)|
#                    (as.integer(states@data$ZCTA5CE10) <= 10600 & as.integer(states@data$ZCTA5CE10) > 10000),]
# states <- states[(as.integer(states@data$ZCTA5CE10 %in% c(10028,10128,10029,10027))),]
states <- states[states@data$state == "NY",]
states.coords <- coordinates(states)

states.id <- cut(states.coords[,1],quantile(states.coords[,1],probs = seq(0,1,.25)),include.lowest=TRUE)
x <- Sys.time()
states.union <- unionSpatialPolygons(states,states.id)
y <- Sys.time()
print(y-x)
plot(states)
plot(states.union, add = TRUE, border = "red", lwd=2)


#Convert SpatialPolygons to data frame
states.df <- as(states,"data.frame")

#Aggregate and sum desired data attributes by ID List
states.df.agg <- aggregate(states.df[,c("ALAND10","AWATER10")], list(states.id), mean)
row.names(states.df.agg) <- as.character(states.df.agg$Group.1)

#Reconvert data frame to SpatialPolygons
states.shp.agg <- SpatialPolygonsDataFrame(states.union, states.df.agg)

#Plotting
grid.arrange(spplot(states,"AWATER10",main="State water original"),
              spplot(states.shp.agg, "AWATER10",main="State water aggregated"))

states.shp.agg2 <- gSimplify(states.shp.agg, tol=0.01, topologyPreserve=TRUE)
states.shp.agg2 <- SpatialPolygonsDataFrame(states.shp.agg2,states.df.agg)
spplot(states.shp.agg2, "AWATER10",main="State water aggregated")

leaflet(states.shp.agg) %>% 
  addProviderTiles("Stamen.TonerLite",
  # addProviderTiles("Stamen.Toner",
  # addProviderTiles("Stamen.Terrain",
                   options = providerTileOptions(noWrap = TRUE)
  ) %>%
  addPolygons(
    stroke = FALSE, fillOpacity = .5, smoothFactor = .5,
    color = ~colorQuantile("YlOrRd", as.numeric(as.character(states.shp.agg@data$AWATER10))) (as.numeric(as.character(AWATER10)))
  )

