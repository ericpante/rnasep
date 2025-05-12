#####################################@##############

# Summarizing and ploting proportion of transcripts annotated per annotation type

####################################################


SumAnnotation <- function(Annotation){
  
  blast <- as.data.frame(Annotation) %>%
    filter(ProteinCode != "NA")
  
  BLAST <- nrow(blast)
  
  EggNog <- as.data.frame(Annotation) %>%
    filter(COG_Description != "NA",
           COG_Description != "-")
  
  EGGNOG <- nrow(EggNog)
  
  GO <- as.data.frame(Annotation) %>%
    filter(GOs != "NA",
           GOs != "-")
  
  go <- nrow(GO)
  
  kegg_ko <- as.data.frame(Annotation) %>%
    filter(KEGG_ko != "NA",
           KEGG_ko != "-")
  
  KEGG_KO <- nrow(kegg_ko)
  
  kegg_pathway <- as.data.frame(Annotation) %>%
    filter(KEGG_Pathway != "NA",
           KEGG_Pathway != "-")
  
  KEGG_PATHWAY <- nrow(kegg_pathway)
  
 pfam <- as.data.frame(Annotation) %>%
    filter(PFAMs != "NA",
           PFAMs != "-")
  
  PFAM <- nrow(pfam)
  
  Annot <- c("Blast (UniProt)", "EggNog", "GO", "KEGG_ko", "KEGG_pathway", "PFAM")
  Occurrence <- c(BLAST,EGGNOG,go,KEGG_KO,KEGG_PATHWAY,PFAM)
  
  AnnotationSummary <- data.frame(Annot, Occurrence) %>%
    mutate(Prop=(Occurrence*100)/49402)
  
  ggplot(AnnotationSummary, aes(x=reorder(Annot, Prop, decreasing = TRUE), y=Prop)) +
    geom_col(width=0.9, fill=wes_palette(n=6, name="BottleRocket1"), color="white") +
    coord_flip() +
    theme(axis.title.x=element_text(size=9),
          axis.title.y=element_text(size=9)) +
    theme_bw() +
    labs(y="Percentage of transcripts",
         x="Annotation type")
    
}