
# Retrieve ontology
ontology <- function(obo){
  
  x <- get_ontology(obo, propagate_relationships = c("is_a", "part_of"))
  
  return(x)
}

# Retrieve object containing all, among which namespaces
namespace <- function(obo){

  get_OBO(obo,
          extract_tags = "everything")
  
}

# retrieve the list of GOs of interest
ListGOs <- function(ANNOT, speFile, ANNOT2 = NULL, specific = FALSE, NAMESPACE, ONT = c("biological_process", "molecular_function", "cellular_component")) {
  #ANNOT <- tar_read(FullAnnot)
  #ANNOT2 <- tar_read(FullAnnot.SEP1)
  #speFile <- tar_read(file14)
  
  SPE <- read.delim(speFile, header=FALSE)
  
  if(specific == TRUE){
    
    y <- ANNOT2 %>%
      dplyr::select(GO) %>%
      tidyr::separate_rows(GO, sep=";") %>%
      tidyr::separate_rows(GO, sep=",") %>%
      dplyr::filter(GO != "-")
    
    x <- ANNOT %>%
      dplyr::filter(Transcript %in% SPE$V1) %>%
      dplyr::select(GO) %>%
      tidyr::separate_rows(GO, sep=";") %>%
      tidyr::separate_rows(GO, sep=",") %>%
      dplyr::filter(GO != "-") %>%
      dplyr::filter(!GO %in% y$GO)
  } else {
    x <- ANNOT %>%
      dplyr::filter(Transcript %in% SPE$V1) %>%
      dplyr::select(GO) %>%
      tidyr::separate_rows(GO, sep=";") %>%
      tidyr::separate_rows(GO, sep=",") %>%
      dplyr::filter(GO != "-")
  }
  
  A <- NAMESPACE
  z <- x %>%
    dplyr::filter(GO %in% A$id[A$namespace == ONT])
  
  
  return(z)
}


# Retrive the level of each GO
getGOlevel <- function(goFile, ontFile){
  
  FUN <- function(go_id, ontology) {
    ancestors <- get_ancestors(ontology, go_id)
    # level = number of "is_a" links until root
    level <- length(ancestors)
    return(level)
  }
  
  x <- sapply(unique(goFile$GO), FUN, ontology = ontFile)
  
  return(x)
}

################################################################################
# Construct macro mapping table:
macroMap <- function(ANNOT, ontFile, TARGET1, TARGET2){
  
  mapGOtoMacro <- function(go_id, ontology, target_level = 2) {
    ancestors <- get_ancestors(ontology, go_id)
    ancestors <- c(go_id, ancestors)
    # chercher le premier ancêtre au niveau cible
    for (anc in ancestors) {
      if (length(get_ancestors(ontology, anc)) == target_level - 1) {
        return(anc)
      }
    }
    return(NA)
  }
  
  x.1 <- as.data.frame(sapply(unique(ANNOT$GO), mapGOtoMacro, ontology=ontFile, target_level=TARGET1))
  colnames(x.1) <- "macro"
  x.1 <- x.1 %>%
    tibble::rownames_to_column(var="GO") %>%
    dplyr::filter(macro != "NA")
  
  x.2 <- as.data.frame(sapply(unique(ANNOT$GO), mapGOtoMacro, ontology=ontFile, target_level=TARGET2))
  colnames(x.2) <- "macro"
  x.2 <- x.2 %>%
    tibble::rownames_to_column(var="GO") %>%
    dplyr::filter(macro != "NA")
  
  ANNOT. <- ANNOT %>%
    dplyr::filter(GO %in% x.1$GO)
  
  y.x1 <- merge(ANNOT., x.1, all.x = TRUE)
  colnames(y.x1) <- c("GO", "Macro.6")
  y.x1.x2 <- merge(y.x1, x.2, all.x=TRUE)
  colnames(y.x1.x2) <- c("GO", "Macro.6", "Macro.2")
  
  y.x1.x2OK <- y.x1.x2 %>%
    dplyr::mutate(GO_name = ontFile$name[GO],
                  Macro_name.6 = ontFile$name[Macro.6],
                  Macro_name.2 = ontFile$name[Macro.2]) %>%
    dplyr::group_by(Macro_name.6, GO_name) %>%
    dplyr::summarise(Count = dplyr::n(), .groups = "drop") %>%
    dplyr::arrange(desc(Count)) %>%
    dplyr::mutate(Type = "Specific") 
  
  return(y.x1.x2OK)
}

plotMacro <- function(file){
  
  x <- file
  
  x.top <- x[1:20,]
  
  n_colors <- length(unique(x.top$Macro_name.6))   
  pal_extended <- colorRampPalette(wes_palette("Cavalcanti1"))(n_colors)
  
  x.top %>%
    ggplot(aes(Type, GO_name, size = Count, color = Macro_name.6)) +
    geom_point() +
    theme(axis.text.x = element_text(size = 12),
          axis.text.y = element_text(size=14)) +
    scale_color_manual(values=pal_extended) +
    theme_bw(base_size=14) +
    labs(
      x = "",
      y = "Biological Process (lvl 6)",
      color = "BP category (lvl 2)",
      size = "Nb of genes"
    )
  
}

