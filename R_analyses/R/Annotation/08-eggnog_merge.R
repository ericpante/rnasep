############################################

# Merging EggNog outputs from the rnasep2_Trinity95_assembly

############################################

# Merging Eggnog outputs
Eggnog_annot <- function(EG.nt,EG){
  merge(EG,EG.nt, by="Transcript", all=TRUE, no.dups=TRUE) %>%
    rename(EG.nt_Description=EG_Description.y,
           EG.nt_Name=EG_Name.y,
           EG.nt_GOs=EG_GOs.y,
           EG.nt_KEGG_ko=EG_KEGG_ko.y,
           EG.nt_KEGG_Pathway=EG_KEGG_Pathway.y)
  
}