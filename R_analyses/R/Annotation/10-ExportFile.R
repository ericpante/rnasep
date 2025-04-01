#####################################

# Exporting files

####################################

# Export file
FileExport <- function(data, file){
  write_delim(data, file, delim=";", quote="none", col_names=TRUE)
}
