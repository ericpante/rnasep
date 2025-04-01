###########################################

# Loading and Tidying EggNOG-mapper outputsfrom the rnasep2_Trinity95_assembly

############################################

load_eggnog <- function(file3){
  read_excel(file3, col_types = c("text", "text", "numeric","numeric", "text",
                                 "text", "text","text", "text", "text", "text",
                                 "text","text","text", "text", "text", "text",
                                 "text", "text", "text", "text"),
             skip=2, col_names=TRUE)
}


Tidy_eggnog <- function(data){
  as.data.frame(data) %>%
    select(query,Description,Preferred_name,GOs,KEGG_ko,KEGG_Pathway) %>%
    rename(Transcript=query,
           EG_Description=Description,
           EG_Name=Preferred_name,
           EG_GOs=GOs,
           EG_KEGG_ko=KEGG_ko,
           EG_KEGG_Pathway=KEGG_Pathway)
}
