###############################################################################
#
# Script dedicated to the display of Venn diagram to compare Trinity assemblies
# from rnasep1 & 2
#
###############################################################################

fileA="data/annotation/Trinity_rnasep1.Trinity95.fasta.transdecoder.cds"
fileB="data/annotation/Trinity_rnasep2.Trinity95.fasta.transdecoder.cds"
fileC="data/annotation/SEP1.SEP2.blastn.outfmt6"


# Build Venn data from the gff3 and blast files.
BuildVennData <- function(fileA, fileB, fileC){
  
  # Loading files
  sep1 <- read.delim(fileA, header=FALSE, sep=" ")
  sep2 <- read.delim(fileB, header=FALSE, sep=" ")
  blast <- read.delim(fileC, header=FALSE)
  
  # Keep only headers
  Sep1 <- sep1[grepl("^>TRINITY", sep1$V1),]
  Sep2 <- sep2[grepl("^>TRINITY", sep2$V1),]
  
  # Remonving undesired characters from the variable V1
  Sep1$V1 <- gsub(">", "", Sep1$V1)
  Sep2$V1 <- gsub(">", "", Sep2$V1)
  
  Sep1$X <- "NA"
  
  # Changing col names for sep1 & 2
#  colnames(sep1) <- c("Transcript", "2", "Type", "4", "5", "6", "7", "8", "9")
 # colnames(sep2) <- c("Transcript", "2", "Type", "4", "5", "6", "7", "8", "9")
  
  # Tidying Sep1 & 2, adding X col to Sep1
#  TidySep1 <- sep1 %>%
#    filter(Type == "mRNA") %>%
#    separate(9, sep =";", into=c("A", "B", "C")) %>%
#    separate(A, sep="=", into=c("A", "ID")) %>%
#    select(ID) %>%
#    mutate(X = "NA")
  
#  TidySep2 <- sep2 %>%
#    filter(Type == "mRNA") %>%
#    separate(9, sep =";", into=c("A", "B", "C")) %>%
#    separate(A, sep="=", into=c("A", "ID")) %>%
#    select(ID)
  
  # Tidying Blast file
  BLAST <- blast %>%
    dplyr::select(V1, V2) %>%
    unique()
  
  # Building a common ID between sep1 & 2 (needed for comparing both datasets)
  Sep1$X <- ifelse(Sep1$V1 %in% BLAST$V2,
                       BLAST$V1[match(Sep1$V1, BLAST$V2)],
                       Sep1$V1)
  
  # Listing Sep1 & 2 IDs in the object x
  x <- list(
    A=Sep2$V1,
    B=Sep1$X)
  
  return(x)
  
}

# Displaying the VennDiagram
displayVenn <- function(x,...){
  
  venn.diagram(x, filename=NULL, ...)
  
  
}