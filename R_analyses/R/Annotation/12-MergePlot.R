#####################################################
#
# Preparing grouped plots for publication
#
#####################################################

# Merging plots
mergePlot <- function(plot1,plot2,...,NROW, LABELS){
  plot_grid(plot1,plot2, nrow=NROW, labels=LABELS)
}

