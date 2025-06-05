#####################################

# Preparing files for GOMWU analysis

####################################


# Gene to GO list

goMWU <- function(dds,NAME,GO){
  
  Res <- results(dds, name=NAME) %>%
    data.frame() %>%
    rownames_to_column(var="ID") %>%
    dplyr::filter(pvalue != "NA")
  
  GO %>%
    data.frame() %>%
    dplyr::filter(GOs != "NA" & GOs != "-" & Transcript %in% Res$ID) %>%
    dplyr::select(Transcript, GOs) %>%
    dplyr::mutate(GOs=str_replace_all(GOs, ",", ";"))
  
  
}

# Complete list of analyzed genes

geneMWU <- function(dds, NAME, THRESHOLD, Ref){
  
  Res <- results(dds, name=NAME) %>% # This objet contains all the genes influences by Treatment
    data.frame() %>%
    rownames_to_column(var="ID") %>%
    arrange(padj) %>%
    dplyr::filter(pvalue != "NA") %>%
    dplyr::select(ID, log2FoldChange) %>%
    dplyr::filter(ID %in% Ref$Transcript)
  
}



# Export Go table
ExportGO <- function(X, FILE){
  
  write.table(X, file=FILE, sep = "\t", quote = FALSE, row.names=FALSE, col.names=TRUE)
  
}

# Export Gene table
ExporteGENE <- function(X, FILE){
  
  write.csv(X, file=FILE, sep = ",", quote = FALSE, row.names=FALSE)
}