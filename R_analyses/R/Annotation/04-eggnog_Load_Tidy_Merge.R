###########################################

# Loading, Tidying and merging EggNOG-mapper outputs from the rnasep2_Trinity95_assembly

############################################

# 1- Loading EggNOG-mapper output files
load_eggnog <- function(file3){
  read_excel(file3, col_types = c("text", "text", "numeric","numeric", "text",
                                 "text", "text","text", "text", "text", "text",
                                 "text","text","text", "text", "text", "text",
                                 "text", "text", "text", "text"),
             skip=2, col_names=TRUE)
}


# 2- Tidying data
Tidy_eggnog <- function(data){
  as.data.frame(data) %>%
    select(query,COG_category,Description,Preferred_name,GOs,KEGG_ko,KEGG_Pathway) %>%
    rename(Transcript=query,
           EG_KOG=COG_category,
           EG_Description=Description,
           EG_Name=Preferred_name,
           EG_GOs=GOs,
           EG_KEGG_ko=KEGG_ko,
           EG_KEGG_Pathway=KEGG_Pathway)
}

# 3- Merging Eggnog outputs
Eggnog_annot <- function(EG.nt,EG){
  merge(EG,EG.nt, by="Transcript", all=TRUE, no.dups=TRUE) %>%
    rename(EG.nt_Description=EG_Description.y,
           EG.nt_Name=EG_Name.y,
           EG.nt_GOs=EG_GOs.y,
           EG.nt_KEGG_ko=EG_KEGG_ko.y,
           EG.nt_KEGG_Pathway=EG_KEGG_Pathway.y)
  
}