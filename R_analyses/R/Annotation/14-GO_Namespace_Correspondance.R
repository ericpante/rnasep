###################################################################################

# Retriving correspondance GO/Namespace in a dataframe format from the go.obo file

#################################################################################

#Extracting GO terms & namespaces from the .obo file
extract_GO_terms_and_namespaces <- function(file_path) {
  
  # Reading .obo
  go_data <- fread(file_path, sep = "\t", header = FALSE, fill = TRUE)
  
  # Creating variables to stock GO terms and Namespaces
  go_terms <- character(0)
  name <- character(0)
  namespaces <- character(0)
  
  # Creating variables to deal with file lines
  current_go_term <- NULL
  current_name <- NULL
  current_namespace <- NULL
  
  # Reading each line
  for (line in go_data$V1) {
    # Delete the "\" at the end of the lines
    line <- gsub("\\\\$", "", line) 
    
    # Looking for lines containing GO terms or Namespaces
    if (grepl("^id:", line)) {
      current_go_term <- gsub("^id: ", "", line)  # Extracting the GO term
    }
    if (grepl("^name:", line)) {
      current_name <- gsub("^name:", "", line) # Extracting the name
    }
    if (grepl("^namespace:", line)) {
      current_namespace <- gsub("^namespace: ", "", line)  # Extracting the Namespace
    }
    
    # Retrieving GO terms and their names and Namespaces if they are both present
    if (!is.null(current_go_term) && !is.null(current_namespace) && !is.null(current_name)) {
      go_terms <- c(go_terms, current_go_term)
      name <- c(name, current_name)
      namespaces <- c(namespaces, current_namespace)
      current_go_term <- NULL
      current_name <- NULL
      current_namespace <- NULL
    }
  }
  
  # Creating the final dataframe
  go_df <- data.frame(GO_term = go_terms, Name = name, Namespace = namespaces, stringsAsFactors = FALSE)
  go_df <- go_df[1:48030,]
  
  return(go_df)
}
