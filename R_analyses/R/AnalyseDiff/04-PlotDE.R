###################################################

# Plotting results from the DE analysis

###################################################


# Heatmap
HeatDEG <- function(dds, DEG, Annot, ncutrow, ncutcol, rows=TRUE){

  vsd <- vst(dds)
  a <- assay(vsd) %>%
    as.data.frame() %>%
    rownames_to_column(var="ID") %>%
    filter(ID %in% DEG$ID)

  valid_mapping <- Annot[!is.na(Annot$Preferred_name) & Annot$Preferred_name != "-",]
  transcript_to_preferred <- setNames(valid_mapping$Preferred_name, valid_mapping$Transcript)
  
  a$ID <- ifelse(a$ID %in% names(transcript_to_preferred),
                       transcript_to_preferred[a$ID],
                       a$ID)
  
  b <- a %>%
    dplyr::group_by(ID) %>%
    dplyr::mutate(ID = paste0(ID, "_", dplyr::row_number())) %>%
    dplyr::ungroup() %>%
    as.data.frame()
  
 
  rownames(b)=b$ID

  Matrix <- b %>%
    select(-ID)
  
  pheatmap((Matrix), # Modify parameters as convenience
           cluster_cols=TRUE,
           clustering_distance_rows = "correlation",
           clustering_distance_cols = "euclidean",
           cluster_rows=TRUE,
           scale="row",
           border_color = "grey",
           #color=colorRampPalette(c("#7294D4","#D5D5D3","#E6A0C4")) (100),
           color=colorRampPalette(c("#046C9A","#D5D5D3","#FD6467")) (100),
           cutree_rows = ncutrow,
           cutree_cols = ncutcol,
           drop_levels = TRUE,
           legend=TRUE,
           fontsize = 9,
           cellwidth =20,
           angle_col=45,
           show_rownames=rows)
}


# Summarise number of DEG for each contrast

SumDEG <- function(A, B, C){
  A <- A %>%
    as.data.frame()
  
  B <- B %>%
    as.data.frame()
  
  C <- C %>%
    as.data.frame()
  
  A$Trend <- ifelse(A$log2FoldChange > 0, "Up-regulated", "Down-regulated")
  A$Condition = "pCO2+MeHg"
  B$Trend <- ifelse(B$log2FoldChange > 0, "Up-regulated", "Down-regulated")
  B$Condition="MeHg"
  C$Trend <- ifelse(C$log2FoldChange > 0, "Up-regulated", "Down-regulated")
  C$Condition = "pCO2"
  
  dat <- rbind(A,B,C) %>%
    mutate(nb = 1) %>%
    select(Condition, Trend, nb) %>%
    group_by(Condition, Trend) %>%
    summarise(nobs=sum(nb))
  
  dat %>%
    ggplot(aes(x=Condition, y=nobs, fill=Trend)) +
    geom_col(position = "dodge", color="white") +
    theme_bw() +
    scale_fill_manual(values=c("#046C9A","#FD6467")) +
    annotate("text", x=0.8, y=7, label="2", color="black", size=4, fontface="bold") +
    annotate("text", x=1.2, y=7, label="3", color="black", size=4, fontface="bold") +
    annotate("text", x=1.8, y=9, label="5", color="black", size=4, fontface="bold") +
    annotate("text", x=2.2, y=14, label="10", color="black", size=4, fontface="bold") +
    annotate("text", x=2.8, y=258, label="254", color="black", size=4, fontface="bold") +
    annotate("text", x=3.2, y=65, label="61", color="black", size=4, fontface="bold") +
    labs(x="Condition",
         y="Differentially expressed genes")
}