#####################################

# Export graphics

####################################

PlotExport <- function(file, plot){
  ggsave(file, plot, dpi=300)
}