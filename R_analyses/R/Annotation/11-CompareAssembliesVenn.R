###############################################################################
#
# Script dedicated to the display of Venn diagram to compare Trinity assemblies
# from rnasep1 & 2
#
###############################################################################

# Build and display Venn diagram.
displayVenn <- function(fileA, fileB, fileC){
  
  # Loading files
  RBH <- read.delim(fileA, header=FALSE)
  sep1ALL <- read.delim(fileB, header=FALSE)
  sep2ALL <- read.delim(fileC, header=FALSE)

  # Creating the list of RBH with common IDs for sep1 & 2
  RBHV1 <- as.data.frame(RBH$V1)
  colnames(RBHV1) <- "ID"
  
  
  # Building list of transcripts to be used in Venn
  sep1Tidy <- sep1ALL %>%
    dplyr::rename(ID = V1) %>%
    dplyr::filter(!ID %in% RBH$V1) %>%
    dplyr::mutate(ID = paste(ID, "_sep1", sep=""))
  
  sep1 <- rbind(sep1Tidy, RBHV1)

  sep2Tidy <- sep2ALL %>%
    dplyr::rename(ID = V1) %>%
    dplyr::filter(!ID %in% RBH$V2) %>%
    dplyr::mutate(ID = paste(ID, "_sep2", sep=""))
  
  sep2 <- rbind(sep2Tidy, RBHV1)
  
  # Creating list for Venn
  VennData <- list(
    A=sep1$ID,
    B=sep2$ID)
  
  # Specifying the name for each component of the list
  names(VennData) <- c("Newly hatched", "One-month-old")
  
  library(ggvenn)
  
  ggvenn(
    VennData,
    columns = c("Newly hatched", "One-month-old"),
    show_stats = "c",
    fill_color = c("#46ACC8", "#E58601"),
    fill_alpha=0.5,
    auto_scale = FALSE,
    stroke_size = 0.3,
    set_name_size = 6,
    text_size = 5,
    padding=0.6
  )
}


displaySpecific <- function(fileA, fileB, fileC, exp="SEP1"){

  RBH <- read.delim("data/annotation/RBH_pairs.tsv", header=FALSE)
  ALL <- read.delim("data/annotation/SEP1_all_ids_clean.txt", header=FALSE)
  spec <- read.delim("data/annotation/SEP1_specific_nohit.txt", header=FALSE)
  
  if(exp == "SEP1"){
    alltidy <- ALL %>%
    dplyr::rename(ID = V1) %>%
    dplyr::filter(!ID %in% RBH$V1) %>%
    dplyr::mutate(type = ifelse(ID %in% spec$V1,
                                "specific",
                                "not specific"),
                  n = 1)
  } else {
    alltidy <- ALL %>%
      dplyr::rename(ID = V1) %>%
      dplyr::filter(!ID %in% RBH$V2) %>%
      dplyr::mutate(type = ifelse(ID %in% spec$V1,
                                  "specific",
                                  "not specific"),
                    n = 1)
  }
  
  x <- nrow(alltidy)
  
  sep.plot <- alltidy %>%
    group_by(type) %>%
    summarise(Percent = (sum(n)/x)*100)
  
  sep.plot %>%
    ggplot(aes(x=type, y=Percent, fill=type)) +
    geom_col(just = 0.5) +
    theme_minimal() +
    theme(legend.position = "none",
          axis.text = element_text(size = 11),
          text = element_text(size=12),
          panel.grid = element_blank(),
          axis.line.x.bottom = element_line(),
          axis.line.y.left = element_line()) +
    scale_fill_manual(values=c("#DD8D29", "#E2D200")) +
    scale_y_continuous(breaks = c(20,40,60,80)) +
    labs(y="% ORFs",
         x="")
}
