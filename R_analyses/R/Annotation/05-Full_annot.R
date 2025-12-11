#####################################

# Mergin Blast & EggNOG annotations

####################################

# Prepare SwissProt GOs

SwissGO <- function(PATH1, PATH2) {
  
  GO.mollusca <- read.delim(PATH1, header=FALSE)
  GO <- read.delim(PATH2, header=FALSE)
  
  GO.mollusca <- GO.mollusca %>%
    dplyr::group_by(V1) %>%
    dplyr::summarise(across(
      .cols = everything(),
      .fns = ~ {
        vals <- unique(.x[.x != "-" & .x != "" & !is.na(.x)])
        if (length(vals) == 0) "-" else paste(vals, collapse = ";")
      }
    ))
  
  
  GO <- GO %>%
    dplyr:: group_by(V1) %>%
    dplyr::summarise(across(
      .cols = everything(),
      .fns = ~ {
        vals <- unique(.x[.x != "-" & .x != "" & !is.na(.x)])
        if (length(vals) == 0) "-" else paste(vals, collapse = ";")
      }
    )) %>%
    dplyr::filter(!V1 %in% GO.mollusca$V1)
  
  GO.all <- rbind(GO.mollusca, GO)
  
  return(GO.all)
}

# Merging blast & EggNog annotations
Full_annot <- function(Blast,Eggnog,GOswiss){
  
  a <- merge(Blast,Eggnog, by="Transcript", all=TRUE, no.dups=TRUE)
  
  a <- a %>%
    dplyr::mutate(GO = ifelse(ProteinCode %in% GOswiss$V1, GOswiss$V2, GOs))
  
  return(a)
  
}

