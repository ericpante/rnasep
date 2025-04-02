########################################

# Loading REACTOME output file

#######################################


# Loading Reactome output
load_reac <- function(file){
  read.csv(file, sep=";")
}