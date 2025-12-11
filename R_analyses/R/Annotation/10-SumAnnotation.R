#####################################@##############

# Summarizing and ploting proportion of transcripts annotated per annotation type

####################################################

SumAnnotation <- function(Annotation, ORF){
  
  blast <- as.data.frame(Annotation) %>%
    dplyr::filter(ProteinCode != "NA")
  
  BLAST <- nrow(blast)
  
  EggNog <- as.data.frame(Annotation) %>%
    dplyr::filter(COG_Description != "NA",
           COG_Description != "-")
  
  EGGNOG <- nrow(EggNog)
  
  GOs <- as.data.frame(Annotation) %>%
    dplyr::filter(GO != "NA",
           GO != "-")
  
  go <- nrow(GOs)
  
  kegg_ko <- as.data.frame(Annotation) %>%
    dplyr::filter(KEGG_ko != "NA",
           KEGG_ko != "-")
  
  KEGG_KO <- nrow(kegg_ko)
  
  kegg_pathway <- as.data.frame(Annotation) %>%
    dplyr::filter(KEGG_Pathway != "NA",
           KEGG_Pathway != "-")
  
  KEGG_PATHWAY <- nrow(kegg_pathway)
  
 pfam <- as.data.frame(Annotation) %>%
    dplyr::filter(PFAMs != "NA",
           PFAMs != "-")
  
  PFAM <- nrow(pfam)
  
  ALL <- nrow(as.data.frame(Annotation))
  
  Annot <- c("Blast (UniProt)", "EggNog", "GO", "KEGG_ko", "KEGG_pathway", "PFAM", "ALL")
  Occurrence <- c(BLAST,EGGNOG,go,KEGG_KO,KEGG_PATHWAY,PFAM,ALL)
  
  AnnotationSummary <- data.frame(Annot, Occurrence) %>%
    dplyr::mutate(Prop=(Occurrence*100)/ORF)
  
  ggplot(AnnotationSummary, aes(x=reorder(Annot, Prop, decreasing = TRUE), y=Prop)) +
    geom_col(width=0.9, fill=wes_palette(n=7, name="BottleRocket1"), color="white") +
    coord_flip() +
    scale_y_continuous(breaks = seq(0, 80, 20), limits = c(0, 80)) +
    theme(axis.title.x=element_text(size=9),
          axis.title.y=element_text(size=9)) +
        theme_bw() +
    labs(y="Percentage of ORFs",
         x="Annotation type")
    
}
