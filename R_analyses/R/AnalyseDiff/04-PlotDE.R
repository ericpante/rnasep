###################################################

# Plotting results from the DE analysis

###################################################


# Heatmap
HeatDEG <- function(dds, X, DEG, Annot, ncutrow, ncutcol, rows = TRUE) {
  vsd <- vst(dds)
  a <- assay(vsd) %>%
    as.data.frame() %>%
    select(X) %>%
    tibble::rownames_to_column(var = "ID") %>%
    filter(ID %in% DEG$ID)

  valid_mapping <- Annot[Annot$product != "Hypothetical protein", c(1,6)]
  
  VM <- valid_mapping %>%
    dplyr::group_by(gene) %>%
    summarise(product = paste(sort(unique(product)), collapse = "/"))
  
  T2P <- setNames(VM$product, VM$gene)
  

  a$ID <- ifelse(a$ID %in% names(T2P),
    T2P[a$ID],
    a$ID
  )

  b <- a %>%
    dplyr::group_by(ID) %>%
    dplyr::mutate(ID = paste0(ID, "_", dplyr::row_number())) %>%
    dplyr::ungroup() %>%
    as.data.frame()


  rownames(b) <- b$ID

  Matrix <- b %>%
    select(-ID)

  pheatmap::pheatmap((Matrix), # Modify parameters as convenience
    cluster_cols = TRUE,
    clustering_distance_rows = "correlation",
    clustering_distance_cols = "euclidean",
    cluster_rows = TRUE,
    scale = "row",
    border_color = "grey",
    # color=colorRampPalette(c("#7294D4","#D5D5D3","#E6A0C4")) (100),
    color = colorRampPalette(c("#046C9A", "#D5D5D3", "#FD6467"))(100),
    cutree_rows = ncutrow,
    cutree_cols = ncutcol,
    drop_levels = TRUE,
    legend = TRUE,
    fontsize = 9,
    cellwidth = 20,
    angle_col = 45,
    show_rownames = rows
  )
}


# Summarise number of DEG for each contrast

SumDEG <- function(A, B, C) {
  A <- A %>%
    as.data.frame()

  B <- B %>%
    as.data.frame()

  C <- C %>%
    as.data.frame()

  A$Trend <- ifelse(A$log2FoldChange > 0, "Up-regulated", "Down-regulated")
  A$Condition <- "pCO2+MeHg"
  B$Trend <- ifelse(B$log2FoldChange > 0, "Up-regulated", "Down-regulated")
  B$Condition <- "MeHg"
  C$Trend <- ifelse(C$log2FoldChange > 0, "Up-regulated", "Down-regulated")
  C$Condition <- "pCO2"

  dat <- rbind(A, B, C) %>%
    mutate(nb = 1) %>%
    select(Condition, Trend, nb) %>%
    group_by(Condition, Trend) %>%
    summarise(nobs = sum(nb))

  dat %>%
    ggplot(aes(x = Condition, y = nobs, fill = Trend)) +
    geom_col(position = "dodge", color = "white") +
    theme_bw(base_size=14) +
    scale_fill_manual(values = c("#046C9A", "#FD6467")) +
    annotate("text", x = 0.8, y = 7, label = "4", color = "black", size = 6, fontface = "bold") +
    annotate("text", x = 1.2, y = 7, label = "4", color = "black", size = 6, fontface = "bold") +
    annotate("text", x = 1.8, y = 7, label = "4", color = "black", size = 6, fontface = "bold") +
    annotate("text", x = 2.2, y = 7, label = "4", color = "black", size = 6, fontface = "bold") +
    annotate("text", x = 2.8, y = 247, label = "244", color = "black", size = 6, fontface = "bold") +
    annotate("text", x = 3.2, y = 46, label = "43", color = "black", size = 6, fontface = "bold") +
    theme(axis.text.x = element_text(size=10),
          axis.text.y = element_text(size=10),
          axis.title.y = element_text(size=12)) +
    labs(
      x = "",
      y = "Differentially expressed genes"
    )
}