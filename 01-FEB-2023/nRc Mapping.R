#---- nRc: Mapping with Datapoints ----

#---- Install and Load packages ----
# install.packages("oce")
library("oce")

# install.packages("ocedata")
library("ocedata")

# install.packages("magrittr")
library("magrittr")

# install.packages("sf")
library("sf")

# When installing this package, it might ask you the following:
# "Do you want to install from sources the package which needs compilation? (Yes/no/cancel)"
# Write "no" by the cursor in the console and click enter. 
# install.packages("terra")
library("terra")

# install.packages("spData")
library("spData")

# install.packages("spDataLarge", repos = "https://geocompr.r-universe.dev")
library("spDataLarge")

# install.packages("cowplot")
library("cowplot")

# install.packages("googleway")
library("googleway")

# install.packages("ggspatial")
library("ggspatial")

# Provides a map of countries of the entire world (vector data)
# https://cran.r-project.org/web/packages/rnaturalearth/vignettes/rnaturalearth.html#:~:text=rnaturalearth%20is%20a%20data%20package,countries%20ne_countries()
# install.packages("rnaturalearth")
library("rnaturalearth")

# install.packages("rnaturalearthdata")
library("rnaturalearthdata")

# For static and interactive maps
# install.packages("tmap")
library("tmap")

# For interactive maps 
# install.packages("leaflet")
library("leaflet")

# For bathymetry data
# install.packages("marmap")
library("marmap")

# Colour palettes
# install.packages("RColorBrewer")
library("RColorBrewer")
# RColorBrewer::display.brewer.all()

# For creating ocean maps 
# install.packages("ggOceanMaps")
library("ggOceanMaps")

# install.packages("mapproj")
library("mapproj")

# install.packages("treemap")
library("treemap")

# install.packages("hrbrthemes")
library("hrbthemes")

# Colour-blind colour palettes
# install.packages("viridis")
library("viridis")

# install.packages("ggplot2)
library("ggplot2")

# install.packages("treemapify")
library("treemapify")

# install.packages("extrafont")
library("extrafont")

# install.packages("ggrepel")
library("ggrepel")

# install.packages("ggfittext")
library("ggfittext")

# install.packages("showtext")
library("showtext")

# install.packages("ragg")
library("ragg")

# Need for installing google fonts
# install.packages("jsonlite")
library("jsonlite")

# Need for installing google fonts
# install.packages("curl")
library("curl")

# Need for installing google fonts
# install.packages("extrafont")
library("extrafont")

# Need for installing google fonts
showtext_auto()
font_add_google(name = "Poppins", family = "Poppins")

# install.packages("ggrepel")
library("ggrepel")

# For north symbols and scale bars
install.packages("ggsn")
library("ggsn")

# install.packages("tidyverse")
library("tidyverse")

# install.packages("ggspatial")
library("ggspatial")

# install.packages("maps")
library("maps")

# install.packages("mapdata")
library("mapdata")

# install.packages("canadianmaps")
library("canadianmaps")

#---- Load the Data for map with datapoints ----

# This loads a specific dataset from the "ocedata" package that focuses on all the 
# coastlines.
data(coastlineWorldFine)

?coastlineWorldFine

# Today's datapoints will be the longitude and latitude coordinates of sampling sites
# from the cruises my colleagues have been on in the past couple years. 
data <- read.csv("cruise_data.csv", header = TRUE)
data

#---- Creating maps in ggplot2 with datapoints ----

# This takes the dataset we loaded from the "ocedata" package and makes it into a dataframe 
# called "coast".
# ggplot() prefers to work with dataframes -- this it's easier to make the coast data 
# into a specific dataframe to work with. 
coast <- as.data.frame(coastlineWorldFine@data)
coast

# Colour selection 
# One of the best parts about  customizing a map is choosing the colours (duh!)
# https://r-graph-gallery.com/38-rcolorbrewers-palettes.html
# Colours have a HEX code, which is a series of numbers/letters that identify it. 
# Use the link below to select the colour you want, then copy over the HEX code associated
# with it. 
# https://htmlcolorcodes.com/

