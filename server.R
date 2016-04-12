library(shiny)
library(leaflet)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()


shinyServer(function(input, output) {
  #output$contents <- DT::renderDataTable(DT::datatable(default_data))
#   output$contents <- DT::renderDataTable(DT::datatable({
#     
#     # input$file1 will be NULL initially. After the user selects
#     # and uploads a file, it will be a data frame with 'name',
#     # 'size', 'type', and 'datapath' columns. The 'datapath'
#     # column will contain the local filenames where the data can
#     # be found.
#     
#     inFile <- input$file1
#     
#     if (is.null(inFile))
#       return(default_data[1:5,])
#     #  return(NULL)
#     #else return(default_data)
#     read.delim(inFile$datapath, header=TRUE, sep="\t")
#     
#   }))
#zips <- rgdal::readOGR("../../Archive/compressed_tl_2015_us_zcta510.shp","compressed_tl_2015_us_zcta510")
  infile <- reactive({
    inFile <- input$file1
        if (is.null(inFile))
          return(NULL)
         read.delim(inFile$datapath, header=TRUE, sep="\t")[,]
  })
  
  output$contents <- DT::renderDataTable(DT::datatable({
    if (is.null(infile()))
      return(NULL)
    infile()
 }))
  
  points <- eventReactive(input$recalc,  {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    zip_custom <- infile()
   # print(zip_custom)
    # print(input$mymap_shape_mouseover)
    # x <- as.character(zip_custom$zip)
    x <- subset(zips, zips@data$ZCTA5CE10 %in% zip_custom$zip)
    leaflet(x) %>% 
      # addProviderTiles("Stamen.TonerLite",
      # addProviderTiles("Stamen.Toner",
      addProviderTiles("Stamen.Terrain",
              options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addPolygons(
        stroke = FALSE, fillOpacity = .5, smoothFactor = .5,
        color = ~colorQuantile("YlOrRd", as.numeric(as.character(x@data$ZCTA5CE10))) (as.numeric(as.character(ZCTA5CE10)))
      )
      #addMarkers(data = points()) %>%
      
  })
}

)