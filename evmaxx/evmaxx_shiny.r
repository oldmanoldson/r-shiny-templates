#map sandbox HW
#Sean Olson

library(shiny)
library(leaflet.extras)

df = read.csv('stations.csv')
pal <- colorFactor(c("navy", "red"), domain = c("Public", "Private"))

ui <- shinyUI(
    fluidPage(
        leafletOutput("map", width = "100%", height = "900px")
    )
)

server <- function(input, output) {

    stations <- reactive({
        df
    })

    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%
            setView(-93.65, 42.0285, zoom = 4)

    })

    observe({
        leafletProxy("map", data = stations()) %>%
            addCircleMarkers(~Longitude, ~Latitude, popup = ~paste("<b>",LocationTitle,"</b><br>","<b>Connection Type:</b> ",ConnectionType,"<br>","<b>Number of Points:</b> ",NumberOfPoints,"<br>","<b>Status:</b> ",StatusType), clusterOptions = markerClusterOptions(), color = ~pal(UsageType)) %>%
            addMiniMap() %>%
            addMeasure(position = "bottomleft", primaryLengthUnit = "meters", primaryAreaUnit = "sqmeters", activeColor = "black", completedColor = "purple") %>%
            addScaleBar()
    })
}

app <- shinyApp(ui = ui, server = server)
runApp(app, launch.browser = TRUE)