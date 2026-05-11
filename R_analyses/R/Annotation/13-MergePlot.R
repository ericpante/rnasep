#####################################################
#
# Preparing grouped plots for publication
#
#####################################################

# Merging plots
mergePlot <- function(plot1,plot2,...,NROW, LABELS){
  #plot_grid(plot1,plot2, nrow=NROW, labels=LABELS)
  A <- plot1
  B <- plot2
  
  ggdraw() +
    draw_plot(A, x=0, y=0, width=0.56, height=1) +
    draw_plot(B, x=0.56, y=0, width=0.44, height=1) +
    draw_label(label="A)", x=0.04, y=0.95, size=20, fontface="bold") +
    draw_label(label="B)", x=0.60, y=0.95, size=20, fontface="bold")
  
}

# Merging plots
mergePlot1 <- function(plot1,plot2,...,NROW, LABELS){
  plot_grid(plot1,plot2, nrow=NROW, labels=LABELS)
  
}

# Merging plots
cowPlot <- function(P1, P2, P3, P4, P5){
  A <- P1 #<- tar_read(Venn)
  B <- P2 #<- tar_read(SEP1.spec)
  C <- P3 #<- tar_read(SEP2.spec)
  D <- P4 #<- tar_read(PlotMacroMap.SEP1)
  E <- P5 #<- tar_read(PlotMacroMap.SEP2)
  
  ggdraw() +
    draw_plot(B, x=0.15, y=0.6, width = 0.2, height = 0.25) +
    draw_plot(C, x=0.65, y=0.6, width=0.2, height=0.25) +
    draw_plot(D, x=0.04, y=0, width=0.47, height=0.6) +
    draw_plot(E, x= 0.54, y=0, width=0.45, height=0.6) +
    draw_plot(A, x=0.3, y=0.6, width=0.4, height=0.4)
}