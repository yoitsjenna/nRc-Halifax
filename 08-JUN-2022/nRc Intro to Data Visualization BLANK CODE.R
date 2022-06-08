#---- nRc: Intro to Data Visualization----

# When you open R Studio, make sure in the top right corner you are still opened 
# under the same project that you created previously. If not, click on the cube and 
# open your corresponding R project. Again, download the script and
# data set and add them to the file folder that you created your project folder in. 

# Install packages -- if you already installed these packages, you do not need 
# to install them again. All you need to do is load the packages. 
install.packages("tidyverse")

# Load packages 
library("tidyverse")

# Now, read in the csv file with the data we will be using.
# na.strings() is used in this case because we have blanksin this spreadsheet, disguised as 
# empty cells, spaces in cells, or "NA" in the box. This command normalizes them all 
# for R to identify them as "NA". 
data <- read.csv("rodents.csv", na.strings = c(""," ", "NA"))
data

# head() is a function to see the first few rows of a larger data set 
# Use head() to see the first few rows of the data. 
head(data)

# You can specify how many rows you want to look at by including the number in the brackets.
# How would I see the first 10 rows only?
head(data, 10)

# What is the structure of our data set? 
str(data)

# Some of these functions were used previously when using pipes, but I've added a 
# few more that we will become familiar with today:
#   select(): subset columns
#   filter(): subset rows on conditions
#   group_by() and summarize(): create summary statistics on grouped data
#   mutate(): create new columns by using information from other columns
#   arrange(): sort results
#   count(): count discrete values

select(data, plot_id, species_id, weight)
filter(data, plot_id < 9)

# Using pipes, filter the data to select ONLY the data occurring in the year 1995, 
# weight is less than 30, and include only the columns species_id, sex, and weight. 

# mutate() allows you to alter the data set. The weight in the csv file is in grams, and 
# we want to change it to kg.

data %>%
  mutate(weight_kg = weight / 1000) 

# This created a new column using data already present in your table. This column 
# will be added as the last column of your table. 

# This will calculate and create 2 columns
data %>%
  mutate(weight_kg = weight / 1000, weight_kgx2 = weight*2) 

#---- Missing Data points in your data set----

# Some large data sets could have missing values or measurements, and other stats or graphing
# programs may or may not be able to deal with the missing data 

# The first thing we will do is change all blanks to "NA" -- you can do this in the 
# reverse, too. 

# Using the filter() function, you can use omit any rows that contain NA

data %>%
  filter(!is.na(weight))

# Create a new data frame (and assign it to a variable) from the  data that meets the 
# following criteria: contains only the species_id column and a new column called hindfoot_half 
# containing values that are half the hindfoot_length values. In this hindfoot_half column, 
# there are no NAs and all values are less than 30.

# Assign the new data frame to a variable 
# NEW Column called hinfoot_half 
# ONLY species_id column
# NO NAs
# ALL hindfoot_half values less than 30

# Before running this code, consider the data set-- What should it look like? 

data %>%
  filter(!is.na(sex)) %>% 
  group_by(sex) %>% 
  summarize(mean_weight = mean(weight, na.rm = TRUE))


sex_data <- data %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))

# To see a table in the "Source" panel, use view() or click on the name of the data 
# variable listed in the "Environment" tab on the right. 

View(sex_data)

# count() is used to tell us the # occurrences (really, the # of rows) related to each variable
# for the category specified in the brackets. 
# If you want to know the number of rows for each sex:
data %>% 
  count(sex)

# How would you write the code if you wanted to know the number of rows for each sex AND species_id?


# How many different occurrences are there at each plot type? 


# Use group_by() and summarize() to find the mean, min, and max hindfoot length for 
# each species (using species_id). Also add the number of observations (hint: see ?n -- this is the 
# help function we used last week).



# n() counts how many observations you have to calculate each mean, max and min.


# What was the heaviest animal measured in each year? Return the columns year, genus, 
# species_id, and weight.


# The arrange() function will sort the expanded data at the end based on year. You could
# change "year" with "weight" to sort by weight instead. 

#---- Introduction to Graphing ----

# Before starting the graphing section, we should remove all the "NA" values from our 
# data set. Filter out all of the "NA" occurences from weight, hindfoot_length, and sex.
# Call it a new variable. 

data_complete <- data %>%
  filter(!is.na(weight),           
         !is.na(hindfoot_length),  
         !is.na(sex))  

data_complete

# The plot() function is the simplest form to make a quick graph in R. Here, we use 
# the $ sign to refer to the new variable we just made, "data_complete", that doesn't
# include NAs. If you didn't include this and just put hindfoot_length and weight,
# R might refer back to our original data set. 

plot(data_complete$hindfoot_length, data_complete$weight)

# xlab() --> labels the x-axis
# ylab() --> labels the y-axis
# main   --> labels the title
plot(data_complete$hindfoot_length, data_complete$weight, xlab = "Hindfoot Length (mm)", 
     ylab = "Weight (g)", main = "Animal Weight and Hindfoot Length")

# How to export a graph:
# The easiest way to save a plot would be using the "Export" button in the "Plots" tab. There 
# are several options here for file type and size. 

#---- Data visualization with ggplot2----

# Use the ggplot() function and bind the plot to a specific "DATA" frame using the data argument
# Define a mapping (using the aesthetic (aes) function), by selecting the variables 
# to be plotted and specifying how to present them in the graph, e.g. as x/y positions 
# or characteristics such as size, shape, color, etc. Add "geoms", which are graphical 
# representations of the data in the plot (points, lines, bars). ggplot2 offers many 
# different geoms that we will explore over the next couple weeks. 

# geom_point() for scatter plots, dot plots, etc.
# geom_boxplot() for boxplots
# geom_line() for trend lines, time series, etc.

# When you run this, it is empty because ggplot needs to know how you want to plot data.
ggplot(data_complete, aes(weight, hindfoot_length)) 

#Here, we are telling ggplot that we want to use points to make the graph.
ggplot(data_complete, aes(weight, hindfoot_length)) + 
  geom_point()

# Alpha is the transparency -- defaults to "1"
ggplot(data_complete, aes(weight, hindfoot_length)) + 
  geom_point(alpha=0.1, color="blue")

# Colouring according to data a specific factor in your table (e.g. species_id) using 
# the aes() within geom_point()
ggplot(data_complete, aes(weight, hindfoot_length)) + 
  geom_point(aes(color=species_id))

# Let's try using geom_jitter with this massive dataset. First, search it using the "Help"
# funtion. 

# "HOMEWORK" Questions -- if you want to try a few more things in ggplot2 with the data. 

# 1. Use what you just learned to create a scatter plot of weight over species_id with the 
# plot types showing in different colors. 

# 2. Make a boxplot graph with species_id on the x-axis, weight on the y-axis, 
# and the species_id showing different colours.

