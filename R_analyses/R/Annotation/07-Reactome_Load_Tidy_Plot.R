########################################

# Loading, tidying & plotting REACTOME output file

#######################################


# 1- Loading Reactome output
load_reac <- function(file){
  read.csv(file, sep=";")
}


# 2- Tidying Reactome output
tidy_reac <- function(data){
  as.data.frame(data) %>%
    select(Pathway.name,X.Entities.found) %>%
    rename(Pathway = Pathway.name,
           Entities = X.Entities.found) %>%
    filter(Pathway == "Signal Transduction" | Pathway == "Metabolism" | Pathway == "Immune System" |
             Pathway == "Metabolism of proteins" | Pathway == "Gene expression (Transcription)" |
             Pathway == "Cell Cycle" | Pathway == "Transport of small molecules" | Pathway == "Neuronal System" |
             Pathway == "DNA Repair" | Pathway == "Development Biology" | Pathway == "Metabolism of RNA" |
             Pathway == "Vesicle-mediated transport" | Pathway == "Cellular responses to stimuli" | Pathway == "Hemostasis" |
             Pathway == "Programmed Cell Death" | Pathway == "Extracellular matrix organization" |
             Pathway == "DNA Replication" | Pathway == "Muscle contration" | Pathway == "Organelle biogenesis and maintenance" |
             Pathway == "Cell-Cell communication" | Pathway == "Sensory Perception" | Pathway == "Chromatin organization" |
             Pathway == "Autophagy" | Pathway == "Protein localization" | Pathway == "Digestion and absorption" |
             Pathway == "Immune System") %>%
    arrange(desc(Entities))
}

# 3- Ploting Reactome main results
data=tar_read(ReactomeTidy)
PlotReac<- function(data){
  ggplot(data=data, aes(x=reorder(Pathway, Entities), y=Entities)) +
    geom_col(width=1, fill=wes_palette(n=1, name="GrandBudapest2"), color="white") +
    coord_flip() +
    theme_bw() +
    labs(y="Number of entities found",
         x="Main pathway categories")
}
