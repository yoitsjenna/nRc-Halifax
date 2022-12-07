# nRc: Spectral processing, binning, and analysis

# This script is from Bryan Hanson and modified for our purposes, focusing mainly on 
# IR and NMR, but can be made to work with different spectra (UV-VIS, etc.). 

# I encourage you to check out the links below for more info about the type of IR data
# used in this example. 

# https://cran.r-project.org/web/packages/ChemoSpec/vignettes/ChemoSpec.pdf
# https://cran.r-project.org/web/packages/ChemoSpec/ChemoSpec.pdf
# https://bryanhanson.github.io/ChemoSpec/

#---- ChemoSpec Package ----

# Install and load packages
library("ggplot2")
library("tidyverse")

install.packages("ChemoSpec")
library("ChemoSpec")

install.packages("baseline")
library("baseline")

install.packages("amap")
library("amap")

#To open huge text files in R, it is easier to use the "data.table" package and 
# the fread() function, which turns the text file into a data table. This data table
# is also a data frame. 
install.packages("data.table")
library("data.table")

?fread

# Ways of importing spectra data to R:
#   1. "files2SpectraObject" function --> assumes your raw data exists as separate
#       files in a single directory, each file containing a 'frequency' column and an 
#       intensity column. 
#   2. "matrix2SpectraObject" function --> assumes you have a single file containing 
#       a matrix of all the data. This matrix should have frequencies in the first column
#       and individual sample intensities in the remaining columns. 

?files2SpectraObject

?matrix2SpectraObject

# The output of importing the data in either of these ways is referred to as a 
# "Spectra" object. The objects we are using today are already in "spectra" form. 

?Spectra

# For today's tutorial, the datasets are already an object in R. You still need to 
# copy them to your project folder from the "Downloads" section on your computer. 

?SrE.IR # You can even use the "?" function on R objects like this spectra object. 

# The data() will load the R datasets for you to use.The sumSpectra() function 
# summarizes any "Spectra" or "Spectra2D" object. Remember, to use this summarize function, 
# you must make sure your data is a spectra object. 

?sumSpectra()

data(SrE.IR) # Quotation marks or no quotation marks 
sumSpectra(SrE.IR)

#---- Plotting Spectra ----

?reviewAllSpectra

?plotSpectra # General use and publication-quality graphics -- use the "help" function 
             # to see what you can manipulate within the plotSpectra() function.

?plotSpectraJS # Interactive version of plotSpectra

IRspectra1 <- plotSpectra(SrE.IR, which = c(1, 2, 14, 16), yrange = c(0, 1.6),
                 offset = 0.4, lab.pos = 2200)
IRspectra1


IRspectra2 <- plotSpectra(SrE.IR, which = c(1, 2, 14, 16), yrange = c(0, 0.6),
                 offset = 0.1, lab.pos = 1775)
IRspectra2

# This last graph of the spectra provides a zoomed-in portion at specific x-coordinates.

IRspectra3 <- IRspectra2 + coord_cartesian(xlim = c(1650, 1800))

IRspectra3

# IR spectra are often showed inverted, reflecting %T instead of absorbance along the Y-axis.
# Choose the method that works with your type of data (in terms of structure). 


# There will be a warning about the coordinate system already present, but 
# the graph will still work. 

#---- Data Processing -----

# Correcting baseline drift

?baselineSpectra

# Depending on the type of data you have (NMR, IR, etc.) will affect which type of method
# algorithm you will want to use. The types of methods included in the "baseline" 
# package include...
# 1. 'als': Baseline correction by 2nd derivative constrained weighted regression
# 2. 'fillPeaks': An iterative algorithm using suppression of baseline by means in local windows
# 3. 'irls' (default): An algorithm with primary smoothing and repeated baseline suppressions and regressions with 2nd derivative constraint
# 4. 'lowpass': An algorithm for removing baselines based on Fast Fourier Transform filtering
# 5. 'medianWindow': An implementation and extention of Mark S. Friedrichs' model-free algorithm
# 6. 'modpolyfit': An implementation of Chad A. Lieber and Anita Mahadevan-Jansen's algorithm for polynomial fiting
# 7. 'peakDetection': A translation from Kevin R. Coombes et al.'s MATLAB code for detecting peaks and removing baselines
# 8. 'rfbaseline': Wrapper for Andreas F. Ruckstuhl, Matthew P. Jacobson, Robert W. Field, James A. Dodd's algorithm based on LOWESS and weighted regression
# 9. 'rollingBall': Ideas from Rolling Ball algorithm for X-ray spectra by M.A.Kneen and H.J. Annegarn. Variable window width has been left out

