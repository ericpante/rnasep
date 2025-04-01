############################################

# Tidying blastp outputs from the rnasep2_Trinity95_assembly

############################################


# Tidying blastp output
Tidy_blast <- function(data){
  as.data.frame(data[,1:2]) %>%
    unique() %>%
    rename(Transcript=V1) %>%
    separate(V2, into = c("DataBase", "ProteinCode", "ProteinName", "Species")) %>%
    unite("ProteinName", "ProteinName", "Species", sep="_")
}
