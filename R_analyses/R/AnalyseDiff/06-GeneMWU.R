#####################################

# Preparing files for GOMWU analysis

####################################


# Gene to GO list

goMWU <- function(dds, NAME, GO) {
  Res <- results(dds, name = NAME) %>%
    data.frame() %>%
    rownames_to_column(var = "ID") %>%
    dplyr::filter(pvalue != "NA")

  GO %>%
    data.frame() %>%
    dplyr::filter(GOs != "NA" & GOs != "-" & Transcript %in% Res$ID) %>%
    dplyr::select(Transcript, GOs) %>%
    dplyr::mutate(GOs = str_replace_all(GOs, ",", ";"))
}


# Complete list of analyzed genes

geneMWU <- function(dds, NAME, THRESHOLD, Ref) {
  Res <- results(dds, name = NAME) %>% # This objet contains all the genes influences by Treatment
    data.frame() %>%
    rownames_to_column(var = "ID") %>%
    arrange(padj) %>%
    dplyr::filter(pvalue != "NA") %>%
    dplyr::select(ID, log2FoldChange) %>%
    dplyr::filter(ID %in% Ref$Transcript)
}

# Complete list of WGCNA analysed genes with value of belonging (1, 0)
moduleMWU <- function(ALL, module, value) {
  Gene <- rownames(ALL) %>%
    as.data.frame() %>%
    dplyr::rename(ID = ".") %>%
    dplyr::mutate(Value = ifelse(ID %in% rownames(module),
      ALL[[value]],
      0
    ))

  colnames(Gene) <- c("ID", "Value")

  return(Gene)
}

# Module to GO list
ModuleGO <- function(GO, GENES) {
  GO %>%
    data.frame() %>%
    dplyr::filter(GOs != "NA" & GOs != "-" & Transcript %in% GENES$ID) %>%
    dplyr::select(Transcript, GOs) %>%
    dplyr::mutate(GOs = str_replace_all(GOs, ",", ";"))
}



# Export Go table
ExportGO <- function(X, FILE) {
  write.table(X, file = FILE, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)
}

# Export Gene table
ExporteGENE <- function(X, FILE) {
  write.csv(X, file = FILE, sep = ",", quote = FALSE, row.names = FALSE)
}



# Gene to KOG class list
KOG <- function(KO, CLASS) {
  class <- read.delim(CLASS) %>%
    as.data.frame()

  kog <- KO %>%
    data.frame() %>%
    dplyr::filter(COG_category != "NA" & COG_category != "-") %>%
    dplyr::select(Transcript, COG_category) %>%
    dplyr::mutate(COG_category = sapply(COG_category, function(x) paste(strsplit(COG_category, "")[[1]], collapse = ","))) %>%
    tidyr::separate_rows(COG_category, sep = ",")

  kog$COG_category <- ifelse(kog$COG_category %in% class$KOG_letter,
    class$KOG_class,
    kog$COG_category
  )
  return(kog)
}


# Running KOGMWU
KOGMWU <- function(GeneToKOG, ModuleGeneToKOG) {
  kog.mwu(ModuleGeneToKOG, GeneToKOG)
}