#---- nRc: Advanced Visualization----
# Today we will be playing around with some of the different aesthetics within ggplot2.


#---- Install packages and Load Packages ----
# When you open R Studio, make sure in the top right corner you are still opened 
# under the same project that you created previously. If not, click on the cube and 
# open your corresponding R project. Again, download the script and
# data set and add them to the file folder that you created your project folder in. 

# Install packages -- if you already installed these packages, you do not need 
# to install them again. All you need to do is load the packages.

# Install packages
install.packages("tidyverse")

# Load packages 
library("tidyverse")

#---- Read the csv file ----

# Read in the csv file with the data we will be using.
data <- read.csv("growth.csv")
data


#---- Growth Curves----

# In this section, we will learn how to graph growth curves in ggplot2 with the same species 
# under multiple conditions.

# List Time and Temperature as factors. This is important in this case because time and 
# temperature are both numbers, so R will likely treat them as "numeric" unless 
# otherwise stated. 
Time <- as.factor(data$Time)
CellCount <- as.numeric(data$CellCount)
Temperature <- as.factor(data$Temperature)

# Let's graph Cell Count over time. This is the format I used last week, which is easy for
# simple graphs.
ggplot(data, aes(Time, CellCount)) +
  geom_point()

# You'll notice that I use a slightly different format using ggplot() this week. This is 
# much better as graphs start to get more complex with multiple lines, multiple points, etc.
# and it will give you the SAME graph as above. 
ggplot() +
  geom_point(aes(Time, CellCount))

# How do you change colours based on temperature using the new ggplot() format?

ggplot() +
  geom_point(aes(Time, CellCount, color = Temperature))

# Let's add a line to connect the points based on Temperature using the geom_line()
# function. Make sure to also colour the line -- the default will be black unless 
# you specify otherwise. To do this, you also need to identify the "group" in the geom_line()
# function, which in this case, is Temperature. 

ggplot() +
  geom_point(aes(Time, CellCount, color = Temperature)) +
  geom_line(aes(Time, CellCount, group = Temperature, color = Temperature))

# You can customize almost everything in this graph when using ggplot() -- the legend, 
# axis titles, background, point size, font size, labels, colours, etc. 
# Today we will start to learn some of the adjustments!

# Let's customize x- and y- labels with the xlab() and ylab() functions.  
ggplot() +
  geom_point(aes(Time, CellCount, color = Temperature)) +
  geom_line(aes(Time, CellCount, group = Temperature, color = Temperature)) +
  xlab("Time (Hours)") +
  ylab("Cell Count") 

# Let's customize the legend. You can adjust the location, background, font sizes, etc. 
# This is done easily with the theme() function. Use the help function to find out more
# about what arguments are possible within the theme() function. For now, we will focus
# on the legend arguments only. 

?theme()

ggplot() +
  geom_point(aes(Time, CellCount, color = Temperature)) +
  geom_line(aes(Time, CellCount, group = Temperature, color = Temperature)) +
  xlab("Time (Hours)") +
  ylab("Cell Count") +
  theme(legend.direction ="vertical", # vertical, horizontal 
        legend.position = "right", # left, right, bottom, top, none 
        legend.background = element_rect(fill="white"), # This makes the background of the entire legend area white . 
        legend.title = element_text(colour="black", size=11, face="plain"), # Customize legend title text --> face options: plain, bold, italic, bold-italic
        legend.text = element_text(colour="black", size = 8, face = "plain"), # Customize legend text for the points
        legend.text.align = 0, # Alignment of legend labels -- 0 = left, 1 = right 
        legend.key=element_blank(),# Background underneath legend keys -- erases the grey background behind each point.
        legend.title.align = 0) # Alignment of legend title -- 0 = left, 1 = right 
  
# As you can see in the legend right now, there is a line through each of the points. What if 
# I wanted to get rid of that line? Use the logical argument show.legend (TRUE or FALSE) 
# to specify if you want the points or lines included in the graph. The default is TRUE unless
# otherwise specified, so you can add show.legend = TRUE to the geom_point() function 
# or leave it blank. 

ggplot() +
  geom_point(aes(Time, CellCount, color = Temperature), show.legend = TRUE) +
  geom_line(aes(Time, CellCount, group = Temperature, color = Temperature), show.legend = FALSE) +
  xlab("Time (Hours)") +
  ylab("Cell Count") +
  theme(legend.direction ="vertical", 
        legend.position = "right",
        legend.background = element_rect(fill="white"),
        legend.title = element_text(colour="black", size=11, face="plain"), 
        legend.text = element_text(colour="black", size = 8, face = "plain"), 
        legend.text.align = 0, 
        legend.key=element_blank(),
        legend.title.align = 0) 

# Now let's play around with the background. You can change the grid lines, background colour, 
# and more -- all within the same theme() function that we used to customize the legend. 

