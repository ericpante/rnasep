####################################################
#
#   Constructing module eigengenes                 #
#
####################################################


# Build dissimilarity matrix
TOMdissim <- function(ADJACENCY){
  TOM <- TOMsimilarity(ADJACENCY) # Similarity
  NegTOM <- 1-TOM # Dissimilarity
  
  rownames(NegTOM) <- rownames(ADJACENCY)
  colnames(NegTOM) <- colnames (ADJACENCY)
  
  return(NegTOM)
}

# Module construction and merge
TreeGene <- function(matrix){
  geneTree <- hclust(as.dist(matrix), method="average")
}

BuildModules <- function(DENDRO, matrix){
  cutreeDynamic(dendro=DENDRO, distM=matrix, deepSplit = 2, pamRespectsDendro = FALSE, minClusterSize = 30)
}
  
MEColors <- function(Modules, ADJACENCY){
  lab <- labels2colors(Modules) %>%
    as.data.frame()
  
  rownames(lab) = rownames(ADJACENCY)
  
  return(lab)
}  
  

MEdissim <- function(Exp.Matrix, ModColors){
  
  Colors <- ModColors[,1]
  
  MElist <- moduleEigengenes(Exp.Matrix, colors = Colors)
  ME.dissimilarity = 1-cor(MElist$eigengenes, use="complete") #Calculate eigengene dissimilarity
  
  return(ME.dissimilarity)
}

mergeModules <- function(Exp.Matrix,ModColors){
  Colors <- ModColors[,1]
  
  mergeCloseModules(Exp.Matrix, Colors, cutHeight = .25)
}
  

retrieveMergedME <- function(obj){
  a <- obj$newMEs
  
  return(a)
}

retrieveMergedColors <- function(obj, ModColors){
  a <- obj$colors %>%
    as.data.frame()
  
  rownames(a) = rownames(ModColors)
  return(a)
}



# Plot dendogram & modules
plotDendroColors <- function(GENETREE,ModCol,MergeCol,path){

  png(path)
 
  plotDendroAndColors(GENETREE, cbind(ModCol, MergeCol), 
                      c("Original Module", "Merged Module"),
                      dendroLabels = FALSE, hang = 0.03,
                      addGuide = TRUE, guideHang = 0.05,
                      main = "Gene dendrogram and module colors for original and merged modules")
  dev.off()
  path
}
