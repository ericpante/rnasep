############################################

# Loading and Tidying blastp outputs from the rnasep2_Trinity95_assembly

############################################

# Loading blastp output
load_blastp <- function(file2){
  read.table(file2, sep="\t")
}

# Tidying blastp output
Tidy_blastp <- function(blastp){
  as.data.frame(blastp[,1:2]) %>%
    unique() %>%
    rename(Transcript=V1) %>%
    separate(Transcript, into=c("Transcript", "ORF"), sep=".p") %>%
    separate(V2, into = c("DataBase", "ProteinCode", "ProteinName", "Species")) %>%
    unite("ProteinName", "ProteinName", "Species", sep="_") %>%
    select(!ORF)
}
