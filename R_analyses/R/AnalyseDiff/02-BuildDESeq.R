###################################################

# Building DESeq file

###################################################

# Build the DESeq operational file:
BuildDESeq <- function(ST, DIR, DES, relevel_treatment=TRUE, factor_treatment=FALSE) {
 X <- DESeqDataSetFromHTSeqCount(
    sampleTable = ST,
    directory = DIR,
    design = DES
  )
 
 if(relevel_treatment){
   X$Treatment <- relevel(X$Treatment, ref="CT8.1")
 
   }
 
 if(factor_treatment == TRUE){
   X$pCO2 <- as.factor(X$pCO2)
 }
 
 return(X)
}

StarToExp <- function(STAR) {
  star <- STAR
  # star <- estimateSizeFactors(star)
  # star <- estimateDispersions(star)

  # idx <- rowSums(counts(star,normalized=TRUE) >= 10 ) >= 1
  # star <- star[idx,]

  vsd <- vst(star)

  assay(vsd) %>%
    t()
}
