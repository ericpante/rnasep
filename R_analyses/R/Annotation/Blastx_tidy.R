############################################

# Loading and tidying blastx outputs from the rnasep2_Trinity95_assembly

############################################

# Loading blastx output
load_blastx <- function(file1){
  read.table(file1, sep="\t")
}


# Tidying blastx output
Tidy_blastx <- function(blastx){
  as.data.frame(blastx[,1:2]) %>%
    unique() %>%
    rename(Transcript=V1) %>%
    separate(V2, into = c("DataBase", "ProteinCode", "ProteinName", "Species")) %>%
    unite("ProteinName", "ProteinName", "Species", sep="_")
}
