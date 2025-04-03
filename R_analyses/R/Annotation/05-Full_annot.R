#####################################

# Mergin Blast & EggNOG annotations

####################################

# Merging blast & EggNog annotations
Full_annot <- function(Blast,Eggnog){
  merge(Blast,Eggnog, by="Transcript", all=TRUE, no.dups=TRUE)
}
