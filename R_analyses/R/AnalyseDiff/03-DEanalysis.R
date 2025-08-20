###################################################

# Running DESeq

###################################################

# Preforming differential expression analysis
DEanalysis <- function(X, TEST) {
  DESeq(X, test = TEST)
}


# Retrieving list of differentialy expressed genes
RetrieveDEG <- function(dds, NAME, THRESHOLD) {
  Res <- results(dds, name = NAME)

  Results <- Res %>% # This objet contains every genes influences Treatment
    data.frame() %>%
    rownames_to_column(var = "ID") %>%
    arrange(padj) %>%
    filter(padj < 0.05 &
      abs(log2FoldChange) > 0.5) %>%
    select(ID, log2FoldChange)


  return(Results)
}

AnnotDE <- function(DEG, Annot) {
  valid_mapping <- Annot[!is.na(Annot$ProteinCode) & Annot$ProteinCode != "-", ]
  transcript_to_preferred <- setNames(valid_mapping$ProteinCode, valid_mapping$Transcript)

  Res <- DEG
  Res$ID <- ifelse(Res$ID %in% names(transcript_to_preferred),
    transcript_to_preferred[Res$ID],
    Res$ID
  )

  return(Res)
}