SrE2.IR <- baselineSpectra(SrE.IR, int = FALSE, method = "modpolyfit", retC = TRUE)

SrE2.IR

summary(SrE2.IR)


# For some spectral datasets, alignment may be necessary, and can be done using  the 
# clupaSpectra() function to perform hierarchical cluster-based alignment. Note -- to perform
# this analysis, you need to make sure your data is in the form of a spectra object. 

?clupaSpectra

#---- Bucketing/Binning and Normalization data ----

# Depending on your type of data, you may need to further process your data into bins. 
# The binSpectra() function bins a spectra based on the given bin.ratio. The IR data is 
# a small dataset

?binSpectra

binnedIR1 <- binSpectra(SrE.IR, bin.ratio = 4)

sumSpectra(binnedIR1)

binnedIR2 <- binSpectra(SrE2.IR, bin.ratio = 4)

sumSpectra(binnedIR2)

# To normalize spectral data after this processing, use the function normSpectra(). 
# There are 4 different normalization 'methods':
# 1. "PQN"
# 2. "TotInt"
# 3. "Range"
# 4. "zero2one"

?normSpectra # To learn more about each normalization method

#---- Removing points or groups ----

# Imagine we want to get rid of sample "TD_adSrE". 
noTD <- removeSample(SrE2.IR, rem.sam = c("TD_adSrE"))
sumSpectra(noTD)

# A similar function, removeGroup() can remove a group within the "groups" section of 
# a spectral datasest. 

#---- Removing Regions in the Spectra ----

# There are 2 functions, surverySpectra() and surveySpectra2() that present computed  
# summary statistics (of your choice) of the intensities at a particular frequency 
# across the data set. 

graph1 <- surveySpectra(SrE2.IR, method = "iqr", by.gr = FALSE)
graph1

graph2<- surveySpectra2(SrE2.IR, method = "iqr")
graph2

# Let's take a look at the detail surrounding the carbonyl region. 
p <- surveySpectra(SrE2.IR, method = "iqr", by.gr = FALSE)
p <- p + ggtitle("Detail of Carbonyl Region") + coord_cartesian(xlim = c(1650, 1800))
p

p <- surveySpectra(SrE2.IR, method = "iqr", by.gr = TRUE)
p <- p + ggtitle("Detail of Carbonyl Region") + coord_cartesian(xlim = c(1650, 1800))
p

p <- surveySpectra(SrE2.IR, method = "iqr", by.gr = FALSE)
p <- p + ggtitle("An Uninteresting Region") +
  coord_cartesian(xlim = c(1800, 2500), ylim = c(0.0, 0.03))
p

# Let's create a new spectra object by removing the unwanted regions. 
SrE3.IR <- removeFreq(SrE2.IR, rem.freq = SrE2.IR$freq > 1800 & SrE2.IR$freq < 2500)
sumSpectra(SrE3.IR)

# Check for gaps in the frequency data. 
check4Gaps(SrE3.IR$freq, SrE3.IR$data[1,])

#---- Clustering ----

?hcaSpectra

HCA <- hcaSpectra(SrE3.IR)
HCA

# You can customize the distance method (d.method) to suit your type of data!
# Here are the options to compute the distance between rows of a matrix: 
# "cosine", "euclidean", "maximum", "manhattan", "canberra", "binary", "pearson", 
# "correlation", "spearman", "kendall", "abspearson", "abscorrelation".

#---- 