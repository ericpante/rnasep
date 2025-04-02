########################################

# Tidying REACTOME output file

#######################################


# Tidying Reactome output
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