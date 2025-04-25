###########################################################################################
#
# Script dedicated to the display of Venn diagram to compare DEGs between three conditions
# 
#
###########################################################################################
# Build Venn data from the DESeqDEG outputw
BuildVennData <- function(A,B,C){
  x <- list(A$ID,
            B$ID,
            C$ID)
  
  return(x)
}

# Displaying the VennDiagram
displayVenn <- function(x,...){
  
  venn.diagram(x, filename=NULL, ...)
}