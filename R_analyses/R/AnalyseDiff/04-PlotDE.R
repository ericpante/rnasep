###################################################

# Plotting results from the DE analysis

###################################################


# Heatmap
HeatDEG <- function(x, DEG, ncutrow, ncutcol, rows=TRUE){
  
  vsd <- vst(x)
  a <- assay(vsd) %>%
    as.data.frame() %>%
    rownames_to_column(var="ID") %>%
    filter(ID %in% DEG$ID)
  
  rownames(a)=a$ID
  
  Matrix <- a %>%
    dplyr::select(-ID)
  
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
