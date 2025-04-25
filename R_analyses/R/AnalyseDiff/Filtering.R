###################################################

# Counts normalization

###################################################

# filtering low count reads:
lowCountsFilter <- function(star){
  star <- estimateSizeFactors(star)
  star <- estimateDispersions(star)
  
  idx <- rowSums(counts(star,normalized=TRUE) >= 10 ) >= 2
  star[idx,]
  return(star)
}

