#####################################

# Export graphics

####################################

PlotExport <- function(file, plot, W = NA, H = NA, U = c("in", "cm", "mm", "px"), DPI=300){
  ggsave(file, plot, dpi=DPI, width = W, height = H, units = U)
}