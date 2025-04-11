###########################################

# Loading, Tidying and merging EggNOG-mapper outputs from the rnasep2_Trinity95_assembly

############################################

# 1- Loading EggNOG-mapper output files
load_eggnog <- function(file){
  read_excel(file, col_types = c("text", "text", "numeric","numeric", "text",
                                 "text", "text","text", "text", "text", "text",
                                 "text","text","text", "text", "text", "text",
                                 "text", "text", "text", "text"),
             skip=2, col_names=TRUE) %>%
    as.data.frame()
}


# 2- Tidying data
Tidy_eggnog <- function(data, other, filter_on=TRUE){
  data <- data %>%
    select(query,COG_category,Description,Preferred_name,GOs,KEGG_ko,KEGG_Pathway,PFAMs) %>%
    unique() %>%
    rename(Transcript=query,
           COG_Description=Description)
  
  if(filter_on){
    data <- data %>%
      filter(!Transcript %in% other[,1])
  }
  
  return(data)
}

# 3- Merging Eggnog outputs
Eggnog_annot <- function(x,y){
 # merge(EG,EG.nt, by="Transcript", all=TRUE, no.dups=TRUE) %>%
  #  rename(EG.nt_Description=EG_Description.y,
   #        EG.nt_Name=EG_Name.y,
    #      EG.nt_KEGG_ko=EG_KEGG_ko.y,
     #      EG.nt_KEGG_Pathway=EG_KEGG_Pathway.y)
  rbind(x,y)
}