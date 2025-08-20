###################################################

# Building DESeq file

###################################################

# Build the DESeq operational file:
BuildDESeq <- function(ST, DIR) {
  DESeqDataSetFromHTSeqCount(
    sampleTable = ST,
    directory = DIR,
    design = ~Treatment
  )
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
