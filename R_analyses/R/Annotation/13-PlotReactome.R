####################################

# Ploting Reactome main results

###################################

data=tar_read(ReactomeTidy)
PlotReac<- function(data){
    ggplot(data=data, aes(x=reorder(Pathway, Entities), y=Entities)) +
    geom_col(width=1, fill=wes_palette(n=1, name="GrandBudapest2"), color="white") +
    coord_flip() +
    theme_bw() +
    labs(y="Number of entities found",
         x="Main pathway categories")
}


