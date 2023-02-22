#---- nRc: more mapping! ----

# ---- Install and load packages ----

# Most of these should already be installed on your R. If not, use the install.packages() 
# function, then the library() function. 

library("sf")
library("terra")
library("dplyr")
library("spData")
library("spDataLarge")
library("ggplot2")
library("tidyverse")
library("tmap")
library("leaflet")
library("maps")

install.packages("osmdata")
library("osmdata")

install.packages("geosphere")
library("geosphere")


# ---- Intro to Interactive maps using leaflet() ----

# Today's instruction is a modified version from the following sources: 
# https://www.earthdatascience.org/courses/earth-analytics/get-data-using-apis/leaflet-r/



# Leaflet is a very robust package used to make interactive maps. 
r_birthplace <- leaflet() %>%
                  addTiles() %>%  # This uses the default base map, which is OpenStreetMap tiles
                  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
r_birthplace

# The "popup" is the words that show when you zoom in to the map and click on the point. 
# addTiles() and addMarkers() are a couple of several graphical layers/elements that can be added to interactive
# maps in the leaflet package. 

?addMarkers()


# Let's do the same thing with our GPS location! 
nRc <- leaflet() %>% 
          addTiles %>% 
          addMarkers(lng = -63.59566385981487, lat = 44.63637219551556, popup = "nRc coding headquarters")
nRc

# Try something similar in leaflet using the dataset world.cities, which is part of the 
# "maps" package. 

# Load the data
data(world.cities)

# Filter the dataset to online include the capital cities. 
capitals <- dplyr::filter(world.cities, capital == 1)
capitals

# Homework Challenge: Now, use leaflet() to design an interactive map. The link above 
# will help you figure out how to add MULIPLE markers of interest! 


# ---- Open Street Maps Data ----

# Below is a good link to a lesson on mapping streets using the "osmdata" package. 

# https://jcoliver.github.io/learn-r/017-open-street-map.html




