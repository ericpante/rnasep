#####################################

# Preparing files for GOMWU analysis

####################################


# Gene to GO list

goMWU <- function(dds,  NAME, GO){
  
  Res <- results(dds, name=NAME) %>%
    data.frame() %>%
    rownames_to_column(var="ID") %>%
    filter(pvalue != "NA")
  
  GO %>%
    data.frame() %>%
    filter(GOs != "NA" & GOs != "-" & Transcript %in% Res$ID) %>%
    select(Transcript, GOs) %>%
    mutate(GOs=str_replace_all(GOs, ",", ";"))
  
  
}

# Complete list of analyzed genes

geneMWU <- function(dds, NAME, Ref){
  
  Res <- results(dds, name=NAME) %>% # This objet contains all the genes influences by Treatment
    data.frame() %>%
    rownames_to_column(var="ID") %>%
    arrange(padj) %>%
    filter(pvalue != "NA") %>%
    select(ID, log2FoldChange) %>%
    filter(ID %in% Ref$Transcript)
  
}


# Export Go table
ExportGO <- function(X, FILE){
  
  write.table(X, file=FILE, sep = "\t", quote = FALSE, row.names=FALSE, col.names=TRUE)
  
}

# Export Gene table
ExporteGENE <- function(X, FILE){
  
  write.csv(X, file=FILE, sep = ",", quote = FALSE, row.names=FALSE)
}