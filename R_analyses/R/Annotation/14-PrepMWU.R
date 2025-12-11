
# Gene to GO list
GOMWU <- function(fileA, fileB, GOs) {
  
  ALL <- read.delim(fileA, header = FALSE)
  specific <- read.delim(fileB, header = FALSE)
  
  X <- ALL
  
  GOs %>%
    data.frame() %>%
    dplyr::filter(GO != "NA" & GO != "-" & Transcript %in% X$V1) %>%
    dplyr::select(Transcript, GO) %>%
    dplyr::mutate(GO = stringr::str_replace_all(GO, ",", ";"))
  
}

GENEMWU <- function(fileA, fileB, Ref) {
  
  ALL <- read.delim(fileA, header = FALSE)
  specific <- read.delim(fileB, header = FALSE)
  
  alltidy <- ALL %>%
    rename(ID = V1) %>%
    mutate(value = ifelse(ID %in% specific$V1,
                          1,
                          0)) %>%
    filter(ID %in% Ref$Transcript)
  
  return(alltidy)
}

outputGO <- function(X, FILE) {
  write.table(X, file = FILE, sep = "\t", quote = FALSE, row.names = FALSE, col.names = TRUE)
  
}

ExportGENE <- function(X, FILE) {
  write.csv(X, file = FILE, sep = ",", quote = FALSE, row.names = FALSE)
}

