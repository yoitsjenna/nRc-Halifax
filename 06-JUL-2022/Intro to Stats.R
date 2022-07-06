#---- nRc: Introduction to Statistics----
# Introducing some basic statistics in R -- Analysis of Variance (ANOVAs), Normality tests, etc. 

# This script & data set was originally published/written by Rebecca Bevans,
# but the script was modified for our purposes. 

#---- Install packages and Load Packages ----
# When you open R Studio, make sure in the top right corner you are still opened 
# under the same project that you created previously. If not, click on the cube and 
# open your corresponding R project. Again, download the script and
# data set and add them to the file folder that you created your project folder in. 

# Install packages -- if you already installed these packages, you do not need 
# to install them again. All you need to do is load the packages.

# Install packages
install.packages("tidyverse")
install.packages("ggpubr")
install.packages("broom")

# Use this line of code to also install all of the "dependent" packages (dependencies = TRUE)
install.packages("AICcmodavg", repos = "http://cran.rstudio.com/", dependencies = TRUE )

install.packages("report")
remotes::install_github("easystats/report")

# Load packages 
library("tidyverse")
library("ggpubr")
library("broom")
library("AICcmodavg")
library("report")

#---- Read in the data set----

# Here, when we read in the dataset, we can classify each column in the read.csv() script. 
# Header = TRUE confirms that there are column headers, colClass() classifies each of 
# the 4 columns as "factor" or "numeric". c() simply creates a list/vector to classify 
# each column. 
data_crops <- read.csv("crops.csv", header = TRUE, colClasses = c("factor", "factor", "factor", "numeric"))
data_crops

summary(data_crops)

#---- Intro to ANOVAs ----
# ANOVAs determine if the dependent variable depends on the categories of the independent 
# variable(s) 

# ANOVAs are testing hypotheses: The null hypothesis (H0) is that the dependent
# variable is NOT affected by (does NOT depend on) the categories of the independent variable.
# The alternate hypothesis (Ha) is that the dependent variable IS affected by (does depend
# on) the categories of the independent variable. 

# P-values 
# The p-value is a number, calculated from a statistical test, that describes how 
# likely you are to have found a particular set of observations if the null hypothesis were true.

# P-values are used in hypothesis testing to help decide whether to reject the null 
# hypothesis. The smaller the p-value, the more likely you are to reject the null hypothesis.

# P-value < 0.05 = significant

# F-tests
# To asses this, ANOVA calculates an F-test. The F-test compares the amount of explained 
# variance to unexplained variance. The F-test is the ratio of variance in the dependent 
# variable that's EXPLAINED by the independent variable to the variance in the dependent 
# variable that's UNEXPLAINED by the independent variable. 

# The more of the dependent variable's variance that can be explained by the independent 
# variable(s), the higher the ratio will be.

# A higher ratio (a larger F-test statistic) means that more of the dependent variable's
# variance can be explained by the independent variable's categories.

# A lower ratio (a smaller F-test statistic) means that less of the dependent variable's
# variance can be explained by the independent variable's categories. 

#---- One-way ANOVA ----

# One-way ANOVA: one categorical (discrete) independent variable, one continuous 
# dependent variable 
# For example, we could test the effects of 3 types fertilizer treatments on crop yield 

# Breaking down the aov() function: yield is dependent on fertilizer (independent variable), 
# and the data set used is data_crops. The aov() function runs the model. All of the 
# variation that is not explained by the independent variables is called residual 
# variance. 
one_way <- aov(yield ~ fertilizer, data = data_crops)  
one_way

summary(one_way)

# This is a very handy line of code that can help explain the significance of your ANOVA
# in a simple way. 
report(one_way)

# Df --> Degrees of freedom: For the independent variable (# of levels in the variable - 1), 
# which in this case is 3 - 1, so the Df is 2.

# Sum Sq --> Sum of squares: total variation between the group means and the overall mean

# Mean Sq --> Mean Sum of squares: divide the sum of squares by the Df for each parameter

# F-value --> Test statistic from the F-test: Mean square of each independent variable 
# divided by the mean square of the residuals. The larger the F value, the more likely it is 
# that the variation caused by the independent variable is real and not due to chance.

