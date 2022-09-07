#---- nRc: Multivariate Statistics and Graphing ----

# Please download AND load the list of packages before today's learning session. A lot 
# of these are packages that we will not necessarily be using today, but we will be using 
# most of them in the next couple sessions. Remember to look for errors, but don't 
# get caught up in all the warnings. 

# Today's script will look at Principal Component Analysis (PCA) and Principal Coordinate 
# Analysis (PCoA). 

# PCoA is similar to PCA and correspondence analysis (CA) which preserve 
# Euclidean and chi-squared distances between objects, respectively; however, PCoA can 
# preserve distances generated from any (dis)similarity measure allowing more flexible 
# handling of complex ecological data. PCoA commonly uses Bray-Curtis distance matrices.
# PCA is commonly used for similarities and PCoA for dissimilarities.

# For multivariate data, you can decide which will work best for you, however, my 
# preference is generally using PCoA. Do a few simple google searches to see which would 
# work better for you. 

#--- Install and Load Packages ----

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


# Ensure that the "sample" and the "genus" columns are listed as factors.

# How can we view "aa_data" in a new tab? 

view(data)

#---- Principal Component Analysis (PCA) ---- 

# There are a few different functions in R that can perform PCAs, but we will be using
# prcomp(). 

# Here are the elements involved in prcomp():
#   sdev = standard deviation of the PCs
#   rotation = matrix of variable loadings (columns are eigen vectors)
#   center = variable means (means that were substracted)
#   scale = variable standard deviations (the scaling applied to each vector)
#   x = the coordinates (scores) of the individuals (observations) on the PCs

# Before we run a PCA, we want to ensure that ONLY numeric data from our dataset
# is included in the calculation. Let's do that with a pipe!

# When in doubt, use "dplyr::" to this to show which library this command came from (meaning)
# it came from the dplyr package within "Tidyverse"

results <- data %>% 
  dplyr::select(where(is.numeric)) %>% 
  prcomp()

results

# Use names() to see what elements are included in the "results" object. Then, 
# you can use the notation results$sdev, results$rotation, results$center, results$scale, 
# or results$x to refer to a certain matrix in the "results" object. These are the 
# same elements as listed previously. 

names(results)

# So, what does does this output mean? 
# The standard deviations matrix is the standard deviations of each PC. 
# The rotations matrix is essentially the X and Y coordinates (AKA PC1 and PC2) 
# for the loading vectors -- so in this case, for each of the amino acids. 

# When you run the summary() function on a PCA, you'll see the proportion of variance, 
# which is the amount of variance explained by each PC. You'll also see the cumulative
# proportion of variance, which, when added together, will give 100% or 1. 

summary(results)

# The calculation for the varianced explained by each PC is the standard deviation squared
# divided by the sum of the standard deviation squared, then multiplied by 100 to 
# make the number a %. 
pcvar <- ((results$sdev^2)/(sum(results$sdev^2))) * 100

pcvar

# Now, let's plot our PCA. There are several ways to do this -- but I'm going to stick with 
# ggplot so it will allow more options for customization. 

# You can graph your PCA in a couple different ways -- plotting the individuals (samples)
# separate from the variables (amino acids), or graphing them together on the same graph. 

# Here, we will introduce some new functions to use within ggplot: 
# - geom_text_repel() tells the labels of the points to repel each other and minimize 
# overlapping. 
# - geom_vline() is the vertical line at x = 0
# - geom_hline() is the verical line at y = 0. 
#     These two functions highlight the 0,0 intercept and can be customized to be dotted, 
#     dashed, solid, etc. 
# - scale_color_manual() manually sets the colours -- I wanted for each of the 4 Genus categories. 
# - labs() customizes the x and y labels. Here, we use the paste0() and the round() 
#   functions to include the calculated PC1 and PC2 values. Hard-coding numbers into 
#   an axis title is often a bad idea in case you go back and alter/edit the data. 

# PCA for the individuals

a <- results$x %>%
  cbind(data) %>% 
  ggplot() + 
  geom_point(aes(x = PC1, y = PC2, col = genus), size = 4, alpha = 0.6) +
  geom_text_repel(aes(label = sample, x = PC1, y = PC2, col = genus), size = 2.5, show.legend = FALSE, max.overlaps = Inf) +
  geom_vline(xintercept = 0, linetype = "dotted", color = "grey") +
  geom_hline(yintercept = 0, linetype = "dotted", color = "grey") +
  scale_color_manual(name="Genus", values=c("maroon1", "steelblue3", "olivedrab3", "seagreen3")) +
  labs(x = paste0("PC1: ", round(pcvar[1], 1), "%"),
       y = paste0("PC2: ", round(pcvar[2], 1), "%")) +
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

a 

# PCA for the loadings 

b <- results$rotation %>%
  ggplot() + 
  geom_point(aes(x = PC1, y = PC2), size = 3, color = "mediumorchid3", alpha = 0.6) +
  geom_text_repel(aes(label = rownames(results$rotation), x = PC1, y = PC2),  color = "mediumorchid3", size = 2.5, max.overlaps = Inf) +
  geom_vline(xintercept = 0, linetype = "dotted", color = "grey") +
  geom_hline(yintercept = 0, linetype = "dotted", color = "grey") +
  labs(x = paste0("PC1: ", round(pcvar[1], 1), "%"),
       y = paste0("PC2: ", round(pcvar[2], 1), "%")) +
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

b

# Let's combine both the individuals and the loadings figures together
ggarrange(a, b, labels = c("A", "B"), common.legend = FALSE, legend = "bottom") 


# There is also a way to combine the loadings and individuals on the same graph-- 
# this would add the the loadings as arrow vectors overlaying the individuals. 

library(devtools)
install_github("vqv/ggbiplot")
library("ggbiplot")

ggbiplot(results)

ggbiplot(results, obs.scale = 1, var.scale = 1, groups = genus, circle = TRUE,  alpha = 0.6) +
  geom_text_repel(aes(label = sample, col = genus), size = 2.5, show.legend = FALSE, max.overlaps = Inf) +
  geom_vline(xintercept = 0, linetype = "dotted", color = "grey") +
  geom_hline(yintercept = 0, linetype = "dotted", color = "grey") +
  scale_color_manual(name="Genus", values=c("maroon1", "steelblue3", "olivedrab3", "seagreen3")) +
  theme(legend.direction ="horizontal", 
        legend.position = "bottom",
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

# Homework Challenge #1
# Customize ggbiplot() similar to how you would with ggplot.

# Homework Challenge #2
# Using this data, and what you already know about ggplot, try plotting a PCA using 
# ggplot instead of ggbiplot. Customize it! 
