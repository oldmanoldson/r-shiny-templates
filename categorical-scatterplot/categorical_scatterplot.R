# Categorical Scatter Plot

library(plotly)

catscat_data <- read.table("path/to/data/catscatdata.txt", header = TRUE, sep = "\t")

group.colors <- c(Blue = "dark blue", Red = "maroon")

s <- ggplot(catscat_data, aes(x = Type, y = Range, color = Category)) + geom_jitter(width = 0.2, height = 0.2) + ggtitle("Categorical Scatter Plot with Jitter") + scale_color_manual(values = group.colors)

ggplotly(s)
