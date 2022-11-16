#----Heatmaps and Treamaps----
### -- nRc Course n°8 -- 
### -- 16 November 2022

#---- Install and Load packages ----

# Below are all of the packages downloaded and installed last week. If you already
# have them installed, simply "load" the packages.

# Install packages

install.packages("hrbrthemes")
install.packages("viridis")
install.packages("d3heatmap")
install.packages("heatmaply")
install.packages("remotes")
remotes::install_github("d3treeR/d3treeR")
install.packages("htmlwidgets")
install.packages("vegan")

install.packages("ggraph")
install.packages("igraph")
install.packages("dendextend")
install.packages("colormap")
install.packages("kableExtra")
install.packages("heatmaply")

# Libraries
library(tidyverse)
library(hrbrthemes)
library(viridis)
library(plotly)
library(d3heatmap)
library(treemap)
library(d3treeR)
library(htmlwidgets)

library(vegan)

library(ggraph)
library(igraph)
library(tidyverse)
library(dendextend)
library(colormap)
library(kableExtra)
library(heatmaply)

# ******************************************************************************

#### 1 - Building a Treemap 


# Load dataset 

data <- read.table("All_cultures_summary.csv", header = T, sep = ",")
data
colnames(data) <- c("Group", "Genus", "Species", "Cultures", "Nb")


pdf(file = "Treemap_cultures.pdf",
    width = 15,
    height = 10)


# Plot
t <- treemap(data,
             
             # data
             index=c("Group", "Genus"),
             vSize="Nb",
             type="index",
             
             # Main
             title="",
             
             # Borders:
             border.col=c("black", "grey", "grey", "grey"),             
             border.lwds=c(4,1.5,0.1,0.1)                         
             
)

dev.off()

# treemap with more than 3 levels

td <- treemap(data,
             
             # data
             index=c("Group", "Genus", "Species", "Cultures"),
             vSize="Nb",
             type="index",
             
             # Main
             title="",
             
             # Borders:
             border.col=c("black", "grey", "grey", "grey"),             
             border.lwds=c(4,1.5,0.1,0.1)                         
             
)


# make it interactive ("rootname" becomes the title of the plot):

inter <- d3tree2( td ,  rootname = "All Cultures" )


# save the widget

saveWidget(inter, file="InterCultures.html")


# ******************************************************************************


#### 2 - Building a Cluster Dendogram

# Load the data
data2 <- read.table("amino.csv ", header=T, row.names=1, sep=",")

# Perform hierarchical cluster analysis
data2_hell <- decostand(data2,"hellinger") # perform transformation of the data
data2_dis <- vegdist(data2) # transform as distance matrix
data2_clust <- hclust(data2_dis, "ward.D") # cluster with the method "average" or "ward.D"
pdf(width=12, height=10,file='data2_cluster_hell.pdf',useDingbats=FALSE) ## save in pdf
plot(data2_clust)
dev.off()

cluster <- plot(data2_clust)

# ******************************************************************************


#### 3 - Building a Heatmap

# Load data 
data3 <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/multivariate.csv", header=T, sep=";")
colnames(data3) <- gsub("\\.", " ", colnames(data3))

# Select a few country
data3 <- data3 %>% 
  filter(Country %in% c("France", "Sweden", "Italy", "Spain", "England", "Portugal", "Greece", "Peru", "Chile", "Brazil", "Argentina", "Bolivia", "Venezuela", "Australia", "New Zealand", "Fiji", "China", "India", "Thailand", "Afghanistan", "Bangladesh", "United States of America", "Canada", "Burundi", "Angola", "Kenya", "Togo")) %>%
  arrange(Country) %>%
  mutate(Country = factor(Country, Country))

# Matrix format
mat <- data3
rownames(mat) <- mat[,1]
mat <- mat %>% dplyr::select(-Country, -Group, -Continent)
mat <- as.matrix(mat)

library(heatmaply)
h <- heatmaply(mat, 
               dendrogram = "none",
               xlab = "", ylab = "", 
               main = "",
               scale = "column",
               margins = c(60,100,40,20),
               grid_color = "white",
               grid_width = 0.00001,
               titleX = FALSE,
               hide_colorbar = TRUE,
               branches_lwd = 0.1,
               label_names = c("Country", "Feature:", "Value"),
               fontsize_row = 5, fontsize_col = 5,
               labCol = colnames(mat),
               labRow = rownames(mat),
               heatmap_layers = theme(axis.line=element_blank())
)
               

# with clustering


d <- heatmaply(mat, 
               #dendrogram = "row",
               xlab = "", ylab = "", 
               main = "",
               scale = "column",
               margins = c(60,100,40,20),
               grid_color = "white",
               grid_width = 0.00001,
               titleX = FALSE,
               hide_colorbar = TRUE,
               branches_lwd = 0.1,
               label_names = c("Country", "Feature:", "Value"),
               fontsize_row = 5, fontsize_col = 5,
               labCol = colnames(mat),
               labRow = rownames(mat),
               heatmap_layers = theme(axis.line=element_blank())
)

d 

# save the widget

saveWidget(d, file="heatmapInter.html")


# ******************************************************************************
