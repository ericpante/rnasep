###################################################

# Loading the data and metadata files

###################################################

# Function to read the metadata file
ReadMeta <- function(file){
read.table(file, header = T, sep="\t")
}

# Function to tidy metadata file
tidyMeta <- function(meta,A,B){
  Meta <- meta %>%
    mutate(SampleName = paste(SampleName,"-",Treatment)) %>%
    filter(Treatment == A | Treatment == B)
  rownames(Meta) <-  Meta$SampleName
  
  return(Meta)
}

tidyMeta2 <- function(meta){
  rownames(meta) <- meta$SampleName
  
  return(meta)
}

