#---- nRc: Introduction to Maps and Geospatial Data visualization ----

# A lot of mapping is traditionally done in ArcGIS or other robust mapping programs, 
# but R is also a great (free!) resource for making high-quality graphs for publication. 

# Our first mapping lesson will primarily focus on basic mapping and customization, 
# then in the next couple classes we will look at adding data points and creating 
# interactive maps (which are always awesome for presentations!). 

# I encourage everyone to do a little bit of research into different data formats, raster 
# vs. vector, etc. to better understand what goes into creating a beautiful map. 

# Today's script was modified from Robin Lovelace (University of Leeds) and further instruction 
# can be found at the following links: 
# https://geocompr.robinlovelace.net/index.html
# https://geocompr.robinlovelace.net/spatial-class.html#basic-map
# https://geocompr.robinlovelace.net/adv-map.html

#---- Install and Load Packages ----
# We won't use all of these packages today, but they can be incredible useful for 
# other map-building that we will be doing in the next few classes. 

install.packages("sf")
library("sf")

# When installing this package, it might ask you the following:
# "Do you want to install from sources the package which needs compilation? (Yes/no/cancel)"
# Write "no" by the cursor in the console and click enter. 
install.packages("terra")
library("terra")

# Here is a list of the datasets within the spData package. We will be using the "nz"
# one today. 
# https://cran.r-project.org/web/packages/spData/readme/README.html
install.packages("spData")
library("spData")

install.packages("spDataLarge", repos = "https://geocompr.r-universe.dev")
library("spDataLarge")

install.packages("cowplot")
library("cowplot")

install.packages("googleway")
library("googleway")

install.packages("ggspatial")
library("ggspatial")

# Provides a map of countries of the entire world (vector data)
# https://cran.r-project.org/web/packages/rnaturalearth/vignettes/rnaturalearth.html#:~:text=rnaturalearth%20is%20a%20data%20package,countries%20ne_countries()
install.packages("rnaturalearth")
library("rnaturalearth")

install.packages("rnaturalearthdata")
library("rnaturalearthdata")

# For static and interactive maps
install.packages("tmap")
library("tmap")

# For interactive maps 
install.packages("leaflet")
library("leaflet")

#---- Loading Data into R----  

# Region boundaries can be stored in shapefiles (sf) or geoJSON files.

# This is for building the outline of the map of NZ.
nz
summary(nz)

# Let's load some more sample data for New Zealand. 
nz_elev = rast(system.file("raster/nz_elev.tif", package = "spDataLarge"))
nz_elev

#---- Using Base function plot() to create maps ----

# A very simple map can easily be made using the plot() function. 

plot(nz)

plot(world) 

# You need to make sure your raster or vector data is in the correct format!

#---- Using the tmap package to create maps ----

#This package is more robust and customizable than the plot() function, and the syntax
# is very similar to that of ggplot2 -- which we are all quite familiar with!

# nz is an sf object used in the tm_shape() function to define the map. Several 
# different layers can be added to customize the map. To see a more detailed list 
# of options for different layers/customizations, check out the tmap-element using the 
# "help" function. 

?"tmap-element"

# Add fill layer to nz shape
tm_shape(nz) +
  tm_fill() 
# Add border layer to nz shape
tm_shape(nz) +
  tm_borders() 
# Add fill and border layers to nz shape
tm_shape(nz) +
  tm_fill() +
  tm_borders() 

# The order of layers can be important once you start to have several 
# different layers. 

# One major benefit of using tmap is that you can store your map as objects. The 
# tm_polygons() function essentially combines the tm_fill() and tm_borders() functions. 

map_nz <- tm_shape(nz) + tm_polygons()
map_nz

# Here, we can add another layer of data to the map -- the elevation! 
map_nz1 <- map_nz +
            tm_shape(nz_elev) + # adding the elevation our map of New Zealand
            tm_raster(alpha = 0.7) # mapping element that draws a raster 
map_nz1

# Colours & Aesthetics --> customization like in ggplot2, but instead of using the 
# aes() function, you have to fill directly in the tmap-element. 
map1 = tm_shape(nz) + tm_fill(col = "red")
map2 = tm_shape(nz) + tm_fill(col = "red", alpha = 0.3)
map3 = tm_shape(nz) + tm_borders(col = "blue")
map4 = tm_shape(nz) + tm_borders(lwd = 3) # line width 
map5 = tm_shape(nz) + tm_borders(lty = 2) # line type 
map6 = tm_shape(nz) + tm_fill(col = "red", alpha = 0.3) + tm_borders(col = "blue", lwd = 3, lty = 2)

# Similar to our ggarrange() function from ggplot2, this function can arrange all 
# six graphs on one grid. 
tmap_arrange(map1, map2, map3, map4, map5, map6)

# You can also distinguish colour by a variable, such as land area. 
tm_shape(nz) + 
  tm_fill(col = "Land_area")

