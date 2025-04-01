########################################

# Loading Blast output file

#######################################


# Loading blastx output
load_blast <- function(file){
  read.table(file, sep="\t")
}