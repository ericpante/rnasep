############################################

# Merging blastx & blastp & EggNog outputs from the rnasep2_Trinity95_assembly

############################################

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