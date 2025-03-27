############################################

# Merging blastx & blastp outputs from the rnasep2_Trinity95_assembly

############################################

# Merging blastx & blastp output
Merge_blast <- function(X,P){
  merge(X,P, by="Transcript", all=TRUE, no.dups=TRUE) %>%
    select(!DataBase.y) %>%
    rename(DataBase=DataBase.x,
           ProteinCodeX=ProteinCode.x,
           ProteinNameX=ProteinName.x,
           ProteinCodeP=ProteinCode.y,
           ProteinNameP=ProteinName.y)
    
}
