#####################################################
#
#   Retrieving Hub genes for each trait             #
#
#####################################################


## After having defined the significant modules for each trait based on the correlation matrix

## Calculate Module Membership
ModuleMembership <- function(ModuleEigen, Exp.Matrix, cols, R){

  modNames = substring(names(ModuleEigen), 3) #extract module names
  
  nSamples=nrow(Exp.Matrix)

  geneModuleMembership = as.data.frame(cor(Exp.Matrix, ModuleEigen, use="p"))
  
  names(geneModuleMembership) = paste("MM", modNames, sep="")
  
  return(geneModuleMembership)

#  ggm = geneModuleMembership[, cols]  
#  ggm[apply(ggm, 1, function(x) any(abs(x) >= R)),]
  
  
}


# Retrieve hub genes based on KME:
HubGenes <- function(Colors, Mod, MM, Module, Variable, Percent, Annot){
  Col <- Colors %>%
    rownames_to_column(var="Gene") %>%
    filter(. == Mod)
  
  Hub <- MM %>%
    select({{ Module }}) %>%
    rownames_to_column(var="Gene") %>%
    filter(Gene %in% Col$Gene) %>%
    filter({{Variable}} >= quantile({{Variable}}, Percent, na.rm=TRUE))
  
  valid_mapping <- Annot[!is.na(Annot$Preferred_name) & Annot$Preferred_name != "-",]
  transcript_to_preferred <- setNames(valid_mapping$Preferred_name, valid_mapping$Transcript)
  
  Hub$Gene <- ifelse(Hub$Gene %in% names(transcript_to_preferred),
                     transcript_to_preferred[Hub$Gene],
                     Hub$Gene)
  return(Hub)
}    


## Create reduced adjacency and TOM matrices
TOMsub <- function(Colors, Mod, TOMDISSIM){
  
  #selected_genes <- HUB[,1] #Create vector of hubgenes
  
  Col <- Colors %>% # To retreive only genes belonging to the specific module
    tibble::rownames_to_column(var="Gene") %>%
    dplyr::filter(. == Mod)
  
  selected_genes <- Col[,1] 
  
  TOM <- 1-TOMDISSIM # Similarity
  
  TOM[selected_genes, selected_genes]
  
}

## Export reduced TOM toward Cytoscape
ExportTOMtoCyto <- function(TOMSUB, Annot, Mod, PATH1, PATH2, Colors, THRLD){
  
  Col <- Colors %>%
    rownames_to_column(var="Gene") %>%
    dplyr::filter(. == Mod)
  
  valid_mapping <- Annot[!is.na(Annot$Preferred_name) & Annot$Preferred_name != "-",]
  transcript_to_preferred <- setNames(valid_mapping$Preferred_name, valid_mapping$Transcript)
  
Col$Gene <- ifelse(Col$Gene %in% names(transcript_to_preferred),
                     transcript_to_preferred[Col$Gene],
                     Col$Gene)
  
  selected_genes <- Col[,1]
  
  colnames(Col) <- c("Gene", "Module")
 
  ColData <- setNames(Col$Module, Col$Gene)
  
  exportNetworkToCytoscape(TOMSUB,
                           edgeFile=PATH1,
                           nodeFile=PATH2,
                           weighted=TRUE,
                           threshold=THRLD,
                           nodeNames=selected_genes,
                           nodeAttr=ColData[selected_genes])
}


NodAttr <- function(Colors, Annot, GMM, Mod, Vars, PATH){
  
  Col <- Colors %>%
    tibble::rownames_to_column(var="Gene") %>%
    dplyr::filter(. == Mod)
  
  selected_genes <- Col[,1]
  
  nodAttr <- GMM %>%
    tibble::rownames_to_column(var="Gene") %>%
    dplyr::filter(Gene %in% selected_genes) %>%
    dplyr::select(all_of(Vars)) %>%
    as.data.frame() %>%
    mutate(Size=70)
  
  colnames(nodAttr) <- c("name", "kME", "Size")

  valid_mapping <- Annot[!is.na(Annot$Preferred_name) & Annot$Preferred_name != "-",]
  transcript_to_preferred <- setNames(valid_mapping$Preferred_name, valid_mapping$Transcript)
  
  nodAttr$name <- ifelse(nodAttr$name %in% names(transcript_to_preferred),
                     transcript_to_preferred[nodAttr$name],
                     nodAttr$name)
      
    
  
  write.table(nodAttr, PATH, sep="\t", row.names=FALSE, quote=FALSE)
  
}



## Calculate Gene-Trait Significance
TraitSignificance <- function(TraitData, Exp.Matrix, R) {
  TraitVar = as.data.frame(TraitData)
  
  geneTraitSignificance = as.data.frame(cor(Exp.Matrix, TraitVar, use = "p")) %>%
    filter(abs(TraitData) >= R)
  
  names(geneTraitSignificance) = paste("GS.", names(TraitVar), sep="")
  
  return(geneTraitSignificance)
 
}

