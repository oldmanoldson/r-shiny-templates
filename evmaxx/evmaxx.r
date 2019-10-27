#map sandbox HW
#Sean Olson
library(leaflet.extras)
library(htmlwidgets)

setwd('G:/SEANOLSON/Documents/Github/r-shiny-templates/evmaxx')

df = read.csv('stations.csv')
df2 = subset(df, UsageType == "Public")
df3 = subset(df, UsageType == "Private")
pal <- colorFactor(c("navy", "red"), domain = c("Public", "Private"))

map <- leaflet() %>%
    addTiles() %>%
    setView(-93.65, 42.0285, zoom = 4) %>%
    addCircleMarkers(data = df2, ~Longitude, ~Latitude, popup = ~paste("<b>",LocationTitle,"</b><br>","<b>Connection Type:</b> ",ConnectionType,"<br>","<b>Number of Points:</b> ",NumberOfPoints,"<br>","<b>Status:</b> ",StatusType, "<br><b>Reserve: </b>Enroute (",round(runif(1,min=5,max=60),0),"min)","<br> 10:00AM, 11:00AM, 12:00PM, 1:00PM, 2:00PM, 3:00PM, 4:00PM, 5:00PM"), clusterOptions = markerClusterOptions(),
        color = "navy", group = "Public", fillOpacity = 0.5, stroke = FALSE) %>%
    addCircleMarkers(data = df3, ~Longitude, ~Latitude, popup = ~paste("<b>",LocationTitle,"</b><br>","<b>Connection Type:</b> ",ConnectionType,"<br>","<b>Number of Points:</b> ",NumberOfPoints,"<br>","<b>Status:</b> ",StatusType, "<br><b>Reserve: </b>Enroute (",round(runif(1,min=5,max=60),0),"min)","<br> 10:00AM, 11:00AM, 12:00PM, 1:00PM, 2:00PM, 3:00PM, 4:00PM, 5:00PM"), clusterOptions = markerClusterOptions(),
        color = "red", group = "Private", fillOpacity = 0.5, stroke = FALSE) %>%
    addMeasure(position = "bottomleft", primaryLengthUnit = "meters", primaryAreaUnit = "sqmeters", activeColor = "black", completedColor = "purple") %>%
    addScaleBar() %>%
    addLegend(data = df, "bottomright", pal = pal, values = ~UsageType, title = "Public or Private", opacity = 1) %>%
    addLayersControl(overlayGroups = c("Public", "Private"), options = layersControlOptions(collapsed = FALSE))

saveWidget(map, file = 'evmaxx_prototype_updated.html')
