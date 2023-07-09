
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinythemes)
library(shinyWidgets)
library(leaflet)

# getColor <- function(quakes) {
#   sapply(map_data$start_dt, function(mag) {
#     if(mag <= '2023-09-30') {
#       "green"
#     } else if(mag <= '2023-10-20') {
#       "orange"
#     } else {
#       "red"
#     } })
# }

# r_colors <- rgb(t(col2rgb(colors()) / 255))
# names(r_colors) <- colors()

ui <- fluidPage(
  
  useShinyjs(),
  
  tags$style(type = "text/css",
  ),
  
  titlePanel(title = "Shick Sabbatical", windowTitle = "Shick Sabbatical"),
  
  theme = shinytheme("flatly"),
  
  # dashboardHeader(title = "My Dashboard", skin = "blue
  
  # Sidebar with a slider input for the number of bins
  # sidebarLayout(
    # sidebarPanel(
  fluidRow(
    box(
      width = 50,
      sliderInput("dates",
                  "Dates:",
                  min = as.Date("2023-09-23","%Y-%m-%d"),
                  max = as.Date("2023-10-31","%Y-%m-%d"),
                  value= as.Date("2022-10-01","%Y-%m-%d"),
                  timeFormat="%Y-%m-%d",
                  width = 1900)
    )
  ),
  
  mainPanel(
    
    tableOutput("table1"),

  leafletOutput("mymap", width = 1000, height = 600),
  p(),

  )
)


##Server
server <- function(input, output, session) {
  
  map_data = readRDS("./data/map_data.rds")

  points = reactive({
    map_data %>%
      filter(map_data$start_dt <= input$dates)
  })
  
  output$table1 <- renderTable({ points() })
  
  output$mymap <- renderLeaflet({

    leaflet() %>% 
      addTiles() %>% 
      # fitBounds(0, 35, 20, 55) %>% 
      addMarkers(lng = ~lon,
                 lat = ~lat,
                 data = points()) %>%
      addPolylines(lng = ~lon,
                   lat = ~lat,
                   data = points()) %>% 
      setView(8.541694, 47.37689, zoom = 4.5)
    
  })
}

shinyApp(ui, server)