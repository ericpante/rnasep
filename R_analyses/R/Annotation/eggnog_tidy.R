###########################################

# Loading and Tidying EggNOG-mapper outputsfrom the rnasep2_Trinity95_assembly

############################################


load_eggnog.nt <- function(file3){
  read_excel(file3, col_types = c("text", "text", "numeric","numeric", "text",
                                 "text", "text","text", "text", "text", "text",
                                 "text","text","text", "text", "text", "text",
                                 "text", "text", "text", "text"))
}


Tidy_eggnog.nt <- function(eggnog.nt){
  as.data.frame(eggnog.nt) %>%
    select(query,Description,Preferred_name,GOs) %>%
    rename(Transcript=query,
           EG_Description=Description,
           EG_Name=Preferred_name) %>%
    unique()
}
