###########################################################################################
#
# Script dedicated to the display of Venn diagram to compare DEGs between three conditions
#
#
###########################################################################################

################################
# Build Venn data from the DESeqDEG outputw
BuildVennData <- function(A, B, C) {
  x <- list(
    A$ID,
    B$ID,
    C$ID
  )

  return(x)
}
################################
# Displaying the VennDiagram
displayVenn <- function(Data) {
  
  names(Data) <- c("Hg+pCO2", "Hg", "pCO2")
  
  
  
a <-  ggvenn::ggvenn(
    Data,
    columns = c("Hg+pCO2", "Hg", "pCO2"),
    show_stats = "c",
    fill_color = c("#46ACC8", "#E58601", "red"),
    fill_alpha=0.6,
    auto_scale = FALSE,
    stroke_size = 0.3,
    stroke_color = "white",
    set_name_size = 12,
    text_size = 10,
    padding=0.2
  )

return(a)
  
}