#map sandbox HW
#Sean Olson

library(shiny)
library(leaflet.extras)
library(geojsonio)
library(rgdal)
library(sf)

dataurl <- 'https://opendata.arcgis.com/datasets/f5c3b84a6fcc499d8f9ece78602258eb_0.geojson'
wake <- st_read(dataurl)
wake$zips <- factor(sample.int(39L, nrow(wake), TRUE))

bikedata <- '/path/to/data/bicycle-crash-data-chapel-hill-region.geojson'
bike <- geojson_read(bikedata)

vtdata <- 'http://geodata.vermont.gov/datasets/4c206846699947429df59c8cb552ab5c_11.geojson'
vt <- st_read(vtdata)

factpal <- colorFactor(topo.colors(5), wake$zips)

ui <- shinyUI(
    fluidPage(
        leafletOutput("map", width = "100%", height = "900px")
    )
)

server <- function(input, output) {

    wakegeojson <- reactive({
        wake
    })

    bikegeojson <- reactive({
        bike
    })

    vtgeojson <- reactive({
        vt
    })

    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%
            setView(-93.65, 42.0285, zoom = 4)

    })

    observe({
        leafletProxy("map") %>%
            addWMSTiles("http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi", layers = "nexrad-n0r-900913", options = WMSTileOptions(format = "image/png", transparent = TRUE), attribution = "") %>%
            addPolygons(data = wakegeojson(), color = factpal(wake$zips)) %>%
            addGeoJSON(bikegeojson()) %>%
            addPolylines(data = vtgeojson(), color = "red") %>%
            addMiniMap() %>%
            addMeasure(position = "bottomleft", primaryLengthUnit = "meters", primaryAreaUnit = "sqmeters", activeColor = "black", completedColor = "purple") %>%
            addScaleBar()
    })
}

app <- shinyApp(ui = ui, server = server)
runApp(app, launch.browser = TRUE)
