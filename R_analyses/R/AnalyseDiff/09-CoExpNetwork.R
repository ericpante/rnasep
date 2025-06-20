###########################################################
#
#     Building co-expression network from DESeq2 object   #
#
###########################################################


# Check samples

checkSamples <- function(Exp.Matrix){
  gsg <- goodSamplesGenes(Exp.Matrix)
  
  check <- gsg$allOK
  
  return(check)
}


# Identify outliers
findOut <- function(Exp.Matrix){
  sampleTree <- hclust(dist(Exp.Matrix), method="average")
  
  return(sampleTree)
}

plotTree <- function(path,SAMPLETREE){
  png(path)
  par(cex=0.6);
  par(mar=c(0,4,2,0))
  plot(tar_read(sampleTree), main="Sample clustering to detect outliers", sub="",
       xlab="", cex.lab=1.5, cex.axis=1.5, cex.main=2)
  abline(h=700000, col="red")
  dev.off()
  path
}


# remove outliers
rmOut <- function(SAMPLETREE, Exp.Matrix){
  cut.sampleTree <- cutreeStatic(SAMPLETREE, cutHeight=700000, minSize=10)
  Exp.Matrix[cut.sampleTree==1,]
}

# Compute soft threshold
softThres <- function(Exp.Matrix){
  pickSoftThreshold(Exp.Matrix)
}

# Plot R^2 values as a function of the soft thresholds
plotR2 <- function(path, SPT){
  png(path)
  par(mar=c(1,1,1,1))
  plot(SPT$fitIndices[,1],SPT$fitIndices[,2],
       xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n",
       main = paste("Scale independence"))
  text(SPT$fitIndices[,1],SPT$fitIndices[,2],col="red")
  abline(h=0.80,col="red")
  dev.off()
  path
}


# Plot mean connectivity as a function of soft thresholds
plotConnect <- function(path,SPT){
  png(path)
  par(mar=c(1,1,1,1))
plot(SPT$fitIndices[,1], SPT$fitIndices[,5],
     xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n",
     main = paste("Mean connectivity"))
text(SPT$fitIndices[,1], SPT$fitIndices[,5], labels= SPT$fitIndices[,1],col="red")
abline(h=1, col="red")
}


# Compute adjacency
Adjacency <- function(Exp.Matrix,softPower){
  adjacency(Exp.Matrix, power=softPower)
  
}