ggplot()+
  # geom_polygon() makes the coast dataframe into a  series of polygons-- AKA the land
  # "fill =" is the colour of the land (with the HEX code)
  geom_polygon(data = coast, aes(x = longitude, y = latitude), fill = "#90b090")+
  # coord_map() defines the projection of the map, and the x/y limits of the map.
  # Often the projection of the map has to correspond to the data input. 
  coord_map(projection = "stereographic", ylim = c(44, 52), xlim = c(-73, -53))+
  # This is the coordinate data for the sampling stations.
  # "col =" defines which category sorts the points into different colours -- in this case 
  # it's the different cruises. 
  geom_point(data = data, aes(x = d_lon, y = d_lat, col = Cruise), shape = 16, size = 4)+
  # Manually changes the colours to HEX codes that I chose. In the legend, they will be called 
  # "Cruise", as I have labelled here. 
  scale_color_manual(name="Cruise", values=c("#78e296", "#89d9fc", "#fc89f3", "#bfbf4a", "#ff9f91"))+
  theme_minimal()+
  theme(text = element_text(family = "Poppins", color = "#22211d", size = 14),
        axis.line = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.grid.major = element_line(color = "#ebebe5", size = 1.7),
        panel.grid.minor = element_blank(),
        plot.background = element_blank(), 
        panel.background = element_blank(), 
        legend.background = element_blank(),
        legend.title = element_blank(),
        legend.position = "bottom",
        panel.border = element_rect(fill = NA, color = "#ebebe5", size = 1.7))

#---- Save cruise map as a pdf ----

# When using code like this to save as a pdf, sometimes you will need to adjust the 
# point size and text size to optimize the graph exported. 

pdf(file = "cruise_map.pdf", width = 17, height = 10)

ggplot()+
  geom_polygon(data = coast, aes(x = longitude, y = latitude), fill = "#90b090")+
  coord_map(projection = "stereographic", ylim = c(44, 52), xlim = c(-73, -53))+
  geom_point(data = data, aes(x = d_lon, y = d_lat, col = Cruise), shape = 16, size = 8)+
  scale_color_manual(name="Cruise", values=c("#78e296", "#89d9fc", "#fc89f3", "#bfbf4a", "#ff9f91"))+
  theme_minimal()+
  theme(text = element_text(family = "Poppins", color = "#22211d", size = 16),
        axis.line = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.grid.major = element_line(color = "#ebebe5", size = 1.7),
        panel.grid.minor = element_blank(),
        plot.background = element_blank(), 
        panel.background = element_blank(), 
        legend.background = element_blank(),
        legend.title = element_blank(),
        legend.position = "bottom",
        panel.border = element_rect(fill = NA, color = "#ebebe5", size = 1.7))

dev.off()

#---- Selecting & Filtering Cruise Data ----


data <- data %>% 
          dplyr::filter(Cruise == "COOGER 2021")

# Some other logical arguments to use with the filter() function:
# <     --> less than
# >     --> greater than
# !=    --> Not equal to
# <=    --> less than or equal to
# >=    --> greater than or equal to

ggplot()+
  geom_polygon(data = coast, aes(x = longitude, y = latitude), fill = "#90b090")+
  coord_map(projection = "stereographic", ylim = c(44, 52), xlim = c(-73, -53))+
  geom_point(data = data, aes(x = d_lon, y = d_lat, col = Cruise), shape = 16, size = 3)+
  scale_color_manual(name="Cruise", values=c("#89d9fc"))+
  theme_minimal()+
  theme(text = element_text(family = "Poppins", color = "#22211d", size = 14),
        axis.line = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.grid.major = element_line(color = "#ebebe5", size = 1.7),
        panel.grid.minor = element_blank(),
        plot.background = element_blank(), 
        panel.background = element_blank(), 
        legend.background = element_blank(),
        legend.title = element_blank(),
        legend.position = "bottom",
        panel.border = element_rect(fill = NA, color = "#ebebe5", size = 1.7))


