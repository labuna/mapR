library(shinydashboard)
library(leaflet)

dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Input", tabName = "data_input", icon = icon("table")),
      menuItem("Map", tabName = "map", icon = icon("map"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "data_input",
        fluidRow(
          fileInput('file1','Choose text file',
                    accept='text/plain'),
          DT::dataTableOutput('contents')
        )
      ),
      tabItem(tabName = "map",
        fluidRow(
          leafletOutput("mymap"),
          p() #,
          # actionButton("recalc","New points")
        )
      )
    )
  )
)