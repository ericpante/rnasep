
###############################################################################

# Script dedicated to the construction and plot of a dataframe summarising the GO annotation.

###############################################################################

# Building a dataframe summarizing the GO annotation with important features
summarizeGO <- function(data, go){
  # retrieving GO terms from the FullAnnot
  Data <- data %>%
    dplyr::select(Transcript, GO) %>% 
    dplyr::filter(GO != "-") %>%
    tidyr::separate_rows(GO, sep=";") %>%
    tidyr::separate_rows(GO, sep=",") %>%
    dplyr::count(GO)
  
  # Adding Names and Namespaces to the GO terms
  Final <- merge(Data, go, by.x="GO", by.y="GO_term", all.x=TRUE)
  
  return(Final)
}


# Plotting the top 20 GO annotated terms for BP, MF & CC in on wrap plot
PlotGO <- function(data, NS1, NS2, NS3){

  
  x <- data %>%
    dplyr::filter(Namespace==NS1) %>%
    dplyr::arrange(desc(n)) %>%
    dplyr::rename(Description = Name)
  
  X <- x[2:21,]
  
  y <- data %>%
    filter(Namespace==NS2) %>%
    arrange(desc(n)) %>%
    dplyr::rename(Description = Name)
  
  Y <- y[2:21,]
  
  z <- data %>%
    filter(Namespace==NS3) %>%
    arrange(desc(n)) %>%
    dplyr::rename(Description = Name)
  
  Z <- z[2:21,]
  
  Sum <- rbind(X,Y,Z) %>%
    group_by(Namespace) %>%
    arrange(desc(n), .by_group=TRUE)
  
  Sum %>%
    ggplot(aes(x=reorder(Description, n), y=n/100, fill=Namespace)) +
    geom_col() +
    facet_wrap(~Namespace, scales="free", ncol=1) +
    scale_fill_manual(values=wes_palette(n=3, name="Cavalcanti1")) +
    theme_bw() +
    theme(axis.text.y=element_text(size=6),
          legend.position = "none",
          axis.title.x=element_text(size=9),
          axis.title.y=element_text(size=9)) +
    coord_flip() +
    labs(x="GO terms",
         y="Occurrences (x100)")
}
