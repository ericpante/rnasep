############################################

# Tidying blastp outputs from the rnasep2_Trinity95_assembly

############################################


# Tidying blast outputs
Tidy_blast <- function(data){
  as.data.frame(data[,1:2]) %>%
    unique() %>%
    rename(Transcript=V1) %>%
    separate(V2, into = c("DataBase", "ProteinCode", "ProteinName", "Species")) %>%
    unite("ProteinName", "ProteinName", "Species", sep="_")
}


# Merging blastx & blastp outputs
Blast_annot <- function(X,P){
  merge(X,P, by="Transcript", all=TRUE, no.dups=TRUE) %>%
    select(!DataBase.y) %>%
    rename(DataBase=DataBase.x,
           ProteinCodeX=ProteinCode.x,
           ProteinNameX=ProteinName.x,
           ProteinCodeP=ProteinCode.y,
           ProteinNameP=ProteinName.y)
  
}