# Pr(>F) --> P-value statistic: Shows how likely it is that the F-value calculated 
# from the test would have occurred if the null hypothesis of no difference among 
# group means were true.

# So, after running the ANOVA, does fertilizer impact yield? 
# Yes, p < 0.001, so yield is significantly impacted by fertilizer. 

#---- Two-way ANOVA ----
# Two-way ANOVA: two independent variables 
# For example, we could test the effects of 3 types of fertilizer treatments AND 2 
# different planting densities on crop yield.

# Let's include fertilizer AND density in the model this time. 
two_way <- aov(yield ~ fertilizer + density, data = data_crops)
two_way

summary(two_way)

# Use the report() function to summarize. 
report(two_way)

# Adding planting density to the model seems to have made the model better: it 
# reduced the residual variance (the residual sum of squares went from 35.89 to 
# 30.765), and both planting density and fertilizer are statistically significant 
# (p-values < 0.001).

#---- Interactions between variables ----

# Sometimes you have reason to think that two of your independent variables have 
# an interaction effect rather than an additive effect.For example, in our crop 
# yield example, it is possible that planting density affects the plants’ ability 
# to take up fertilizer. This might influence the effect of fertilizer treatment in a 
# way that isn’t accounted for in the two-way model.

# To account for interactions in an ANOVA model, simply multiply the interactions instead
# of adding the interactions. 

interaction_model <- aov(yield ~ fertilizer * density, data = data_crops)

interaction_model

summary(interaction_model)

report(interaction_model)

# Is the interaction between fertilizer and density significant? 
# No: In the output table, the ‘fertilizer:density’ variable has a low F-value 
# and a high p-value, which means there is not much variation that can be 
# explained by the interaction between fertilizer and planting density

#---- Post-Hoc tests (Tukey)----

# ANOVA tells us if there are differences among group means, but not what the differences
# are. To find out which groups are statistically different from one another, you can 
# perform a Tukey’s Honestly Significant Difference (Tukey’s HSD) post-hoc test for 
# pairwise comparisons. 

tukey_two_way <- TukeyHSD(two_way)

tukey_two_way

# Which fertilizer types have significant difference between them, and which don't? 

# From the post-hoc test results, we see that there are statistically significant 
# differences (p <0.05) between fertilizer groups 3 and 1 and between fertilizer 
# types 3 and 2, but the difference between fertilizer groups 2 and 1 is not statistically 
# significant. There is also a significant difference between the two different levels 
# of planting density

#---- Graphing the Results ----

# Finding the groupwise differences
# From the ANOVA test we know that both planting density and fertilizer type are 
# significant variables. To display this information on a graph, we need to show 
# which of the combinations of fertilizer type + planting density are statistically 
# different from one another.

# To do this, we can run another ANOVA + TukeyHSD test, this time using the interaction 
# of fertilizer and planting density. We aren’t doing this to find out if the 
# interaction term is significant (we already know it’s not), but rather to find out 
# which group means are statistically different from one another so we can add this 
# information to the graph. 

tukey_plot_aov <- aov(yield ~ fertilizer:density, data=data_crops)

tukey_plot_aov

# Now, do a TukeyHSD test on this ANOVA. 

tukey_plot_test <- TukeyHSD(tukey_plot_aov)

tukey_plot_test

plot(tukey_plot_test, las = 1)

# The significant groupwise differences are any where the 95% confidence interval 
# doesn’t include zero. This is another way of saying that the p-value for these 
# pairwise differences is < 0.05.

# From this graph, we can see that the fertilizer + planting density combinations 
# which are significantly different from one another are 3:1-1:1 (read as “fertilizer 
# type three + planting density 1 contrasted with fertilizer type 1 + planting density 
# type 1”), 1:2-1:1, 2:2-1:1, 3:2-1:1,and 3:2-2:1.

# Now, let's use ggplot2 to plot the data! 