ggplot() +
  geom_point(aes(Time, CellCount, color = Temperature), show.legend = TRUE, size = 2, shape = 1) +
  geom_line(aes(Time, CellCount, group = Temperature, color = Temperature), show.legend = FALSE) +
  xlab("Time (Hours)") +
  ylab("Cell Count") +
  theme(legend.direction ="vertical", 
        legend.position = "right",
        legend.background = element_rect(fill="white"),
        legend.title = element_text(colour="black", size=11, face="plain"), 
        legend.text = element_text(colour="black", size = 8, face = "plain"), 
        legend.text.align = 0, 
        legend.key=element_blank(),
        legend.title.align = 0, 
        panel.background = element_rect(fill="white",colour="black",size=0.5,linetype="solid"), # "fill" is the background colour, the other arguments are related to the box around the graph.
        panel.grid.major = element_line(size = 0.5, linetype = "dotted", colour = "grey"), # Customizes the major grid lines in the background 
        panel.grid.minor = element_line(size = 0.25, linetype = 'dotted', colour = "grey")) # Customizes the minor grid lines in the background 
       

# "Linetype" options: solid, dotted, dashed, dotdash, longdash, twodash
  

# Now, let's change the colours of lines for each temperature manually. For this, we will 
# pick specific colours to improve the visualisation and understanding of the graph  
  
ggplot() +
  geom_point(aes(Time, CellCount, color = Temperature), show.legend = TRUE, size = 4, shape = 19, alpha = 0.4) +
  geom_line(aes(Time, CellCount, group = Temperature, color = Temperature), show.legend = FALSE, size = 0.75) +
  scale_color_manual(values = c('#4CACBC', '#5FD068', '#FEF9A7', '#FAC213','#F77E21','#D61C4E')) +
  xlab("Time (Hours)") +
  ylab("Cell Count") +
  theme(legend.direction ="vertical", 
        legend.position = "right",
        legend.background = element_rect(fill="white"),
        legend.title = element_text(colour="black", size=11, face="plain"), 
        legend.text = element_text(colour="black", size = 8, face = "plain"), 
        legend.text.align = 0, 
        legend.key=element_blank(),
        legend.title.align = 0, 
        text=element_text(family="mono"), #here you can change the font used in this graph
        panel.background = element_rect(fill="white",colour="grey",size=1.2,linetype="solid"), # "fill" is the background colour, the other arguments are related to the box around the graph.
        panel.grid.major = element_line(size = 0.25, linetype = "dashed", colour = "lightgrey"), # Customizes the major grid lines in the background 
        panel.grid.minor = element_line(size = 0.25, linetype = 'dotted', colour = "lightgrey")) # Customizes the minor grid lines in the background   



# Let's prepare our final graph

ploty <- ggplot() +
                geom_point(aes(Time, CellCount, color = Temperature), show.legend = TRUE, size = 4, shape = 19, alpha = 0.4) +
                geom_line(aes(Time, CellCount, group = Temperature, color = Temperature), show.legend = FALSE, size = 0.75) +
                 scale_color_manual(values = c('#4CACBC', '#5FD068', '#F2E727', '#FAC213','#F77E21','#D61C4E')) +
                 xlab("Time (Hours)") +
                 ylab("Cell Count") +
                 theme(legend.direction ="vertical", 
                          legend.position = "right",
                          legend.background = element_rect(fill="white"),
                          legend.title = element_text(colour="black", size=11, face="plain"), 
                          legend.text = element_text(colour="black", size = 8, face = "plain"), 
                          legend.text.align = 0, 
                          legend.key=element_blank(),
                          legend.title.align = 0, 
                          text=element_text(family="mono"), # Here you can change the font used in this graph
                          panel.background = element_rect(fill="white",colour="grey",size=1.2,linetype="solid"),
                          panel.grid.major = element_line(size = 0.25, linetype = "dashed", colour = "lightgrey"), 
                          panel.grid.minor = element_line(size = 0.25, linetype = 'dotted', colour = "lightgrey")) 

  
# Let's look at our graph and make final changes

ploty


# Save your file in png or pdf format with additional specification (width, height, scale, 
# pixels, units). This is an alternative that allows for more (and better) customization
# compared to the "export" button. 

ggsave("graph_lesson3.png", ploty, width = 15, height = 10, dpi = 300)

ggsave("graph_lesson3.pdf", ploty, width = 15, height = 10, dpi = 300)


#---- Creating a BARPLOT with the same data ----


# What's the mean number of cells for each time?

mean_data <- data %>%
  group_by(Time) %>%
  summarize(mean_cells = mean(CellCount))


View(mean_data)

# Here, we create a barplot based on mean_data


ggplot(mean_data) +
  geom_bar( aes(x=Time, y=mean_cells), stat="identity", fill="skyblue", alpha=0.7) +
  theme_minimal()
  

# HOMEWORK 22 June 2022
# Customize this plot at your liking. Change axes, theme, titles, colours, legend, 
# font or create error bars if you want. You can even try something similar with your own data. 
# Send your best plots by email to Jenna and Solenn!!
  
