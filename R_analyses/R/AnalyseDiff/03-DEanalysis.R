###################################################

# Running DESeq

###################################################

# Preforming differential expression analysis
DEanalysis <- function(X, TEST){
  
  DESeq(X, test=TEST)
  
}


# Retrieving list of differentialy expressed genes
RetrieveDEG <- function(dds,  NAME, THRESHOLD){
  
  Res <- results(dds, name=NAME)
  
  Res %>% # This objet contains every genes influences Treatment
    data.frame() %>%
    tibble::rownames_to_column(var="ID") %>%
    dplyr::arrange(padj) %>%
    dplyr::filter(padj<0.05 &
           abs(log2FoldChange) >0.5) %>%
    dplyr::select(ID, log2FoldChange)
  
}

  