crop_graph <- ggplot(data_crops) +
                geom_point(aes(x = density, y = yield), position = position_jitter(w = 0.1, h = 0)) +
                labs(title =  "Crop yield in response to Planting Density and Three Fertilizer Treatments", 
                  x = "Planting Density Treatments", 
                  y = "Crop Yield (kg)")

crop_graph

# Let's split this up across different fertilizer treatments -- so, make 3 different graphs, one 
# for each treatment. To do this, use add facet_wrap() function. 

crop_graph_fertilizer <- ggplot(data_crops) +
                          geom_point(aes(x = density, y = yield, colour = density), position = position_jitter(w = 0.1, h = 0)) +
                          labs(title =  "Crop yield in response to Planting Density and Three Fertilizer Treatments", 
                            x = "Planting Density Treatments", 
                            y = "Crop Yield (Bushels)") +
                          facet_wrap(~ fertilizer) +
                          scale_color_manual(values = c("#000066", "#990000")) +
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

crop_graph_fertilizer

# Let's add the geom_violin function in to help model the data better. This distribution
# of data is ideal for violin plots. 
crop_graph_fertilizer <- ggplot(data_crops) +
                          geom_violin(aes(x = density, y = yield, colour = density)) +
                          geom_point(aes(x = density, y = yield, colour = density), position = position_jitter(w = 0.1, h = 0)) +                        
                          labs(title =  "Crop yield in response to Planting Density and Three Fertilizer Treatments", 
                            x = "Planting Density Treatments", 
                            y = "Crop Yield (Bushels)") +
                          facet_wrap(~ fertilizer) +
                          scale_color_manual(values = c("#000066", "#990000")) +
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

crop_graph_fertilizer

# Here is a list of default fonts: mono, sans, serif, Courier, Helvetica, Times, AvantGarde, 
# Bookman, Helvetica-Narrow, NewCenturySchoolbook, Palatino, URWGothic, URWBookman, 
# NimbusMon, URWHelvetica, NimbusSan, NimbusSanCond, CenturySch, URWPalladio, URWTimes, NimbusRom


#---- Plotting ANOVAs looking for Homogeneity of Variances and Normality----

# Check to see if your models fit the assumption of homoscedasticity.
plot(two_way)

# The diagnostic plots show the unexplained variance (residuals) across the range 
# of the observed data.Each plot gives a specific piece of information about the 
# model fit, but it’s enough to know that the red line representing the mean of 
# the residuals should be horizontal and centered on zero (or on one, in the scale-location 
# plot), meaning that there are no large outliers that would cause bias in the model.
# The normal Q-Q plot plots a regression between the theoretical residuals of a 
# perfectly-heteroscedastic model and the actual residuals of your model, so the 
# closer to a slope of 1 this is the better. This Q-Q plot is very close, with only 
# a bit of deviation. From these diagnostic plots we can say that the model fits 
# the assumption of homogeneity of variances.  

# ANOVAs and other statistical tests make certain assumptions about your data being "normal"
# so it is always good to check if your data is normally distributed when running certain 
# statistical tests. You can run a Shapiro-Wilk test by using the shapiro.test() function. You
# can run this test on one variable -- in this case, we will run it on the numeric "yield" data. 

shapiro.test(data_crops$yield)

# How you do interpret this result? It might appear that the p-value is too high, but 
# in reality, the data is considered statistically "normal" if the p-value > 0.05. Basically, 
# when this value is >0.05, it means that there is no significant difference between our data
# and a normal distribution of data. Now, we confirmed that our data is normally distributed. 

# Let's graph a simple histogram to visualize the normal distribution of our data. If 
# the data is normal, the histogram should give a "bell curve" shape. 

hist(data_crops$yield, breaks = 15) # Breaks is just the # of "breaks" that you want to have in the histogram

# What would a non-normal histogram look like?

# You can use a Q-Q plot to also visualize whether or not your data is normally distributed. 
# If the data is normal, the Q-Q plot should give a straight diagonal line.

qqnorm(data_crops$yield)

# What would a non-normal Q-Q plot look like?

#---- HOMEWORK ----

# Customize a graph of the crops data -- add error bars, change the colours, legend, etc. 
# and email your graphs to Jenna to feature in the next powerpoint! 



