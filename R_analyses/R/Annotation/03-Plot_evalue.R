####################################

# Ploting evalue distribution

###################################

PlotEvalue<- function(data){
  ggplot(data=data, aes(x="", y=prop, fill=class)) +
    geom_bar(width=1, stat="identity", color="white") +
    coord_polar("y", start=0) +
    geom_text(aes(y = lab.ypos, label=prop), color="white") +
    scale_fill_manual(values=wes_palette(n=4, name="GrandBudapest2")) +
    theme_void()
}
