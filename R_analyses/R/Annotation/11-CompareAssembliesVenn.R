###############################################################################
#
# Script dedicated to the display of Venn diagram to compare Trinity assemblies
# from rnasep1 & 2
#
###############################################################################

# Build Venn data from the gff3 and blast files.
BuildVennData <- function(fileA, fileB, fileC){
  
  # Loading files
  sep1 <- read.delim(fileA, header=FALSE)
  sep2 <- read.delim(fileB, header=FALSE)
  blast <- read.delim(fileC, header=FALSE)
  
  # Changing col names for sep1 & 2
  colnames(sep1) <- c("Transcript", "2", "Type", "4", "5", "6", "7", "8", "9")
  colnames(sep2) <- c("Transcript", "2", "Type", "4", "5", "6", "7", "8", "9")
  
  # Tidying Sep1 & 2, adding X col to Sep1
  TidySep1 <- sep1 %>%
    filter(Type == "mRNA") %>%
    separate(9, sep =";", into=c("A", "B", "C")) %>%
    separate(A, sep="=", into=c("A", "ID")) %>%
    select(ID) %>%
    mutate(X = "NA")
  
  TidySep2 <- sep2 %>%
    filter(Type == "mRNA") %>%
    separate(9, sep =";", into=c("A", "B", "C")) %>%
    separate(A, sep="=", into=c("A", "ID")) %>%
    select(ID)
  
  # Tidying Blast file
  BLAST <- blast %>%
    select(V1, V2) %>%
    unique()
  
  # Building a common ID between sep1 & 2 (needed for comparing both datasets)
  TidySep1$X <- ifelse(TidySep1$ID %in% BLAST$V2,
                       BLAST$V1[match(TidySep1$ID, BLAST$V2)],
                       TidySep1$ID)
  
  # Listing Sep1 & 2 IDs in the object x
  x <- list(
    A=TidySep2$ID,
    B=TidySep1$X)
  
  return(x)
  
}

# Displaying the VennDiagram
displayVenn <- function(x,...){
  
  venn.diagram(x, filename=NULL, ...)
  
  
}