# What are some differences between that graph and the one made by the general plot() function? 

# You can clean up the graph by adding correctly formatted titles (and units, in this case)
legend_title <- expression("Area (km"^2*")") # This is useful to correctly format superscripts
map_nza <- tm_shape(nz) +
            tm_fill(col = "Land_area", title = legend_title) + 
            tm_borders()
map_nza

# Let's adjust the number of breaks in a variable. Start with this graph.
tm_shape(nz) + 
  tm_polygons(col = "Median_income")

# Add breaks
breaks = c(0, 3, 4, 5) * 10000
tm_shape(nz) + tm_polygons(col = "Median_income", breaks = breaks)

# Ok... not exactly a pretty graph. Let's increase the number of breaks!
tm_shape(nz) + tm_polygons(col = "Median_income", n = 10)

# Use what we've learned in the previous 3 graphs to make a descriptive graph (and maybe 
# add a cool new colour palette)
breaks1 = c(2.3, 2.5, 2.7, 2.9, 3.1, 3.3)*10000
tm_shape(nz) + tm_polygons(col = "Median_income", breaks = breaks1, title = "Median Income ($)", palette = "BuGn")

# Instead of manually creating break points, tmap has some automated options. Here are 
# some of the best ones: 
# style = "pretty", the default setting, rounds breaks into whole numbers where possible and spaces them evenly;
# style = "equal" divides input values into bins of equal range and is appropriate for variables with a uniform distribution (not recommended for variables with a skewed distribution as the resulting map may end-up having little color diversity);
# style = "quantile" ensures the same number of observations fall into each category (with the potential downside that bin ranges can vary widely);
# style = "jenks" identifies groups of similar values in the data and maximizes the differences between categories;
# style = "cont" (and "order") present a large number of colors over continuous color fields and are particularly suited for continuous rasters ("order" can help visualize skewed distributions);
# style = "cat" was designed to represent categorical values and assures that each category receives a unique color.

tm_shape(nz) + tm_polygons(col = "Median_income", style = "quantile", title = "Median Income ($)", palette = "BuGn")

# Colour Palettes
# There are different ways to colour your data to highlight differences/similarities, 
# but the colouring pattern you use depends on what type of data you have. 
# 1. Categorical colour palette --> this is for categorical data 
tm_shape(nz) + tm_polygons("Island", style = "cat")
# 2. Sequential colour palette --> this follows a gradient 
tm_shape(nz) + tm_polygons("Population", palette = "Blues") # Single colour
tm_shape(nz) + tm_polygons("Population", palette = "YlOrBr") # Multi-coloured
# 3. Diverging colour palette --> this visualizes the difference from an important reference 
#   point

# The viridis colour palettes are compatible with tmap!
# https://cran.r-project.org/web/packages/viridis/

# What other elements of a map are we missing? 
# - Scale bar
# - Compass 

map_nz + 
  tm_compass() +
  tm_scale_bar()

# Now, customize it!
map_nz + 
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scale_bar(breaks = c(0, 100, 200), text.size = 1)

?tm_compass # Look at the "type" for the different styles of compasses 
?tm_scale_bar 

# tm_layout() is similar to the theme() function in ggplot2. 
map_nz + tm_layout(title = "New Zealand") # Adds title
map_nz + tm_layout(bg.color = "lightblue") # Change the background colour
map_nz + tm_layout(frame = FALSE) # Remove the frame 

?tm_layout() # There are SEVERAL customization options

tm_shape(nz) + 
  tm_polygons("Population", palette = "Blues") + 
  tm_layout(title = "New Zealand", frame = FALSE, legend.position = c("right", "bottom"))

# tm_style() defaults the theme
map_nza + tm_style("bw")
map_nza + tm_style("classic")
map_nza + tm_style("cobalt")
map_nza + tm_style("col_blind")

#---- Intro to Interactive Maps with tmap ----
# You can change the tmap_mode() to view as an interactive map 

?tmap_mode()

tmap_mode("view")
map_nza + tm_style("col_blind")

# To switch back, change the mode to "plot" 
tmap_mode("plot")
map_nza + tm_style("col_blind")

# Challenges for the next class:
# 1. Customize a map of Nova Scotia. Add Halifax as a data point on the map. 
# 2. Customize a map of Canada, highlighting different provinces and colouring 
#     based on population density. 


# Next class, we will continue exploring maps with tmap AND start using gggplot2. See
# the following links for a preview of some spatial visualization concepts with ggplot2!
# https://r-spatial.org/r/2018/10/25/ggplot2-sf.html
# https://cengel.github.io/R-spatial/mapping.html
# https://bookdown.org/nicohahn/making_maps_with_r5/docs/ggplot2.html
# https://www.emilyburchfield.org/courses/eds/making_maps_in_r






