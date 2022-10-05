#----nRc: Introduction to Predictive Analytics----

# Predictive models can be used to predict future, unknown events, usually
# based on historical data, machine learning, AI, etc... 

# Here are some links to check out to learn more about predictive analytics:
# http://uc-r.github.io/predictive

#----Install and Load Packages----

# New package
install.packages("class")
library("class")

# Load the old package
library("tidyverse")

#----Load the Dataset----

# This breast cancer dataset is from the University of California Irvine Machine 
# Learning Repository:
# https://archive-beta.ics.uci.edu/ml/datasets/breast+cancer+wisconsin+original

data <- read.csv("cancer.csv")

data

str(data)

# From examining the structure, we see that bare_nucleoli is listed as a "character" 
# rather than numeric. Let's fix that! 

data$bare_nucleoli <- as.numeric(data$bare_nucleoli)

str(data$bare_nucleoli)

# Double-check to make sure it is listed as "numeric" now. 
str(data)

#----K-nearest Neighbour Classification----

# Let's clean up our data before starting the model. We need to get rid of the rows
# with missing data -- they won't be able to be working into this model. Here, we will 
# do this using the complete.cases() function. 

?complete.cases()

cancerdata <- data[complete.cases(data),]

cancerdata

#Let's make sure our structure is still the same -- should just be less observations. 
str(cancerdata)

# The last column in our dataset ("class") is our "resultant variable", AKA if the tumour is
# cancerous or not. Now, let's transform the "class" column (which has numbers 2 and 4) 
# into benign and malignant. 

cancerdata$class <- factor(ifelse(cancerdata$class == "2", "benign", "malignant"))

cancerdata$class

str(cancerdata)

# In this example, we will be using K-nearest neighbour Classification using Euclidean 
# distances to make predictions. Here, the "distances" being measured are the distances
# between to the "nearest neighbour" each point. 

# Data Splicing to build the model:
# You can split your data into two sets -- a training set of data, and a testing set.
# Make sure the training set always has MORE datapoints. 

# You'll notice as I set up these variables, I'm omitting the 10th column ("class"), 
# which identifies the outcome variable. When testing and training data, you want the 
# machine to figure out the output. 

trainingSet <- cancerdata[1:477, 1:9]

testingSet <- cancerdata[478:683, 1:9]

# These are the true outcomes. They are split the same way as the training and testing sets. 

trainingOutcomes <- cancerdata[1:477, 10]

testingOutcomes <- cancerdata[478:683, 10]


# Apply KNN algorithm to trainingSet and trainingOutcomes
#   "train" -- data frame of the training set which will help build the model
#   "test" -- data frame of test cases, used to test the model 
#   "cl" -- this is the TRUE classification of the training set
#   "k" is the number of neighbours considered

# k = 21, which means the model will take into account the 21 closest neighbours. 
# This is the square root of 477, which is the total number of samples in the training set of data. 
# If k = 1, then ONLY the ONE closest neighbour would be taken into consideration.

predictions <- knn(train = trainingSet, cl = trainingOutcomes, k = 21, test = testingSet)

# Printing this will show the predictions of the model 
predictions

# Model evaluations - This compares our predictions that were made in the model to the 
# actual recorded outcomes (AKA if the tumour is benign or malignant)
table(testingOutcomes, predictions)




