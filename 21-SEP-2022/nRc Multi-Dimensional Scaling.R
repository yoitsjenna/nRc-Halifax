#---- nRc: Multi-dimensional Scaling----
#---- Install and Load packages ----

# Below are all of the packages downloaded and installed last week. If you already
# have them installed, simply "load" the packages.

# Install packages
install.packages("vegan")
install.packages("tidyverse")
install.packages("ecodist")
install.packages("ape")
install.packages("ade4")
install.packages("labdsv")
install.packages("smacof")
install.packages("glue")
install.packages("ggalt")
install.packages("ggfortify")
install.packages("gridExtra")
install.packages("ggrepel")
install.packages("cluster")
install.packages("PERMANOVA")
install.packages("ggpubr")

install.packages("remotes")
remotes::install_github("ZhonghuiGai/ggpca")

library(devtools)
install_github("vqv/ggbiplot")
library("ggbiplot")

# Load packages
library("devtools")
library("ggbiplot")
library("vegan")
library("tidyverse")
library("ecodist")
library("ape")
library("ade4")
library("labdsv")
library("smacof")
library("glue")
library("ggalt")
library("ggfortify")
library("gridExtra")
library("ggrepel")
library("cluster")
library("PERMANOVA")
library("remotes")
library("ggpca")
library("ggpubr")

#---- Read the Dataset ---- 

# This is a subset of amino acid data (courtesy of the National Products Chemistry team) 
# that I did some stats on last year, with some modifications and renaming for the purpose of this lesson. 

# You'll notice that this dataset has a similar tabular setup to processed lipid, fatty acid, 
# mass spec, and NMR data -- all multivariate forms of data -- which means a lot of 
# the same principals we are applying to this amino acid dataset could be repeated 
# with other forms of multivariate data. 

data <- read.csv("amino_data.csv", header = TRUE, colClasses = c("factor", "factor", 
                                                                 "numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric" ))
data

# What does the structure of this data look like?

str(data)

#---- Multi-Dimensional Scaling ----
# dist() has 6 different distance metrics that can be chosen within the function:
# "euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski"

# The distance matrix you use will determine the outcome of your plot. 

numdata <- data %>% 
  dplyr::select(where(is.numeric))

numdata


?dist()

distance.matrix <- dist(numdata, method = "euclidean") # Same distance used in PCAs

distance.matrix


# Perform multi-dimensional scaling on the euclidean distance matrix.

mds.amino <- cmdscale(distance.matrix, eig = TRUE, x.ret = TRUE)

# eig = TRUE ---> We want the function to return the eigen values to calculate how much 
# variation in the matrix each axis accounts for

# x.ret = TRUE ---> We want the function to return a matrix where both the rows and the 
# columns are centered -- this can be used when using other MDS functions. 

mds.amino


# Calculate the percent variance -- AKA the values for each principal coordinate. 

mds.var.per <- round(mds.amino$eig/sum(mds.amino$eig)*100, 1)

mds.var.per

# Format the data for ggplot. First, lets make a data frame with the new points

mds.values <- mds.amino$points

mds.values

mds.data <- data.frame(X = mds.amino$points[,1], Y = mds.amino$points [,2])

mds.data


#Let's plot the data!

mds.data %>% 
  cbind(data) %>% 
  ggplot()+
  geom_point(aes(x = X, y = Y, col = genus), size = 4, alpha = 0.6)+
  geom_text_repel(aes(label = sample, x = X, y = Y, col = genus), size = 2.5, show.legend = FALSE, max.overlaps = Inf) +
  geom_vline(xintercept = 0, linetype = "dotted", color = "grey") +
  geom_hline(yintercept = 0, linetype = "dotted", color = "grey") +
  scale_color_manual(name="Genus", values=c("maroon1", "steelblue3", "olivedrab3", "seagreen3")) +
  labs(x = paste0("MDS1: ", round(mds.var.per[1], 1), "%"),
       y = paste0("MDS2: ", round(mds.var.per[2], 1), "%")) +
  theme(legend.direction ="vertical", 
        legend.position = "right",
        legend.background = element_rect(fill="white"),
        legend.title = element_text(colour="black", size=11, face="plain"), 
        legend.text = element_text(colour="black", size = 8, face = "plain"), 
        legend.text.align = 0, 
        legend.key=element_blank(),
        legend.title.align = 0, 
        text=element_text(family="Helvetica"),
        panel.background = element_rect(fill="white",colour="grey",size=1.2,linetype="solid"), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) 


# This graph looks very similar (the SAME) to our PCA graph from last week -- this is because 
# the type of distance matrix is the same!


