#morphometrics
#August 13, 2020

#This script will get us started on morphometrics analysis using Generalized Procrustes Analysis
#This is a method for quantifying shape by removing the effects of size and orientation from the data
#this will rely heavily on the geomoph package from Adams et al.
#install_github("vqv/ggbiplot")

library(stats)
library(geomorph)
library(devtools)
library(ggbiplot)



#working dir
setwd("~/Documents/morphometrics")

#Input data from salamanders
data<-readland.tps("test.tps", specID = c("imageID"), readcurves = FALSE, warnmsg = TRUE)
View(data)

#The function performs a Generalized Procrustes Analysis (GPA) on two-dimensional or three-dimensional landmark coordinates. The analysis can be performed on fixed landmark points, semilandmarks on curves, semilandmarks on surfaces, or any combination. If data are provided in the form of a 3D array, all landmarks and semilandmarks are contained in this object. If this is the only component provided, the function will treat all points as if they were fixed landmarks. To designate some points as semilandmarks, one uses the "curves=" or "surfaces=" options (or both). To include semilandmarks on curves, a matrix defining which landmarks are to be treated as semilandmarks is provided using the "curves=" option. This matrix contains three columns that specify the semilandmarks and two neighboring landmarks which are used to specify the tangent direction for sliding. The matrix may be generated using the function define.sliders). Likewise, to include semilandmarks on surfaces, one must specify a vector listing which landmarks are to be treated as surface semilandmarks using the "surfaces=" option. The "ProcD=FALSE" option (the default) will slide the semilandmarks based on minimizing bending energy, while "ProcD=TRUE" will slide the semilandmarks along their tangent directions using the Procrustes distance criterion. The Procrustes-aligned specimens may be projected into tangent space using the "Proj=TRUE" option. The function also outputs a matrix of pairwise Procrustes Distances, which correspond to Euclidean distances between specimens in tangent space if "Proj=TRUE", or to the geodesic distances in shape space if "Proj=FALSE". NOTE: Large datasets may exceed the memory limitations of R.

#Generalized Procrustes Analysis (GPA: Gower 1975, Rohlf and Slice 1990) is the primary means by which shape variables are obtained from landmark data (for a general overview of geometric morphometrics see Bookstein 1991, Rohlf and Marcus 1993, Adams et al. 2004, Zelditch et al. 2012, Mitteroecker and Gunz 2009, Adams et al. 2013). GPA translates all specimens to the origin, scales them to unit-centroid size, and optimally rotates them (using a least-squares criterion) until the coordinates of corresponding points align as closely as possible. The resulting aligned Procrustes coordinates represent the shape of each specimen, and are found in a curved space related to Kendall's shape space (Kendall 1984). Typically, these are projected into a linear tangent space yielding Kendall's tangent space coordinates (i.e., Procrustes shape variables), which are used for subsequent multivariate analyses (Dryden and Mardia 1993, Rohlf 1999). Additionally, any semilandmarks on curves and surfaces are slid along their tangent directions or tangent planes during the superimposition (see Bookstein 1997; Gunz et al. 2005). Presently, two implementations are possible: 1) the locations of semilandmarks can be optimized by minimizing the bending energy between the reference and target specimen (Bookstein 1997), or by minimizing the Procrustes distance between the two (Rohlf 2010). Note that specimens are NOT automatically reflected to improve the GPA-alignment.

#to see the procrustes data text
sal_data<-data[c(1:2,5:11),,]
sal.out<-gpagen(sal_data, PrinAxes = FALSE)
View(sal_data)

#to plot the data
#number rows is number of points landmarked for your specimens

####### What are the small points and big points?
####### How do you reflect legs?
plot(sal.out)

sal.out$coords
plot(sal.out$coords)

#export the procrustes data
write.csv(sal.out$coords, "salOut.csv", row.names = FALSE)

#PCA
#https://www.datacamp.com/community/tutorials/pca-analysis-r
#which are similar and which are different, showing underlying data structure. They are the directions where there is the most variance, the directions where the data is most spread out. This means that we try to find the straight line that best spreads the data out when it is projected along it. This is the first principal component, the straight line that shows the most substantial variance in the data.

#PCA is a type of linear transformation on a given data set that has values for a certain number of variables (coordinates) for a certain amount of spaces. This linear transformation fits this dataset to a new coordinate system in such a way that the most significant variance is found on the first coordinate, and each subsequent coordinate is orthogonal to the last and has a lesser variance. In this way, you transform a set of x correlated variables over y samples to a set of p uncorrelated principal components over the same samples.

#Where many variables correlate with one another, they will all contribute strongly to the same principal component. Each principal component sums up a certain percentage of the total variation in the dataset. Where your initial variables are strongly correlated with one another, you will be able to approximate most of the complexity in your dataset with just a few principal components. As you add more principal components, you summarize more and more of the original dataset. Adding additional components makes your estimate of the total dataset more accurate, but also more unwieldy.

sal <- read.csv(file="salOut.csv")
sal.pca <- prcomp(sal, center=TRUE, scale=TRUE)
summary(sal.pca)
#PC1 55%, PC2 46%

ggbiplot(sal.pca)
str(sal.pca)








